# `.agents/` — agent 工程配置

本目录存放「agent 如何思考与执行」；辩论产出留在仓库根目录（`debates/`、`findings/` 等）。

**结构与权威说明**：见根目录 [`AGENTS.md`](../AGENTS.md)（本仓库结构唯一权威）。

| 路径 | 职责 |
|---|---|
| `skills/truth-discovery/` | 辩证法 skill：主干、案例、参考、清单 |
| `skills-init/` | 上游 `init-loop-agents` 引用与引擎副本 |
| `roles/` | 五角色人格（collector / challenger / reasoner / judge / optimizer） |
| `debate-workflow.yaml` | 14 步辩论工作流 |
| `automations.yaml` | 定时任务唯一真相源 |
| `AUTOMATION.md` | 执行手册与统一规范 |
| `RULES.md` | 多角色辩论执行规则 |
| `run-debate.sh` / `loop-debate.sh` / `debate-git-publish.sh` | CLI 兜底、IDE 定时、落盘发布 |

指令源优先级（节选）：`AGENTS.md` → `skills/.../SKILL.md` → `RULES.md` → `automations.yaml` → `AUTOMATION.md`。