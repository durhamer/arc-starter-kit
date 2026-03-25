// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./IERC20.sol";

contract PaymentSplitter {
    IERC20 public immutable usdc;
    address[] public payees;
    mapping(address => uint256) public shares;
    mapping(address => uint256) public released;
    uint256 public totalShares;
    uint256 public totalReleased;

    event PaymentReceived(address indexed from, uint256 amount);
    event PaymentReleased(address indexed to, uint256 amount);

    constructor(address _usdcAddress, address[] memory _payees, uint256[] memory _shares) {
        require(_payees.length == _shares.length, "Mismatched arrays");
        require(_payees.length > 0, "No payees");
        usdc = IERC20(_usdcAddress);
        for (uint256 i = 0; i < _payees.length; i++) {
            require(_payees[i] != address(0), "Zero address");
            require(_shares[i] > 0, "Share must be > 0");
            require(shares[_payees[i]] == 0, "Duplicate payee");
            payees.push(_payees[i]);
            shares[_payees[i]] = _shares[i];
            totalShares += _shares[i];
        }
    }

    function pay(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        require(usdc.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        emit PaymentReceived(msg.sender, amount);
    }

    function release() external {
        require(shares[msg.sender] > 0, "No shares");
        uint256 totalReceived = usdc.balanceOf(address(this)) + totalReleased;
        uint256 payment = (totalReceived * shares[msg.sender]) / totalShares - released[msg.sender];
        require(payment > 0, "Nothing to release");
        released[msg.sender] += payment;
        totalReleased += payment;
        require(usdc.transfer(msg.sender, payment), "Transfer failed");
        emit PaymentReleased(msg.sender, payment);
    }

    function pending(address account) external view returns (uint256) {
        if (shares[account] == 0) return 0;
        uint256 totalReceived = usdc.balanceOf(address(this)) + totalReleased;
        return (totalReceived * shares[account]) / totalShares - released[account];
    }

    function payeeCount() external view returns (uint256) {
        return payees.length;
    }
}
