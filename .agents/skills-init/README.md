# 初始化 Skill 引用与副本

> 本工程由上游 skill 仓库初始化。本目录保留**来源引用**与**本地副本**，
> 确保「谁初始化了这个项目、用的是哪个 skill」可追溯，且 agent 离线也能读取执行引擎定义。

## 来源

| 项 | 值 |
|---|---|
| 上游仓库 | https://github.com/superproxy/skills |
| 本项目采用的初始化 skill | `init-loop-agents`（多角色工作流执行引擎 / Loop Engineering） |
| 上游路径 | `init-loop-agents/SKILL.md` |
| 参考范例 | `patterns/loop-enginerring/`（求真辨伪辩论工作流，即本工程原型） |
| 本地副本 | `.agents/skills-init/init-loop-agents/SKILL.md` |
| 拉取日期 | 2026-11-17 |

## 为什么这里有副本

上游 `init-loop-agents` 的约定是「引擎只负责解析、调度、执行、保存；角色人格来自项目自己的
`agents/roles/*.md`，工作流结构来自 `agents/debate-workflow.yaml`」。本项目遵循该约定：

- **引擎定义**（上游）：`.agents/skills-init/init-loop-agents/SKILL.md` — 通用工作流执行协议
- **工作流实例**（本项目）：`.agents/debate-workflow.yaml` — 求真辨伪 14 步
- **角色人格**（本项目）：`.agents/roles/*.md` — collector/challenger/reasoner/judge/optimizer
- **方法论 skill**（本项目）：`.agents/skills/truth-discovery/SKILL.md`

> 注：副本中的路径按上游原文保留（相对根目录的 `agents/...`）。本项目落地布局已将 agents 下沉到
> `.agents/`，实际执行以 `.agents/AUTOMATION.md` 与根目录 `AGENTS.md` 为准。

## 上游其他 skill（未采用，仅登记）

`superproxy/skills` 还包含以下 skill，本项目**未使用**，列出以备后续扩展：

- `init-dev-agents` / `init-dev-harness-agents` / `init-harness-agents` — 开发/协作框架初始化
- `mastergo-magic-skill` — 设计稿转代码
- `task-plan-skill` — PRD 拆解排期
- `role-skills` — 技能发现与推荐

## 引用规则

1. 修改辩论执行协议前，先读本地副本，判断是否应回指上游仓库。
2. 上游 skill 更新时，核对本地副本；仅同步协议层改动，不改本项目角色/工作流实例。
3. 新会话的 agent 若不知如何执行工作流，读 `.agents/AUTOMATION.md`（定时触发与执行说明）。
