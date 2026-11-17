#!/usr/bin/env bash
# 辩论落盘完成后：收集变更、提交并推送到 origin（无变更则跳过）
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

TOPIC="${1:-${DEBATE_TOPIC:-}}"
if [[ -z "${TOPIC}" ]]; then
  TOPIC="$(python3 - <<'PY'
import re
from pathlib import Path
p = Path("debates/topics.md")
if not p.exists():
    print("truth-discovery: 辩论落盘")
    raise SystemExit(0)
last = "truth-discovery: 辩论落盘"
for line in p.read_text(encoding="utf-8").splitlines():
    if "✅" not in line or line.strip().startswith("#") or line.strip().startswith(">"):
        continue
    last = re.sub(r"\s*✅\s*$", "", line.strip())
print(last)
PY
)"
fi

if [[ -z "$(git status --porcelain)" ]]; then
  echo "debate-git-publish: no changes, skip"
  exit 0
fi

# 仅纳入本工程常见落盘路径；未跟踪的其它文件需人工处理
git add \
  AGENTS.md \
  .agents/agents/ \
  debates/ \
  docs/inquiry-log.md \
  .agents/skills/truth-discovery/ \
  findings/ 2>/dev/null || true

# 其余已跟踪文件的修改
git add -u

if [[ -z "$(git diff --cached --name-only)" ]]; then
  echo "debate-git-publish: no staged changes in known paths, skip (check untracked files)"
  exit 0
fi

MSG="debate: ${TOPIC}"

git commit -m "$(cat <<EOF
${MSG}

Automated publish after truth-discovery debate workflow (optimizer_finalize).
EOF
)"

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "debate-git-publish: committed $(git rev-parse --short HEAD) on ${BRANCH}"

if git remote get-url origin &>/dev/null; then
  git push origin "${BRANCH}"
  echo "debate-git-publish: pushed to origin/${BRANCH}"
else
  echo "debate-git-publish: no origin remote, commit only"
fi