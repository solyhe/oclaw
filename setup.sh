#!/bin/bash
set -e

echo "=== OpenClaw Setup Started ==="

apt-get update && apt-get install -y curl git

# Node LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# 安装 CLI
npm install -g @openclaw/cli

# 权限
[ -d ~/.openclaw ] && chmod -R go-w ~/.openclaw

# 清理插件
rm -rf ~/.openclaw/extensions/feishu || true

# 飞书
if [ -n "$FEISHU_APP_ID" ] && [ -n "$FEISHU_APP_SECRET" ]; then
  openclaw channels add feishu --appId "$FEISHU_APP_ID" --appSecret "$FEISHU_APP_SECRET" || true
fi

# 启动
nohup openclaw gateway run --host 0.0.0.0 --port 18789 > gateway.log 2>&1 &

echo "=== OpenClaw Setup Completed ==="
