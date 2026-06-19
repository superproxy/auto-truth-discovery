# skills

OpenCode skill 工作区。本仓库为单 skill 维护源：`init-dev-agents`。

## 结构

- `skills/init-dev-agents/` — skill 源文件（SKILL.md + cases + tools）
- `docs/` — 需求 / 参考 / 变更记录
- `tests/scenarios/` — skill 触发与产出的验收场景
- `.trae/skills/truth-discovery/` — 历史素材，**不在**本 skill 维护范围

## 与全局 skill 的关系

`~/.config/opencode/skills/init-dev-agents/SKILL.md` 是 OpenCode 实际加载的位置。
本仓库为 source of truth，**手动同步**（见 `tools/sync.sh`）。

## 快速开始

参见 `AGENTS.md`。
