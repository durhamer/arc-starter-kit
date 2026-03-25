#!/bin/bash
set -e

echo ""
echo "🏗️  Arc Starter Kit — 環境安裝腳本"
echo "===================================="
echo ""

# --- 1. 檢查 Git ---
if ! command -v git &> /dev/null; then
    echo "❌ 找不到 Git。請先安裝: https://git-scm.com/"
    exit 1
fi
echo "✅ Git $(git --version | awk '{print $3}')"

# --- 2. 安裝 Foundry ---
if command -v forge &> /dev/null; then
    echo "✅ Foundry 已安裝 ($(forge --version | head -1))"
else
    echo "📦 安裝 Foundry..."
    curl -L https://foundry.paradigm.xyz | bash
    
    # 載入 foundryup 到目前的 shell
    export PATH="$HOME/.foundry/bin:$PATH"
    
    echo "📦 安裝 forge, cast, anvil..."
    foundryup
    echo "✅ Foundry 安裝完成"
fi

# --- 3. 安裝 Solidity 依賴 ---
echo ""
echo "📦 安裝 forge-std..."
if [ ! -d "lib/forge-std" ]; then
    forge install foundry-rs/forge-std --no-commit
    echo "✅ forge-std 安裝完成"
else
    echo "✅ forge-std 已存在"
fi

# --- 4. 設定 .env ---
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo ""
    echo "📝 已建立 .env 檔案（從 .env.example）"
    echo "   請編輯 .env 填入你的 PRIVATE_KEY"
else
    echo "✅ .env 已存在"
fi

# --- 5. 編譯測試 ---
echo ""
echo "🔨 編譯合約..."
forge build

echo ""
echo "🧪 執行測試..."
forge test

echo ""
echo "===================================="
echo "🎉 環境設定完成！"
echo ""
echo "下一步:"
echo "  1. 編輯 .env，填入你的 PRIVATE_KEY"
echo "  2. 到 https://faucet.circle.com 領取測試 USDC"
echo "  3. make deploy  部署合約到 Arc Testnet"
echo ""
echo "常用指令:"
echo "  make help    查看所有可用指令"
echo "  make test    執行測試"
echo "  make build   編譯合約"
echo "===================================="
