// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title IERC20 — 最小化 ERC-20 介面
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function decimals() external view returns (uint8);
}

/// @title USDCVault
/// @notice USDC 金庫合約 — 示範如何在 Arc 上存入與提取 USDC
/// @dev Arc 上的 USDC ERC-20 介面地址: 0x3600000000000000000000000000000000000000 (6 decimals)
contract USDCVault {
    // Arc Testnet USDC ERC-20 介面
    IERC20 public immutable usdc;

    // 使用者存款餘額 (以 USDC 6 decimals 計)
    mapping(address => uint256) public balances;

    // 合約總存款
    uint256 public totalDeposits;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(address _usdcAddress) {
        usdc = IERC20(_usdcAddress);
    }

    /// @notice 存入 USDC 到金庫
    /// @param amount 存入金額（6 decimals，例如 1 USDC = 1000000）
    /// @dev 呼叫前需先 approve 本合約地址
    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        require(usdc.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        balances[msg.sender] += amount;
        totalDeposits += amount;

        emit Deposited(msg.sender, amount);
    }

    /// @notice 提取你存入的 USDC
    /// @param amount 提取金額
    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        totalDeposits -= amount;

        require(usdc.transfer(msg.sender, amount), "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    /// @notice 查詢使用者在金庫中的餘額
    /// @param user 使用者地址
    /// @return 餘額（6 decimals）
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}
