# skills 仓库

本仓库为 OpenCode 本地 skill `truth-discovery` 的维护源。

## 项目目标

通过方法论 + 大模型知识库 + 网络知识库 + 本地案例库，帮助 agent 对历史、文化、经典文本、人物品牌与公共叙事做求真判断。分析时要结合哲学追问、慧学式反省、证据链、知识谱系、动机链、作案链、利益归属与传播机制，输出分层结论而非真假二分。大模型知识库本身也可能受教材、百科、SEO、意识形态和权威叙事污染，因此 agent 必须用方法论反审自身知识，培养独立思考能力。

## 工程结构

```
skills/truth-discovery/           # skill：方法论 + 经典案例（被 agent 引用）
├── SKILL.md                      # 求真辨伪方法论主文件
├── cases/                        # 经典案例（从辩论中提炼，18个）
├── tools/
│   └── checklist.md              # 求真操作检查清单
└── references/
    └── legacy-framework.md       # 已迁移的历史完整框架

agents/                           # 智能体：角色定义 + 工作流
├── roles/
│   ├── collector.md              # 🔍 话题搜集者
│   ├── challenger.md             # 🔴 质疑者
│   ├── reasoner.md               # 🟢 推理者
│   ├── judge.md                  # ⚖️ 裁判者
│   └── optimizer.md              # 🛠️ Skill优化者
├── RULES.md                      # 多角色辩论执行规则（含角色能力同步规则）
└── debate-workflow.yaml          # 全流程辩论工作流

debates/                          # 辩论场地（与 agents 平行）
├── 事/                           # 辩题库 + 辩论记录
└── 结果/                         # 裁判结论与报告

docs/
├── inquiry-log.md                # 问询分类记录（提炼点/需求/参考资料）
└── session-log.md                # 用户会话记录（追踪skill进化轨迹）

tests/scenarios/                  # 触发场景测试用例
```

## 工作流全景

```
🔍 话题搜集者          搜索争议话题 → 审核打分 → 精炼表述
        │
        ▼
🔴 质疑者  ⇄  🟢 推理者   反复辩论（最多100轮，无新问题则结案）
        │
        ▼
⚖️ 裁判者              比较证据强度 → 分层结论 → 最终报告
        │
        ▼
🛠️ Skill优化者         审查辩论质量 → 判断是否沉淀 → 同步角色能力
        │
        ├── 方法论增量 → skills/truth-discovery/SKILL.md
        ├── 经典案例   → skills/truth-discovery/cases/
        └── 角色同步   → agents/roles/*.md
```

## 角色能力同步飞轮

```
辩论产生方法论增量
    │
    ▼
SKILL.md 沉淀新方法论
    │
    ▼
角色文件同步注入新方法论武器
    │
    ▼
下一场辩论能力更强 → 产生更深的方法论增量
```

> **核心规则**：每次 SKILL.md 更新后，相关角色必须在 24 小时内同步更新。Optimizer 在每场辩论结束后必须检查角色能力同步。

## 辩论场地二维结构

| 维度 | 目录 | 内容 |
|---|---|---|
| 事 | `debates/事/` | 600个辩题（18领域）、6场已完成辩论的完整记录 |
| 结果 | `debates/结果/` | 每场辩论的裁判结论摘要、重新审查报告 |

> **经验（方法论增量）沉淀到 `skills/truth-discovery/SKILL.md`**，不单独存于 debates/。

## 关键命令

| 任务 | 命令 |
|---|---|
| 查看 skill 入口 | `cat skills/truth-discovery/SKILL.md \| head -5` |
| 查看辩论场地 | `ls debates/人/ debates/事/ debates/结果/ debates/经验/` |
| 查看角色能力 | `ls agents/roles/` |
| 查看会话记录 | `cat docs/session-log.md` |

> **没有构建/测试运行器**。skill 工程靠 prompt 触发验证，测试场景见 `tests/scenarios/`，由人工或 agent 跑通。

## 约定与陷阱

- **单源维护**：本仓库 = source of truth。正式发布后由用户自行安装，本仓库不提供同步脚本。
- **OpenCode 加载是会话级快照**：`skill` 工具拿到的内容是**会话开始**那一刻的 SKILL.md 快照。修改源文件后，必须按发布/安装流程重新安装并新开会话，才能验证新版。
- **frontmatter 是触发关键**：`description` 字段直接影响 OpenCode 何时加载本 skill，改动需配合 `tests/scenarios/` 验证
- **SKILL.md 体积控制**：不要太大即可。超长内容拆到 `cases/` 或 `tools/`
- **不要 import**：skill 是纯文本文件，没有运行时
- **不依赖 `.trae`**：正式素材都应在 `skills/truth-discovery/` 下；`.trae` 只可作为临时迁移来源
- **问询分类记录**：用户每次对本工程的问询，都要记录到 `docs/inquiry-log.md`，标注为"提炼点 / 需求 / 参考资料"之一
- **会话记录**：每次用户与 agent 的交互，都要记录到 `docs/session-log.md`
- **角色能力同步**：每次 SKILL.md 更新后，检查并同步更新角色文件
- **中文优先写入**：后续新增或修改的说明、案例、记录和方法论原则上尽可能使用中文

## 当前优先级

1. 持续运行辩论，积累方法论增量和经典案例
2. 维护角色能力同步飞轮——每次辩论后检查角色是否需要更新
3. 持续维护 `docs/inquiry-log.md` 和 `docs/session-log.md`

## 指令源优先级

- 本文件 = 仓库结构与命令的唯一权威
- `skills/truth-discovery/SKILL.md` = skill 行为的唯一权威
- `agents/RULES.md` = 多角色辩论执行规则（含角色同步规则）
- 正式发布/安装流程不在本仓库内维护；本仓库只保证源文件内容正确
