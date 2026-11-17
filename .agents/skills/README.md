# Skills

- **自有（git）**：仅 `truth-discovery/`（方法论、cases、references）。
- **项目初始化 / 自动化放哪**：根目录 [`AGENTS.md`](../../AGENTS.md)（「项目初始化」「自动化与 Loop」）。
- **自动化定义**：不在此目录 → [`.agents/automations.yaml`](../automations.yaml)。
- **外部 Read 路径**：[`paths.yaml`](paths.yaml)（init-role-agents、init-loop-agents、Cursor loop）。

本仓库**不包含** loop 运行时；配置 `/loop` 时 Read 上游 **init-loop-agents** 与（若有）**Cursor loop skill**，再读 `automations.yaml`。