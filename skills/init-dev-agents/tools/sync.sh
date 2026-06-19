#!/usr/bin/env bash
# Sync local skill to global OpenCode skills directory.
# Source of truth: this repo. Target: ~/.config/opencode/skills/init-dev-agents/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="$HOME/.config/opencode/skills/init-dev-agents"

mkdir -p "$TARGET"

# Sync SKILL.md and any sibling assets (cases/, tools/) but exclude this script's parent re-copy.
rsync -av --delete \
  --exclude='tools/sync.sh' \
  "$SKILL_DIR/" "$TARGET/"

echo "✓ Synced $SKILL_DIR → $TARGET"
echo "  Verify: head -5 $TARGET/SKILL.md"
