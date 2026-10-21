#!/bin/bash

echo "=== DevContainer Post Create Setup ==="

mkdir -p /workspaces/.local/bin

# 安装 mise
export MISE_INSTALL_PATH=/workspaces/.local/bin/mise
export MISE_DATA_DIR=/workspaces/.local/share/mise
if [ ! -f /workspaces/.local/bin/mise ]; then
  echo "Installing mise..."
  bash -c 'curl -fsSL https://mise.run | sh'
  cat >> ~/.bashrc <<'EOF'
export MISE_DATA_DIR=/workspaces/.local/share/mise
eval "$(/workspaces/.local/bin/mise activate bash)"
EOF
else
  echo "mise already installed, skipping"
fi

# 通过 mise 全局安装工具（每个工具一行便于增减/调整版本）
echo "Installing tools via mise..."
# Claude Code CLI
/workspaces/.local/bin/mise use -g claude@latest
cat >> ~/.bashrc << EOF
alias cc='command claude --dangerously-skip-permissions; printf "\033c"'
EOF

echo "=== Setup Complete ==="
