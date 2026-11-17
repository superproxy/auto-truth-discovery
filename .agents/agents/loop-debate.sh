#!/usr/bin/env bash
# 定时唤醒求真辨伪辩论迭代（本地 IDE：配合 Shell notify_on_output + ^AGENT_LOOP_TICK_）
set -euo pipefail

PURPOSE="${LOOP_DEBATE_PURPOSE:-truth-discovery-debate}"
INTERVAL="${LOOP_DEBATE_INTERVAL:-3600}"

read -r -d '' PROMPT <<'EOF' || true
按 .agents/agents/RULES.md 执行 .agents/agents/debate-workflow.yaml 全流程一次：
1. 从 debates/topics.md 选取首个未标 ✅ 的辩题作为 topic（若无则输出「辩题库已耗尽」并结束）
2. 有依赖的步骤串行；同一拓扑层（含 parallel_group）用子智能体 Task 并行派发，遵守 concurrency
3. 裁判后优化者 6 路并行（optimizer_skill_review + 五个角色同步 + optimizer_finalize 汇总落盘）
4. 过程写入 debates/process/<workflow>-<date>/；结论写入 debates/conclusions/
5. 勿跳过步骤；循环辩论至质疑者「无新问题」
6. optimizer_finalize 完成后在仓库根目录执行：`bash .agents/agents/debate-git-publish.sh "<本轮 topic>"`（无变更则跳过；有变更则 commit 并 push origin）
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