# skills 仓库

本仓库为 OpenCode skill `init-dev-agents` 的维护源。

## 工程结构

- `skills/init-dev-agents/SKILL.md` — skill 主文件，frontmatter 决定触发
- `skills/init-dev-agents/cases/` — 真实输入→产出案例
- `skills/init-dev-agents/tools/sync.sh` — 同步到 `~/.config/opencode/skills/`
- `docs/requirements.md` — 当前需求
- `docs/references.md` — 参考资料
- `tests/scenarios/` — 触发场景测试用例
- `.trae/skills/truth-discovery/` — 历史素材，**不要**改这里

## 关键命令

| 任务 | 命令 |
|---|---|
| 同步到全局 OpenCode | `bash skills/init-dev-agents/tools/sync.sh` |
| 校验全局已生效 | `cat ~/.config/opencode/skills/init-dev-agents/SKILL.md \| head -5` |

> **没有构建/测试运行器**。skill 工程靠 prompt 触发验证，测试场景见 `tests/scenarios/`，由人工或 agent 跑通。

## 约定与陷阱

- **双份维护**：本仓库 = source of truth；`~/.config/opencode/skills/` = OpenCode 加载点。改本地后必须跑 sync。
- **frontmatter 是触发关键**：`description` 字段直接影响 OpenCode 何时加载本 skill，改动需配合 `tests/scenarios/` 验证
- **SKILL.md 体积控制**：保持 < 250 行。超长内容拆到 `cases/` 或 `tools/`
- **不要 import**：skill 是纯文本文件，没有运行时

## 需求 / 参考 / 测试 分流

- 当前需求 → `docs/requirements.md`
- 参考资料 → `docs/references.md`
- 触发与产出场景 → `tests/scenarios/`

## 当前优先级

1. 跑通"输入散乱笔记 → 工程骨架"主链路（见 `tests/scenarios/scaffold-from-notes.md`）
2. 补一个真实案例到 `cases/`（候选：本仓库自身的 bootstrap 过程）

## 指令源优先级

- 本文件 = 仓库结构与命令的唯一权威
- `skills/init-dev-agents/SKILL.md` = skill 行为的唯一权威
- 与全局 `~/.config/opencode/skills/init-dev-agents/SKILL.md` 不一致时，**信本仓库**，跑 sync 修复
