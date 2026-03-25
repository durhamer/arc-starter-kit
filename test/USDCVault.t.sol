// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/USDCVault.sol";

/// @dev 模擬 USDC Token 用於測試
contract MockUSDC is IERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowances;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function decimals() external pure returns (uint8) {
        return 6;
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

contract USDCVaultTest is Test {
    USDCVault public vault;
    MockUSDC public usdc;
    address public user = address(0xBEEF);
    uint256 public constant ONE_USDC = 1e6; // 6 decimals

    function setUp() public {
        usdc = new MockUSDC();
        vault = new USDCVault(address(usdc));

        // 給 user 100 USDC
        usdc.mint(user, 100 * ONE_USDC);
    }

    function testDeposit() public {
        vm.startPrank(user);
        usdc.approve(address(vault), 10 * ONE_USDC);
        vault.deposit(10 * ONE_USDC);
        vm.stopPrank();

        assertEq(vault.getBalance(user), 10 * ONE_USDC);
        assertEq(vault.totalDeposits(), 10 * ONE_USDC);
    }

    function testWithdraw() public {
        vm.startPrank(user);
        usdc.approve(address(vault), 10 * ONE_USDC);
        vault.deposit(10 * ONE_USDC);
        vault.withdraw(5 * ONE_USDC);
        vm.stopPrank();

        assertEq(vault.getBalance(user), 5 * ONE_USDC);
        assertEq(usdc.balanceOf(user), 95 * ONE_USDC);
    }

    function testCannotWithdrawMoreThanBalance() public {
        vm.startPrank(user);
        usdc.approve(address(vault), 10 * ONE_USDC);
        vault.deposit(10 * ONE_USDC);

        vm.expectRevert("Insufficient balance");
        vault.withdraw(20 * ONE_USDC);
        vm.stopPrank();
    }

    function testCannotDepositZero() public {
        vm.prank(user);
        vm.expectRevert("Amount must be > 0");
        vault.deposit(0);
    }

    function testDepositEvent() public {
        vm.startPrank(user);
        usdc.approve(address(vault), 10 * ONE_USDC);

        vm.expectEmit(true, true, true, true);
        emit USDCVault.Deposited(user, 10 * ONE_USDC);
        vault.deposit(10 * ONE_USDC);
        vm.stopPrank();
    }
}
