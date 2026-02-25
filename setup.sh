#!/bin/bash
set -e

echo "=== OpenClaw Setup Started ==="

# 1️⃣ 更新系统依赖
sudo apt-get update && sudo apt-get install -y curl git

# 2️⃣ 安装 Node.js 24.x
curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
sudo apt-get install -y nodejs

# 3️⃣ 安装 OpenClaw CLI
npm install -g openclaw

# 4️⃣ 设置安全权限，防止插件阻塞
chmod -R go-w ~/.openclaw || true

# 5️⃣ 清理重复插件
rm -rf ~/.openclaw/extensions/feishu || true

# 6️⃣ 配置飞书插件（使用 Codespaces Secrets 或默认环境变量）
FEISHU_APP_ID="${FEISHU_APP_ID:-your_app_id}"
FEISHU_APP_SECRET="${FEISHU_APP_SECRET:-your_app_secret}"

if [ "$FEISHU_APP_ID" = "your_app_id" ] || [ "$FEISHU_APP_SECRET" = "your_app_secret" ]; then
  echo "⚠ 请在 Codespaces Secrets 中设置 FEISHU_APP_ID 和 FEISHU_APP_SECRET"
else
  echo "✅ 配置飞书插件"
  openclaw channels add feishu --appId "$FEISHU_APP_ID" --appSecret "$FEISHU_APP_SECRET" || true
fi

# 7️⃣ 启动 Gateway 后台运行
nohup openclaw gateway run > gateway.log 2>&1 &
echo "✅ OpenClaw Gateway started in background, logs: gateway.log"
echo "Listening on 127.0.0.1:18789"

echo "=== OpenClaw Setup Completed ==="
