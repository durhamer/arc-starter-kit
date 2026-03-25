# 🏗️ Arc Starter Kit — Circle L1 Testnet

> 一個完整的 Circle Arc 公鏈入門開發專案，包含智能合約、USDC 支付、跨鏈轉帳範例與前端 DApp。

## 🌐 Arc Testnet 網路資訊

| 項目 | 值 |
|---|---|
| **Network** | Arc Testnet |
| **RPC** | `https://rpc.testnet.arc.network` |
| **Chain ID** | `5042002` |
| **原生 Gas Token** | USDC |
| **Explorer** | https://testnet.arcscan.app |
| **Faucet** | https://faucet.circle.com |
| **WebSocket** | `wss://rpc.testnet.arc.network` |

## 📁 專案結構

```
arc-starter-kit/
├── src/
│   ├── HelloArchitect.sol      # 入門合約 — 問候語儲存
│   ├── USDCVault.sol           # USDC 金庫合約 — 存提款範例
│   └── PaymentSplitter.sol     # 支付分帳合約 — 多人分潤
├── test/
│   ├── HelloArchitect.t.sol    # HelloArchitect 測試
│   ├── USDCVault.t.sol         # USDCVault 測試
│   └── PaymentSplitter.t.sol   # PaymentSplitter 測試
├── script/
│   └── Deploy.s.sol            # 一鍵部署腳本
├── frontend/
│   └── index.html              # 前端 DApp（ethers.js + MetaMask）
├── .env.example                # 環境變數範本
├── .gitignore
├── foundry.toml                # Foundry 設定
├── Makefile                    # 快捷指令
├── setup.sh                    # 一鍵環境安裝腳本
└── README.md
```

## 🚀 快速開始

### 前置需求

- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/) >= 16（前端用）
- MetaMask 已加入 Arc Testnet
- 已從 [faucet.circle.com](https://faucet.circle.com) 領取測試 USDC

### 1. Clone & 安裝

```bash
git clone https://github.com/<你的帳號>/arc-starter-kit.git
cd arc-starter-kit

# 一鍵安裝 Foundry + 設定環境
chmod +x setup.sh
./setup.sh
```

### 2. 設定環境變數

```bash
cp .env.example .env
```

編輯 `.env`，填入你的私鑰：

```
PRIVATE_KEY=0x你的私鑰...
```

> ⚠️ **永遠不要** 將含有真實私鑰的 `.env` 檔案 commit 到 Git。

### 3. 編譯 & 測試

```bash
# 編譯所有合約
make build

# 跑測試
make test

# 部署到 Arc Testnet
make deploy
```

### 4. 啟動前端

用瀏覽器直接打開 `frontend/index.html`，或啟動 live server：

```bash
# 如果有 VS Code Live Server 擴充
# 或用 Python
python3 -m http.server 8080 --directory frontend
```

## 📜 合約說明

### HelloArchitect.sol
最基礎的入門合約。儲存一段問候語，支援讀取與更新，每次更新都會觸發事件。

### USDCVault.sol
示範如何在 Arc 上與 USDC（原生 ERC-20 介面）互動：
- `deposit()` — 存入 USDC 到金庫
- `withdraw()` — 提取你存入的 USDC
- `getBalance()` — 查詢餘額

### PaymentSplitter.sol
多人分潤合約，適合團隊或合作場景：
- 建立時設定收款人與比例
- 任何人可發送 USDC 到合約
- 收款人可隨時 `release()` 領取屬於自己的份額

## 🔧 Makefile 指令

| 指令 | 說明 |
|---|---|
| `make build` | 編譯合約 |
| `make test` | 執行測試 |
| `make deploy` | 部署到 Arc Testnet |
| `make verify` | 在 explorer 驗證合約 |
| `make fmt` | 格式化 Solidity 程式碼 |
| `make clean` | 清除編譯產物 |

## 🔗 重要合約地址（Arc Testnet）

| 合約 | 地址 |
|---|---|
| **USDC** | `0x3600000000000000000000000000000000000000` |
| **EURC** | `0x89B50855Aa3bE2F677cD6303Cec089B5F319D72a` |
| **CCTP TokenMessengerV2** | `0x8FE6B999Dc680CcFDD5Bf7EB0974218be2542DAA` |
| **Multicall3** | `0xcA11bde05977b3631167028862bE2a173976CA11` |
| **Permit2** | `0x000000000022D473030F116dDEE9F6B43aC78BA3` |

## 📚 學習資源

- [Arc 官方文件](https://docs.arc.network)
- [Circle 開發者文件](https://developers.circle.com)
- [Arc Discord](https://discord.com/invite/buildonarc)
- [Foundry Book](https://book.getfoundry.sh)
- [Arc Blog](https://arc.network/blog)
- [Circle 開發者補助](https://www.circle.com/developer-grants)

## 📄 License

MIT
