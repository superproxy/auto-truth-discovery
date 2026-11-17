#!/usr/bin/env sh
# Cursor 专用本地 loop（monitored shell）
# 对齐 Cursor loop skill：定时向 stdout 发出 AGENT_LOOP_TICK_*，由 Cursor Agent
# notify_on_output 唤醒后执行 .agents/automations.yaml 的 execution_prompt。
#
# 仅用于 Cursor IDE/CLI 会话。不是 WorkBuddy 入口。
# 互斥：勿与 WorkBuddy recurring、Cursor 斜杠 /loop、或本脚本第二实例同时开。
#
# 用法（仓库根，由 Agent 后台启动并监控 ^AGENT_LOOP_TICK_truth-discovery-debate）：
#   .agents/cursor-loop.sh                 # 默认 3600s（对齐 yaml 每小时）
#   LOOP_INTERVAL=1800 .agents/cursor-loop.sh
#   .agents/cursor-loop.sh 7200
#
# 停止：kill <启动时打印的 pid>

set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

INTERVAL="${1:-${LOOP_INTERVAL:-${LOOP_DEBATE_INTERVAL:-3600}}}"
case "$INTERVAL" in
  *[!0-9]*|"") echo "cursor-loop: INTERVAL 须为正整数秒" >&2; exit 1 ;;
esac
if [ "$INTERVAL" -lt 1 ]; then
  echo "cursor-loop: INTERVAL 须 >= 1" >&2
  exit 1
fi

PURPOSE="truth-discovery-debate"
YAML=".agents/automations.yaml"
PIDFILE="${CURSOR_LOOP_PIDFILE:-$ROOT/.agents/.cursor-loop.pid}"

PROMPT="$(awk '
  /^[[:space:]]*bootstrap_prompt:[[:space:]]*\|/ { grab=1; next }
  grab && /^[[:space:]]{6}[^[:space:]]/ {
    line=$0
    sub(/^[[:space:]]+/, "", line)
    if (line ~ /^[a-z_]+:/) exit
    if (buf != "") buf=buf " "
    buf=buf line
    next
  }
  grab && /^[[:space:]]{0,5}[^[:space:]]/ { exit }
  END { print buf }
' "$YAML")"

if [ -z "$PROMPT" ]; then
  PROMPT="自动化执行"
fi

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

PROMPT_JSON="$(json_escape "$PROMPT")"

if [ -f "$PIDFILE" ]; then
  old="$(cat "$PIDFILE" 2>/dev/null || true)"
  if [ -n "${old:-}" ] && kill -0 "$old" 2>/dev/null; then
    echo "cursor-loop: 已有实例 pid=$old（$PIDFILE），拒绝双开" >&2
    exit 1
  fi
  rm -f "$PIDFILE"
fi
printf '%s\n' "$$" > "$PIDFILE"
trap 'rm -f "$PIDFILE"' EXIT INT TERM

echo "cursor-loop: platform=cursor purpose=${PURPOSE} interval=${INTERVAL}s root=${ROOT} pid=$$"
echo "cursor-loop: sentinel=AGENT_LOOP_TICK_${PURPOSE}"
echo "cursor-loop: mutex — Cursor 专用；勿与 WorkBuddy / 斜杠 /loop / 第二实例同时开"
echo "cursor-loop: 首 tick 在 ${INTERVAL}s 后（启动不双跑；要立刻跑请先说「自动化执行」）"

while true; do
  sleep "$INTERVAL"
  printf 'AGENT_LOOP_TICK_%s {"prompt":"%s"}\n' "$PURPOSE" "$PROMPT_JSON"
done
