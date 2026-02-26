#!/bin/bash
set -e

echo "=== OpenClaw Setup Started ==="

# 1️⃣ 安装基础依赖
apt-get update
apt-get install -y curl git

# 2️⃣ 安装 Node.js LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# 3️⃣ 安装 OpenClaw CLI 官方版本
npm install -g @openclaw/cli

# 4️⃣ 创建配置目录
mkdir -p ~/.openclaw

# 5️⃣ 配置飞书 channel（如果 Secrets 存在）
echo "=== 配置飞书 ==="
if [ -n "$FEISHU_APP_ID" ] && [ -n "$FEISHU_APP_SECRET" ]; then
  openclaw channels add feishu \
    --appId "$FEISHU_APP_ID" \
    --appSecret "$FEISHU_APP_SECRET" || true
  echo "✅ 飞书已配置"
else
  echo "⚠ 未检测到飞书 Secrets，跳过飞书配置"
fi

# 6️⃣ 启动 OpenClaw Gateway（后台运行）
echo "=== 启动 OpenClaw Gateway ==="
nohup openclaw gateway run --host 0.0.0.0 --port 18789 > gateway.log 2>&1 &

echo "✅ Gateway 已启动，日志输出到 gateway.log"

# 7️⃣ 提示使用交互式 config 设置 API
echo ""
echo "=== 提示：配置 LLM API ==="
echo "现在你可以通过交互式命令设置 Qwen 或其他 LLM API："
echo ""
echo "  openclaw config"
echo ""
echo "执行后，OpenClaw 会一步步提示你："
echo "  - 选择 llm.provider"
echo "  - 输入 API 网关 URL"
echo "  - 输入 API Key"
echo "  - 选择模型（例如 qwen-turbo）"
echo ""
echo "完成后可重启 Gateway 生效："
echo "  openclaw gateway restart"
echo ""
echo "=== Setup Completed ==="
