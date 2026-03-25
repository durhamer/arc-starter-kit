// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title HelloArchitect
/// @notice 入門合約 — 在 Arc Testnet 上儲存與更新問候語
/// @dev 這是你在 Arc 上部署的第一個合約
contract HelloArchitect {
    string private greeting;
    address public owner;

    event GreetingChanged(address indexed sender, string newGreeting);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        greeting = "Hello Architect! Welcome to Arc.";
        owner = msg.sender;
    }

    /// @notice 更新問候語
    /// @param newGreeting 新的問候語字串
    function setGreeting(string memory newGreeting) public {
        greeting = newGreeting;
        emit GreetingChanged(msg.sender, newGreeting);
    }

    /// @notice 讀取當前問候語
    /// @return 當前儲存的問候語
    function getGreeting() public view returns (string memory) {
        return greeting;
    }

    /// @notice 取得合約擁有者
    /// @return 擁有者地址
    function getOwner() public view returns (address) {
        return owner;
    }
}
