---
name: init-dev-agents
description: Use when the user provides raw natural-language input (mixed requirements, references, test ideas) and asks to turn it into a real project skeleton, or wants to bootstrap/refresh AGENTS.md for a repo. Triggers on "提炼出一个工程", "做成工程", "整理工程结构", "init this repo", "/init", or when a fresh directory contains only loose notes.
---

# init-dev-agents — 从一段输入提炼出一个工程

## 核心契约

**输入**：用户的一段自然语言（需求 / 参考 / 测试想法 混在一起），可能伴随一个空目录或半成品仓库。

**最小产出**（缺一不可）：
1. `AGENTS.md` — 入口地图，每行通过 "agent 没有这条会踩坑吗" 测试
2. `docs/requirements.md` — 分流出的需求
3. `docs/references.md` — 分流出的参考
4. `tests/scenarios/` 目录（或 `docs/test-scenarios.md`） — 分流出的测试场景
5. 一个匹配工程类型的脚手架（软件 / 方法论 / 文档）

**红线**：需求、参考、测试场景**不准**糊进 AGENTS.md 正文。AGENTS.md 是地图，不是需求库。

## 触发判断

- 用户说"提炼成工程 / 做成工程 / 整理工程结构 / init / /init"
- 仓库只有零散笔记、`.trae/skills/` 这类素材，需要 bootstrap
- 已有 `AGENTS.md` 要按当前代码 reconcile

## 工作流（严格按序）

### Step 1: 探仓库现状（30 秒内）

跑一次 `ls -la` 和 `find . -maxdepth 3 -type f | head -50`，回答三个问题：

| 状态 | 标志 | 后续动作 |
|---|---|---|
| **空仓库** | 无 manifest、无源码 | 跳到 Step 2，按用户输入 bootstrap |
| **有素材无骨架** | 只有笔记/skill/文档碎片 | Step 2 + Step 3 调研已有素材 |
| **已有工程** | 有 manifest、有源码、有 `AGENTS.md` | 重点做 reconcile（Step 5），Phase 0 三分类只对**新增输入**做 |

### Step 2: 三分类用户输入（Phase 0，强制）

把用户那段话**逐句**切，每句归到一类（不重不漏）：

| 分类 | 识别信号 | 落点 |
|---|---|---|
| **需求 Requirements** | "需要 / 必须 / 想要 / 实现 / 支持 / 用户能…" / 用户故事 | `docs/requirements.md`（条目化 + 优先级 P0/P1/P2） |
| **参考 References** | URL、论文、书名、"参考 X / 类似 Y / 借鉴" | `docs/references.md`（仅列名 + 一句话用途，**不抄正文**） |
| **测试场景 Test Scenarios** | "当 X 时应 Y / 边界 / case / 验证 / 场景" / Given-When-Then | `tests/scenarios/{slug}.md`，每场景一文件 |

不确定归哪类的句子 → 用 `question` 工具批量问，**一次问完**，别多轮。

### Step 3: 推断工程类型

按输入主语决定脚手架：

| 主语 | 类型 | 脚手架 |
|---|---|---|
| 代码 / API / 服务 / 前端 / 库 | **软件工程** | `src/` + `tests/` + manifest |
| 方法论 / 框架 / 流程 / 提示词 / skill | **方法论工程** | `skills/{name}/SKILL.md` + `cases/` + `tools/` |
| 文档 / 报告 / 知识库 | **文档工程** | `docs/` + 索引 `README.md` |
| 模糊 | 用 `question` 问一句 | — |

### Step 4: 生成方案 → 用户确认 → 落盘

**先输出方案预览**（目录树 + 每个文件首行注释），让用户点头再写文件。不要直接 `write` 一堆文件。

骨架模板：

```
# 软件工程
{repo}/
├── AGENTS.md
├── README.md                ← 一句话定位 + quick start
├── src/
├── tests/scenarios/         ← Step 2 测试场景
├── docs/
│   ├── requirements.md      ← Step 2 需求
│   ├── references.md        ← Step 2 参考
│   └── architecture.md      ← 仅当有架构决策
├── .gitignore
└── {manifest}               ← package.json / pyproject.toml / …

# 方法论工程
{repo}/
├── AGENTS.md
├── README.md
├── skills/{slug}/
│   ├── SKILL.md             ← frontmatter: name + description
│   ├── cases/               ← 案例
│   └── tools/               ← checklist / 模板
├── docs/{requirements,references}.md
└── tests/scenarios/

# 文档工程
{repo}/
├── AGENTS.md
├── README.md                ← 索引
├── docs/{requirements,references}.md
└── content/                 ← 实际文档
```

### Step 5: 写 AGENTS.md（地图，不是文档）

#### 收什么

只收**读多个文件才能推出来**的事实：

- 精确命令（从 `Makefile` / manifest / CI **实际找到**，不猜）
- 跑单测 / 单包 / 聚焦验证
- 命令必要顺序（如 `codegen → lint → typecheck → test`）
- monorepo 边界、真正 entrypoint
- 框架怪癖：codegen、migration、生成产物、env 加载、dev server
- 跟语言/框架默认不同的约定
- 测试怪癖：fixture、必需服务、慢/flaky suite
- 多个指令源时（`CLAUDE.md` / `.cursor/rules/` / `opencode.json` instructions）该信哪个

一眼能看出来的 → **不写**。

#### 模板

```markdown
# {项目名}

{一句话：是什么 / 给谁用 / 当前阶段}

## 工程结构
- `src/foo/` — {真正 entrypoint}
- `skills/bar/` — {独立 skill}
- {只列 agent 可能找错地方的目录}

## 关键命令
| 任务 | 命令 |
|---|---|
| 安装 | `…` |
| 构建 | `…` |
| 跑全部测试 | `…` |
| 跑单个测试 | `…` |
| Lint / Typecheck | `…` |

> 命令顺序：{若有强制顺序写这；没有就删掉这行}

## 约定与陷阱
- {跟默认不同的代码风格}
- {生成产物路径，禁止手改}
- {env 加载顺序}
- {已知 flaky 测试如何跳过}

## 需求 / 参考 / 测试 分流
- 需求 → `docs/requirements.md`
- 参考 → `docs/references.md`
- 测试场景 → `tests/scenarios/`

## 当前优先级
- {本阶段在做的事；没有就删整段}

## 指令源优先级（仅当存在多份时写）
1. {权威来源，如 `.cursor/rules/foo.md`}
2. {次级}
```

> 任何段落如果填不出真实内容 → **整段删掉**，不要留 placeholder。

### Step 6: Reconcile（仅已有 AGENTS.md 时）

- 保留：可被当前代码验证的命令、约定、架构事实
- 删除：fluff、通用建议、过期声明、跟脚本对不上的描述
- 改写：跟现状不符但概念仍有效的段落
- **绝不**整文件覆盖；用 `edit` 工具逐段改

### Step 7: 完成前自检

- [ ] 用户输入是否完整三分类，无混塞进 AGENTS.md？
- [ ] 工程类型判断正确？
- [ ] AGENTS.md 每行通过 "agent 不知道会踩坑吗"？
- [ ] 命令都从配置文件**实际找到**？没有就标 TODO 或不写
- [ ] 已有 AGENTS.md → 是 reconcile 而非覆盖？
- [ ] 文件长度匹配仓库复杂度？小仓库 < 50 行就够
- [ ] 最小产出 5 项齐全？

## 黑名单（绝不写进 AGENTS.md）

- 通用软件建议（"写好测试"、"注意安全"）
- 长教程、详尽文件树
- 语言默认约定（"Python 4 空格"）
- 未验证的猜测
- 该放进 `opencode.json` `instructions` 引用文件的长内容
- 用户输入里的需求/参考/测试细节本身

## 与其他 skill 协作（写进生成的 AGENTS.md）

```
日常开发: brainstorming → openspec-explore → openspec-propose → writing-plans → subagent-driven-development
交互调整: brainstorming → 直接实现 → docs/interaction-changes/ 记录
调试:     systematic-debugging
完成前:   verification-before-completion
```

## 一个最小例子

**用户输入**：
> "做一个待办应用。要支持标签和优先级。参考 Things 3 和 todoist。测试要覆盖：空列表、超长标题、删除已完成项三种场景。"

**三分类**：
- 需求：待办 / 标签 / 优先级
- 参考：Things 3、Todoist
- 测试场景：空列表、超长标题、删除已完成项

**产出**：

```
todo-app/
├── AGENTS.md                          ← 写命令 + 约定，不写需求
├── README.md
├── src/
├── tests/scenarios/
│   ├── empty-list.md
│   ├── long-title.md
│   └── delete-completed.md
├── docs/
│   ├── requirements.md                ← 标签 + 优先级 + P0/P1
│   └── references.md                  ← Things 3 / Todoist 一句话用途
└── package.json
```

AGENTS.md 里**只写**：项目定位、目录、命令、约定、指向 `docs/` 的分流。**不写**"要支持标签"。
