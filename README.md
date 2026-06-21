# truth-discovery

求真辨伪 skill 工程——通过方法论 + 大模型知识库 + 网络知识库 + 本地案例库，对历史、文化、经典文本、人物品牌与公共叙事做分层求真判断。

## 三个维度

| 维度 | 说明 | 入口 |
|---|---|---|
| **使用 skill** | 加载 skill 直接求真判断，快速输出分层结论 | `skills/truth-discovery/SKILL.md` |
| **辩论 agent** | 五角色全流程辩论，质疑-推理-裁判-优化 | `agents/debate-workflow.yaml` |
| **重要结论** | 所有判断结果汇总，含分层判断、置信度、标签 | `debates/conclusions/README.md` |

## 核心原则

不回答二元化的"真/假"。把宣称拆成多层，追溯证据距离，检查知识谱系，识别利益动机，对每一层给出等级判断。

## 工程结构

```
skills/truth-discovery/           # skill：辩证法主干 + 经典案例 + 长参考
├── SKILL.md                      # 辩证法主干（通用入口）
├── cases/                        # 经典案例
├── tools/checklist.md
└── references/                   # 专题长参考与旧版框架

agents/                           # 辩论 agent：角色 + 工作流
├── roles/                        # 5个角色
├── RULES.md                      # 执行规则（含角色能力同步）
└── debate-workflow.yaml          # 全流程辩论工作流（8步）

debates/                          # 辩论场地
├── topics.md                     # 600个辩题（18领域，17个✅）
├── process/                      # 辩论过程记录
└── conclusions/                  # 裁判结论 + README汇总

findings/                         # skill直接判断（非辩论产出）
docs/inquiry-log.md               # 问询分类记录
```

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
        ├── 通用原则   → skills/truth-discovery/SKILL.md
        ├── 专题参考   → skills/truth-discovery/references/
        ├── 经典案例   → skills/truth-discovery/cases/
        ├── 角色同步   → agents/roles/*.md
        ├── 辩题标注   → debates/topics.md ✅
        └── 问询记录   → docs/inquiry-log.md
```

## 角色能力同步飞轮

```
辩论产生方法论增量 → 主干/参考/案例分流沉淀 → 角色文件同步注入 → 下一场辩论能力更强
```

## 已结案（17场）

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

## 方法论体系

| 工具 | 说明 |
|---|---|
| 辩证法主干 | 矛盾、发展、联系、层次、条件、转化 |
| 三道闸门 | 常识优先、信源优先、推理优先 |
| 分层裁判 | 人物/事件/文本/归属/传承/包装分别判断 |
| 证据分级 | S/A/B/C/D/E 六级，先追来源再谈内容 |
| 专题参考 | 证据不对称、隐匿模式、异常聚类、发明优先权、地图工程、商业制造传统等放入 `references/` |
| 案例库 | 经典案例放入 `cases/`，直接判断放入 `findings/` |

## 关键命令

| 任务 | 命令 |
|---|---|
| 查看方法论 | `cat skills/truth-discovery/SKILL.md \| head -5` |
| 查看辩题库 | `grep ✅ debates/topics.md` |
| 查看结论汇总 | `cat debates/conclusions/README.md` |
| 查看角色 | `ls agents/roles/` |
| 查看问询记录 | `cat docs/inquiry-log.md` |

## 约定

- **单源维护**：本仓库 = source of truth
- **问询分类记录**：每次问询记录到 inquiry-log.md，标注"提炼点/需求/参考资料"
- **角色能力同步**：`SKILL.md`、`references/` 或核心案例更新后 24h 内同步角色文件
- **中文优先**：说明、案例、记录、方法论使用中文
- **没有构建/测试运行器**：靠 prompt 触发验证

## 指令源优先级

1. `AGENTS.md` = 仓库结构与命令的唯一权威
2. `skills/truth-discovery/SKILL.md` = skill 行为的唯一权威
3. `agents/RULES.md` = 多角色辩论执行规则
