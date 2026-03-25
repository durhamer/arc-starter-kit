-include .env

.PHONY: build test deploy clean fmt snapshot

# === 基本指令 ===

build:
	forge build

test:
	forge test -vvv

test-gas:
	forge test -vvv --gas-report

fmt:
	forge fmt

clean:
	forge clean

snapshot:
	forge snapshot

# === 部署 ===

deploy:
	@echo "🚀 Deploying to Arc Testnet..."
	forge script script/Deploy.s.sol:DeployAll \
		--rpc-url $(ARC_TESTNET_RPC_URL) \
		--private-key $(PRIVATE_KEY) \
		--broadcast \
		-vvv

# === 個別部署 ===

deploy-hello:
	forge create src/HelloArchitect.sol:HelloArchitect \
		--rpc-url $(ARC_TESTNET_RPC_URL) \
		--private-key $(PRIVATE_KEY) \
		--broadcast

deploy-vault:
	forge create src/USDCVault.sol:USDCVault \
		--rpc-url $(ARC_TESTNET_RPC_URL) \
		--private-key $(PRIVATE_KEY) \
		--broadcast \
		--constructor-args 0x3600000000000000000000000000000000000000

# === 互動指令 ===

read-greeting:
	@cast call $(HELLO_ARCHITECT_ADDRESS) "getGreeting()(string)" \
		--rpc-url $(ARC_TESTNET_RPC_URL)

set-greeting:
	@cast send $(HELLO_ARCHITECT_ADDRESS) "setGreeting(string)" "$(MSG)" \
		--rpc-url $(ARC_TESTNET_RPC_URL) \
		--private-key $(PRIVATE_KEY)

check-balance:
	@cast balance $(WALLET) --rpc-url $(ARC_TESTNET_RPC_URL)

# === 工具 ===

wallet-new:
	cast wallet new

chain-id:
	@cast chain-id --rpc-url $(ARC_TESTNET_RPC_URL)

block:
	@cast block-number --rpc-url $(ARC_TESTNET_RPC_URL)

help:
	@echo ""
	@echo "Arc Starter Kit - 可用指令"
	@echo "=========================="
	@echo "  make build         編譯合約"
	@echo "  make test          執行測試"
	@echo "  make test-gas      執行測試 + gas 報告"
	@echo "  make deploy        部署所有合約到 Arc Testnet"
	@echo "  make deploy-hello  只部署 HelloArchitect"
	@echo "  make deploy-vault  只部署 USDCVault"
	@echo "  make read-greeting 讀取問候語"
	@echo "  make set-greeting MSG='你好' 設定問候語"
	@echo "  make wallet-new    產生新錢包"
	@echo "  make chain-id      查詢 Chain ID"
	@echo "  make block         查詢最新區塊號"
	@echo "  make fmt           格式化程式碼"
	@echo "  make clean         清除編譯產物"
	@echo ""
