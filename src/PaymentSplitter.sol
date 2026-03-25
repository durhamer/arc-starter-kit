// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title IERC20
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

/// @title PaymentSplitter
/// @notice 多人分潤合約 — 按比例分配收到的 USDC
/// @dev 適用於團隊合作、收入分潤等場景
contract PaymentSplitter {
    IERC20 public immutable usdc;

    address[] public payees;
    mapping(address => uint256) public shares;
    mapping(address => uint256) public released;
    uint256 public totalShares;
    uint256 public totalReleased;

    event PaymentReceived(address indexed from, uint256 amount);
    event PaymentReleased(address indexed to, uint256 amount);

    /// @notice 建立分潤合約
    /// @param _usdcAddress USDC ERC-20 合約地址
    /// @param _payees 收款人地址陣列
    /// @param _shares 各收款人的份額（比例）
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

    /// @notice 發送 USDC 到本合約（需先 approve）
    /// @param amount 發送金額
    function pay(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        require(usdc.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        emit PaymentReceived(msg.sender, amount);
    }

    /// @notice 領取屬於你的分潤
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

    /// @notice 查詢某收款人可領取的金額
    /// @param account 收款人地址
    /// @return 可領取金額
    function pending(address account) external view returns (uint256) {
        if (shares[account] == 0) return 0;

        uint256 totalReceived = usdc.balanceOf(address(this)) + totalReleased;
        uint256 payment = (totalReceived * shares[account]) / totalShares - released[account];
        return payment;
    }

    /// @notice 取得所有收款人數量
    function payeeCount() external view returns (uint256) {
        return payees.length;
    }
}
