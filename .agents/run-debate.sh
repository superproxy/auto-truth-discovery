#!/usr/bin/env bash
# 命令行兜底驱动（平台 automation 不可用时使用）
# 从唯一真相源 automations.yaml 提取 execution_prompt，用 codebuddy -p 无头跑一轮辩论。
# 平台与脚本同读一份定义，不产生新副本。
#
#   跑一轮：  bash .agents/run-debate.sh
#   定时循环：LOOP_DEBATE_INTERVAL=3600 bash .agents/run-debate.sh --loop
#   权限模式覆盖：DEBATE_AGENT_PERM_MODE=acceptEdits bash .agents/run-debate.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
YAML=".agents/automations.yaml"
LOG="${DEBATE_CLI_LOG:-/tmp/auto-truth-discovery-debate-cli.log}"
PERM_MODE="${DEBATE_AGENT_PERM_MODE:-bypassPermissions}"

[ -f "$YAML" ] || { echo "缺少 $YAML" >&2; exit 1; }
command -v codebuddy >/dev/null || { echo "未找到 codebuddy CLI，命令行兜底不可用" >&2; exit 1; }

# 提取 execution_prompt 块标量（去 6 空格缩进）；不依赖 PyYAML
extract_prompt() {
  awk '
    /^    execution_prompt: \|/ { inside=1; next }
    inside && /^      /         { sub(/^      /, ""); print; next }
    inside && /^[[:space:]]*$/  { print ""; next }
    inside                      { exit }
  ' "$YAML"
}

PROMPT="$(extract_prompt)"
if [ -z "$PROMPT" ]; then
  echo "无法从 $YAML 提取 execution_prompt（检查缩进或字段名）" >&2
  exit 1
fi

run_once() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 启动一轮辩论（perm=$PERM_MODE）" | tee -a "$LOG"
  if codebuddy -p --permission-mode "$PERM_MODE" "$PROMPT" 2>&1 | tee -a "$LOG"; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 一轮结束" | tee -a "$LOG"
  else
    local rc=$?
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 一轮失败 rc=$rc" | tee -a "$LOG"
    return "$rc"
  fi
}

if [ "${1:-}" = "--loop" ]; then
  INTERVAL="${LOOP_DEBATE_INTERVAL:-3600}"
  echo "循环模式：每 ${INTERVAL}s 一轮；Ctrl-C 停止；日志 $LOG" | tee -a "$LOG"
  while true; do
    run_once || true
    sleep "$INTERVAL"
  done
else
  run_once
fi
