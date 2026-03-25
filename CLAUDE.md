# Arc Starter Kit — 專案說明

## 概述
Circle Arc L1 Testnet 入門專案，包含三個 Solidity 合約 + 前端 DApp。

## 已部署合約（Arc Testnet, Chain ID: 5042002）
- HelloArchitect: 0x3f0b7e8fA36417Fa922ad1AE36e0b1D053D48af3
- USDCVault: 0x5995e87Ad6A6FBf59518aFd2d348b6d3B3DA7476
- PaymentSplitter: 0x85cB3fA3Ef109f88384C359C596cE575d69c7Ab4
- Deployer: 0xE958E0d6c915e2754D94F2bc0a7CE20607f3CCE9

## 技術棧
- Solidity 0.8.30 + Foundry (forge/cast)
- 前端: 純 HTML + ethers.js v6 + MetaMask
- USDC 是 Arc 的原生 gas token
- USDC ERC-20 地址: 0x3600000000000000000000000000000000000000

## 重要指令
- `make build` — 編譯
- `make test` — 測試
- `make deploy` — 部署到 Arc Testnet
- `python3 -m http.server 8080 --directory frontend` — 啟動前端

## 開發方向
- 想加入 CCTP 跨鏈轉帳功能
- 想加入 EURC 支援
- 想擴展前端 DApp 功能
