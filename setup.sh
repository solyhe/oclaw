#!/bin/bash
set -e

echo "=== OpenClaw Setup Started (Official CLI Portal Mode) ==="

# 1️⃣ 基础依赖
apt-get update
apt-get install -y curl git

# 2️⃣ 安装 Node.js LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# 3️⃣ 安装 OpenClaw CLI 官方版本
npm install -g @openclaw/cli

# 4️⃣ 创建配置目录
mkdir -p ~/.openclaw

# 5️⃣ 配置飞书 channel（如果环境变量存在）
echo "=== 配置飞书 ==="
if [ -n "$FEISHU_APP_ID" ] && [ -n "$FEISHU_APP_SECRET" ]; then
  openclaw channels add feishu \
    --appId "$FEISHU_APP_ID" \
    --appSecret "$FEISHU_APP_SECRET" || true
  echo "✅ 飞书已配置"
else
  echo "⚠ 未检测到飞书 Secrets，跳过飞书配置"
fi

# 6️⃣ 启动 OpenClaw Gateway
echo "=== 启动 OpenClaw Gateway ==="
# Gateway 默认会尝试官方 portal 认证，如果首次启动会弹出浏览器
nohup openclaw gateway run --host 0.0.0.0 --port 18789 > gateway.log 2>&1 &

echo "✅ Gateway 已启动，日志输出到 gateway.log"
echo "=== Setup Completed ==="
echo "⚠ 首次启动可能需要打开浏览器完成官方 portal 认证"
