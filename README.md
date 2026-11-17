# truth-discovery

求真辨伪 skill 工程——通过方法论 + 大模型知识库 + 网络知识库 + 本地案例库，对历史、文化、经典文本、人物品牌与公共叙事做分层求真判断。

## 三个维度

| 维度 | 说明 | 入口 |
|---|---|---|
| **使用 skill** | 加载 skill 直接求真判断，快速输出分层结论 | `.agents/skills/truth-discovery/SKILL.md` |
| **辩论 agent** | 五角色全流程辩论，质疑-推理-裁判-优化 | `.agents/agents/debate-workflow.yaml` |
| **重要结论** | 所有判断结果汇总，含分层判断、置信度、标签 | `debates/conclusions/README.md` |

## 核心原则

不回答二元化的"真/假"。把宣称拆成多层，追溯证据距离，检查知识谱系，识别利益动机，对每一层给出等级判断。

## 工程结构

```
.agents/                           # agent 工程配置
├── skills/truth-discovery/        # 自有 skill：主干 + 案例 + 参考 + 清单
├── skills-init/init-loop-agents/  # 上游初始化 skill 的引用与副本
└── agents/                        # 辩论 agent：角色 + 工作流 + 定时规范
    ├── roles/                     # 5个角色
    ├── RULES.md                   # 执行规则（含角色能力同步）
    ├── debate-workflow.yaml       # 全流程辩论工作流（14步）
    ├── automations.yaml           # 自动化定义唯一真相源
    ├── AUTOMATION.md              # 统一规范 + Agent 执行手册（含命令行兜底）
    └── *.sh                       # run-debate(CLI兜底) / loop-debate(旧) / git-publish

debates/                           # 辩论场地（产出）
├── topics.md                      # 600个辩题（18领域，✅=已辩论）
├── process/                       # 辩论过程记录
└── conclusions/                   # 裁判结论 + README汇总
findings/                          # skill直接判断（非辩论产出）
docs/inquiry-log.md                # 问询分类记录
```

## 初始化来源

本工程由 https://github.com/superproxy/skills 的 `init-loop-agents` skill 初始化，
其 `patterns/loop-enginerring/` 为辩论工作流原型。引用声明与本地副本见 `.agents/skills-init/README.md`。

## 定时触发与 agent 执行

- **唯一真相源**：`.agents/agents/automations.yaml`（调度 + 完整提示词 + 薄引导）；
  **执行手册**：`.agents/agents/AUTOMATION.md`（L1-L9 拓扑层、闭环三件套、命令行兜底）。
- **三选一，勿双开**：① 平台 automation（注入薄引导，agent 读 yaml 执行，主用）；
  ② 命令行兜底 `bash .agents/agents/run-debate.sh [--loop]`（平台不支持时用 `codebuddy -p` 无头跑同一份定义）；
  ③ 旧方案 `loop-debate.sh`（IDE Monitored shell）。
- agent 醒来后：取首个未标 ✅ 辩题 → 逐层执行 → 落盘 → 标 ✅+计数 → 记问询 → 实跑 git 发布 → 报告。
- 改流程/提示词只改 yaml（平台不用动）；改 `rrule`/`status`/`cwd` 才同步平台；按 name 匹配更新，勿建第二个。

## 工作流全景

```
🔍 Collector      搜索话题 → 八维度打分 → 精炼表述
        │
        ▼
🔴 Challenger  ⇄  🟢 Reasoner   反复辩论（无新问题则结案）
        │
        ▼
⚖️ Judge          比较证据强度 → 分层结论 → 最终报告
        │               └→ debates/conclusions/
        ▼
🛠️ Optimizer      审查辩论 → 沉淀方法论/案例 → 同步角色能力 → 记录问询
        │
        ├── 通用原则   → .agents/skills/truth-discovery/SKILL.md
        ├── 专题参考   → .agents/skills/truth-discovery/references/
        ├── 经典案例   → .agents/skills/truth-discovery/cases/
        ├── 角色同步   → .agents/agents/roles/*.md
        ├── 辩题标注   → debates/topics.md ✅
        └── 问询记录   → docs/inquiry-log.md
```

## 角色能力同步飞轮

```
辩论产生方法论增量 → 主干/参考/案例分流沉淀 → 角色文件同步注入 → 下一场辩论能力更强
```

## 已结案（41场，全表见 `debates/conclusions/README.md`）

| # | 辩题 | 结论 | 标签 |
|---|---|---|---|
| 1 | [Aristotle 品牌语料库](debates/conclusions/aristotle-brand-corpus.md) | 真实人物核心+学派材料+后世品牌化 | 品牌化 |
| 2 | [Shakespeare 作者争议](debates/conclusions/shakespeare-authorship.md) | 核心剧作高度可能，全部独自完成过度宣称 | 品牌化 |
| 3 | [戴比尔斯钻石"传统"](debates/conclusions/debeers-diamond-tradition.md) | "古老传统"已证伪，制造习俗已确认 | 品牌化 |
| 4 | [制糖业操纵营养科学](debates/conclusions/sugar-industry-science-manipulation.md) | 操纵已确认，科学共识品牌化 | 品牌化 |
| 5 | [斯坦福监狱实验](debates/conclusions/stanford-prison-experiment.md) | 实验已证伪，教材经典地位品牌化 | 品牌化 |
| 6 | [老子与《道德经》](debates/conclusions/laozi-daodejing.md) | 人物合理，个人著作过度宣称 | 品牌化 |
| 7 | [约瑟夫斯耶稣段落](debates/conclusions/josephus-testimonium.md) | 全段真品已证伪，篡改已确认 | 改写 |
| 8 | [亚特兰蒂斯](debates/conclusions/atlantis.md) | 历史事实已证伪，哲学寓言已确认 | 品牌化 |
| 9 | [哥伦布"发现"美洲](debates/conclusions/columbus-discovery.md) | "发现"过度宣称，欧洲中心主义建构 | 品牌化 |
| 10 | [苹果车库创业](debates/conclusions/apple-garage-myth.md) | 车库创业过度宣称，硅谷品牌化 | 品牌化 |
| 11 | ["希腊奇迹"独立起源](debates/conclusions/greek-miracle.md) | 独立起源已证伪，跨文明累积 | 品牌化 |
| 12 | [爱迪生发明电灯泡](debates/conclusions/edison-lightbulb.md) | 发明过度宣称，累积发明 | 累积发明 |
| 13 | [COVID-19起源](debates/conclusions/covid19-origin.md) | 永久待证，政治化已确认 | 待证 |
| 14 | [假新闻传播速度](debates/conclusions/fake-news-speed.md) | 传播更快已确认，人类心理是主因 | 已确认 |
| 15 | [大脑10%迷思](debates/conclusions/brain-10-percent.md) | 已证伪，詹姆斯被误读 | 已证伪 |
| 16 | [《山海经》记录可信度](findings/shanhaijing.md) | 山经地理高度可信，异兽过度宣称 | 品牌化 |
| 17 | [庞贝古城与中国联系](findings/pompeii-china.md) | 直接联系极弱，间接丝绸贸易高度可能 | 未发现 |
| 18 | [司马迁对秦始皇的描述是否存在汉代政治偏见？](debates/conclusions/sima-qian-qinshihuang-han-bias.md) | 事件骨架高度可信；暴君内核真实但道德框架带汉初过秦话语结构性投影；后世品牌化 | 结构性投影 |

## 关键命令

| 任务 | 命令 |
|---|---|
| 查看方法论 | `cat .agents/skills/truth-discovery/SKILL.md \| head -5` |
| 查看辩题库 | `grep ✅ debates/topics.md` |
| 查看结论汇总 | `cat debates/conclusions/README.md` |
| 查看自动化定义 | `cat .agents/agents/automations.yaml` |
| 查看执行手册 | `cat .agents/agents/AUTOMATION.md` |
| 手动跑一轮 | `bash .agents/agents/run-debate.sh`（或把 yaml 的 execution_prompt 发给 agent） |

## 约定

- **单源维护**：本仓库 = source of truth；配置在 `.agents/`，产出在根目录
- **问询分类记录**：每次问询记录到 inquiry-log.md，标注"提炼点/需求/参考资料"
- **角色能力同步**：`SKILL.md`、`references/` 或核心案例更新后 24h 内同步角色文件
- **中文优先**：说明、案例、记录、方法论使用中文

## 指令源优先级

1. `AGENTS.md` = 仓库结构与命令的唯一权威
2. `.agents/skills/truth-discovery/SKILL.md` = skill 行为的唯一权威
3. `.agents/agents/RULES.md` = 多角色辩论执行规则
4. `.agents/agents/automations.yaml` = 自动化定义唯一真相源
5. `.agents/agents/AUTOMATION.md` = 执行手册与统一规范
