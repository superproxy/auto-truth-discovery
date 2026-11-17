# `.agents/` — agent 工程配置

| 类型 | 路径 |
|---|---|
| **自动化（本仓库）** | `automations.yaml`、`AUTOMATION.md`、`run-debate.sh`、`loop-debate.sh` |
| **工作流实例** | `debate-workflow.yaml`、`roles/`、`RULES.md` |
| **方法论 skill** | `skills/truth-discovery/` |
| **Loop 能力** | 不内置；引用见 `skills/paths.yaml` + 根目录 `AGENTS.md`「自动化与 Loop」 |

自动化调用：先读 `automations.yaml` 的 `execution_prompt`；配 `/loop` 时再 Read 外部 loop skill。