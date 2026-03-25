// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/HelloArchitect.sol";
import "../src/USDCVault.sol";
import "../src/PaymentSplitter.sol";

contract DeployAll is Script {
    // Arc Testnet USDC ERC-20 介面地址
    address constant ARC_USDC = 0x3600000000000000000000000000000000000000;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("=================================");
        console.log("  Arc Starter Kit - Deploy All");
        console.log("=================================");
        console.log("Deployer:", deployer);
        console.log("");

        vm.startBroadcast(deployerPrivateKey);

        // 1. 部署 HelloArchitect
        HelloArchitect hello = new HelloArchitect();
        console.log("[1/3] HelloArchitect:", address(hello));

        // 2. 部署 USDCVault
        USDCVault vault = new USDCVault(ARC_USDC);
        console.log("[2/3] USDCVault:     ", address(vault));

        // 3. 部署 PaymentSplitter（範例：deployer 獨得 100%）
        address[] memory payees = new address[](1);
        payees[0] = deployer;
        uint256[] memory shares = new uint256[](1);
        shares[0] = 100;

        PaymentSplitter splitter = new PaymentSplitter(ARC_USDC, payees, shares);
        console.log("[3/3] PaymentSplitter:", address(splitter));

        vm.stopBroadcast();

        console.log("");
        console.log("All contracts deployed!");
        console.log("Update your .env with the addresses above.");
    }
}
