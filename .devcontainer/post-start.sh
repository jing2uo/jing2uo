#!/bin/bash

# 后台运行 magpie web：gateway 在 127.0.0.1:3425，页面在 127.0.0.1:3430
LOG=/workspaces/.local/state/magpie-web.log
mkdir -p "$(dirname "$LOG")"

if pgrep -f 'magpie web' >/dev/null; then
  echo "magpie web already running"
  exit 0
fi

# 通过 mise exec 运行，PATH 里才有 mise 装的 claude，magpie 的 Claude 订阅要用它
nohup setsid /workspaces/.local/bin/mise exec -- magpie web --no-open >>"$LOG" 2>&1 </dev/null &
echo "magpie web started, log: $LOG"
