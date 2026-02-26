#!/bin/bash
set -e

echo "=== OpenClaw Setup Started ==="

# 1️⃣ 基础依赖
apt-get update
apt-get install -y curl git

# 2️⃣ Node LTS（稳定）
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# 3️⃣ 安装 OpenClaw CLI
npm install -g @openclaw/cli

# 4️⃣ 创建配置目录
mkdir -p ~/.openclaw

# 5️⃣ 配置 Qwen
echo "=== 配置 Qwen ==="

if [ -n "$QWEN_API_KEY" ]; then
cat > ~/.openclaw/config.json <<EOF
{
  "llm": {
    "provider": "openai",
    "baseURL": "https://dashscope.aliyuncs.com/compatible-mode/v1",
    "apiKey": "$QWEN_API_KEY",
    "model": "qwen-turbo"
  }
}
EOF
echo "✅ Qwen 已配置"
else
echo "⚠ 未检测到 QWEN_API_KEY"
fi

# 6️⃣ 配置飞书
echo "=== 配置飞书 ==="

if [ -n "$FEISHU_APP_ID" ] && [ -n "$FEISHU_APP_SECRET" ]; then
  openclaw channels add feishu \
    --appId "$FEISHU_APP_ID" \
    --appSecret "$FEISHU_APP_SECRET" || true
  echo "✅ 飞书已配置"
else
  echo "⚠ 未检测到飞书 Secrets"
fi

# 7️⃣ 启动 Gateway
echo "=== 启动 Gateway ==="
nohup openclaw gateway run --host 0.0.0.0 --port 18789 > gateway.log 2>&1 &

echo "✅ Gateway 已启动 (18789)"
echo "=== Setup Completed ==="
