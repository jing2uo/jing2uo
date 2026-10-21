#!/bin/bash

echo "=== DevContainer Post Create Setup ==="

mkdir -p /workspaces/.local/bin

# 安装 mise
export MISE_INSTALL_PATH=/workspaces/.local/bin/mise
export MISE_DATA_DIR=/workspaces/.local/share/mise
if [ ! -f /workspaces/.local/bin/mise ]; then
  echo "Installing mise..."
  bash -c 'curl -fsSL https://mise.run | sh'
else
  echo "mise already installed, skipping"
fi

# 容器重建后 ~/.bashrc 是新的，每次都要检查
if ! grep -q 'mise activate bash' ~/.bashrc; then
  cat >> ~/.bashrc <<'EOF'
export MISE_DATA_DIR=/workspaces/.local/share/mise
eval "$(/workspaces/.local/bin/mise activate bash)"
EOF
fi

# 通过 mise 全局安装工具（每个工具一行便于增减/调整版本）
echo "Installing tools via mise..."
# 不等发布冷却期，直接装最新版；upgrade 后立即清理旧版本
/workspaces/.local/bin/mise settings set minimum_release_age 0
/workspaces/.local/bin/mise settings set upgrade.prune_after 0s
# Claude Code CLI（magpie 的 Claude 订阅也用它）
/workspaces/.local/bin/mise use -g claude@latest
if ! grep -q "alias cc=" ~/.bashrc; then
  cat >> ~/.bashrc << EOF
alias cc='command claude --dangerously-skip-permissions; printf "\033c"'
EOF
fi
# magpie
/workspaces/.local/bin/mise use -g 'github:yetone/magpie[asset_pattern=magpie-cli-linux-amd64,bin=magpie]@latest'

echo "=== Setup Complete ==="
