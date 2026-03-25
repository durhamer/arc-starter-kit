// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/PaymentSplitter.sol";

/// @dev 模擬 USDC Token
contract MockUSDC2 is IERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowances;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(balanceOf[from] >= amount, "Insufficient");
        require(allowances[from][msg.sender] >= amount, "Not approved");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowances[from][msg.sender] -= amount;
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowances[msg.sender][spender] = amount;
        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return allowances[owner][spender];
    }
}

contract PaymentSplitterTest is Test {
    PaymentSplitter public splitter;
    MockUSDC2 public usdc;

    address public alice = address(0xA11CE);
    address public bob = address(0xB0B);
    address public payer = address(0xPAE);

    uint256 public constant ONE_USDC = 1e6;

    function setUp() public {
        usdc = new MockUSDC2();

        address[] memory payees = new address[](2);
        payees[0] = alice;
        payees[1] = bob;

        uint256[] memory shares = new uint256[](2);
        shares[0] = 70; // Alice 70%
        shares[1] = 30; // Bob 30%

        splitter = new PaymentSplitter(address(usdc), payees, shares);

        // 給 payer 1000 USDC
        usdc.mint(payer, 1000 * ONE_USDC);
    }

    function testInitialState() public view {
        assertEq(splitter.payeeCount(), 2);
        assertEq(splitter.shares(alice), 70);
        assertEq(splitter.shares(bob), 30);
        assertEq(splitter.totalShares(), 100);
    }

    function testPayAndRelease() public {
        // Payer 發送 100 USDC
        vm.startPrank(payer);
        usdc.approve(address(splitter), 100 * ONE_USDC);
        splitter.pay(100 * ONE_USDC);
        vm.stopPrank();

        // Alice 應得 70 USDC
        assertEq(splitter.pending(alice), 70 * ONE_USDC);
        // Bob 應得 30 USDC
        assertEq(splitter.pending(bob), 30 * ONE_USDC);

        // Alice 領取
        vm.prank(alice);
        splitter.release();
        assertEq(usdc.balanceOf(alice), 70 * ONE_USDC);

        // Bob 領取
        vm.prank(bob);
        splitter.release();
        assertEq(usdc.balanceOf(bob), 30 * ONE_USDC);
    }

    function testNonPayeeCantRelease() public {
        address stranger = address(0xDEAD);
        vm.prank(stranger);
        vm.expectRevert("No shares");
        splitter.release();
    }
}
