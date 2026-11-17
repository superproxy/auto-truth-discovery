#!/usr/bin/env bash
# IDE 定时载体（链 C）；loop 语义见 AGENTS.md「自动化与 Loop」+ paths.yaml 外部 loop skill
# 本地 IDE：Monitored shell + notify_on_output + ^AGENT_LOOP_TICK_truth-discovery-debate
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PURPOSE="${LOOP_DEBATE_PURPOSE:-truth-discovery-debate}"
INTERVAL="${LOOP_DEBATE_INTERVAL:-3600}"

# 薄引导：与平台 automation 同源，完整指令在 automations.yaml（单一真相源）。
# 勿在此内嵌完整 prompt——否则又多一份会漂移的副本。
read -r -d '' PROMPT <<EOF || true
执行 auto-truth-discovery 项目的一轮「求真辨伪」辩论工作流。
工作目录：${ROOT}（若工具不继承工作目录，先切换到该目录）。
本任务为薄引导：完整执行指令在 .agents/automations.yaml 中 id=truth-discovery-debate-loop 的 execution_prompt 字段。
请先用 Read 读取该文件，取出 execution_prompt 全文并严格执行；不要自行简化或改写步骤。
EOF

emit() {
  python3 -c 'import json,sys; print("AGENT_LOOP_TICK_%s" % sys.argv[1], json.dumps({"prompt": sys.argv[2]}, ensure_ascii=False))' \
    "$PURPOSE" "$PROMPT"
}

echo "loop-debate: purpose=$PURPOSE interval=${INTERVAL}s (set LOOP_DEBATE_INTERVAL to override)"
while true; do
  sleep "$INTERVAL"
  emit
done