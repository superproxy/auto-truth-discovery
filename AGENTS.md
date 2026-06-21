# truth-discovery

求真辨伪 skill 工程——通过方法论 + 大模型知识库 + 网络知识库 + 本地案例库，对历史、文化、经典文本、人物品牌与公共叙事做分层求真判断。

## 核心原则

不回答二元化的"真/假"。把宣称拆成多层，追溯证据距离，检查知识谱系，识别利益动机，对每一层给出等级判断。使用怀疑但不阴谋论的立场：很多传统是混合对象，不是纯粹事实，也不是纯粹骗局。

## 工程结构

```
skills/truth-discovery/           # skill：辩证法主干 + 经典案例 + 长参考
├── SKILL.md                      # 辩证法主干（通用入口）
├── cases/                        # 经典案例
├── tools/checklist.md            # 操作检查清单
└── references/                   # 专题长参考与旧版框架

agents/                           # 智能体：角色 + 工作流
├── roles/                        # 5个角色（collector/challenger/reasoner/judge/optimizer）
├── RULES.md                      # 执行规则（含角色能力同步规则）
└── debate-workflow.yaml          # 全流程辩论工作流（8步）

debates/                          # 辩论场地
├── topics.md                     # 600个辩题（18领域，17个✅已辩论）
├── process/                      # 辩论过程记录（每个辩题一个文件）
└── conclusions/                  # 裁判结论（每个辩题一个文件 + README汇总）

findings/                         # skill直接判断（非辩论产出，与debates平行）

docs/
└── inquiry-log.md                # 问询分类记录
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

每次 `SKILL.md`、`references/` 或核心案例更新后，相关角色在 24 小时内同步更新。Optimizer 每场辩论结束后检查角色能力同步。

## 辩论场地

| 维度 | 目录 | 内容 |
|---|---|---|
| 事 | `debates/topics.md` | 600辩题（18领域），✅=已辩论 |
| 过程 | `debates/process/` | 质疑-推理交锋记录 |
| 结果 | `debates/conclusions/` | 裁判结论、分层判断、置信度 |

> 方法论增量不单独存于 debates/。通用原则进 `SKILL.md`，专题长参考进 `references/`，可复用样本进 `cases/`。

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

### 辩证法主干

| 工具 | 说明 |
|---|---|
| 矛盾分析 | 看叙事内部冲突、利益冲突、身份冲突、制度冲突 |
| 发展分析 | 看对象如何生成、变形、标准化、神圣化或商业化 |
| 联系分析 | 放入同期制度、贸易、战争、宗教、教育和出版网络 |
| 层次分析 | 拆开人物/事件/文本/归属/传承/包装，避免压成一个名字 |
| 条件分析 | 查前人、工具、机构、资金、传播链是否支撑宣称 |
| 转化分析 | 判断真实核心如何变成权威品牌，弱证据如何变成常识 |

### 专题参考

| 章节 | 核心内容 |
|---|---|
| 证据不对称 | 缺失不等价、隐匿加权、举证责任不对称、幸存者偏差 |
| 隐匿模式 | 七种隐匿模式类型学（物理销毁/机构清洗/叙事替代/证人消除/时间稀释/分类遮蔽/合法化清洗） |
| 完美犯罪问题 | 可判断/可推断/永久待证/不可知 四层处理、"无法证明≠未发生" |
| 异常聚类 | 七种异常类型、概率聚合、与隐匿模式对照 |
| 制造传统 vs 商业放大 | 从零制造（渗透率<10%）vs 商业放大（>30%）、社会强制维持机制、知情≠自由 |
| 科学共识污染 | 引用级联/基金偏向/选择性发表/Meta分析污染/旋转门 |
| 防御模式识别 | "承认小错、坚持大结论"模式 |
| 旧方法论全文 | `skills/truth-discovery/references/legacy-methodology.md` |

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
- **SKILL.md 体积控制**：只放通用辩证法主干；专题长参考放 `references/`，样本放 `cases/`，清单放 `tools/`
- **问询分类记录**：每次问询记录到 inquiry-log.md，标注"提炼点/需求/参考资料"
- **角色能力同步**：`SKILL.md`、`references/` 或核心案例更新后 24h 内同步角色文件
- **中文优先**：说明、案例、记录、方法论使用中文
- **没有构建/测试运行器**：靠 prompt 触发验证

## 指令源优先级

1. 本文件 = 仓库结构与命令的唯一权威
2. `skills/truth-discovery/SKILL.md` = skill 行为的唯一权威
3. `agents/RULES.md` = 多角色辩论执行规则
