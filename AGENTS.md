# truth-discovery

求真辨伪 skill 工程——通过方法论 + 大模型知识库 + 网络知识库 + 本地案例库，对历史、文化、经典文本、人物品牌与公共叙事做分层求真判断。

## 核心原则

不回答二元化的"真/假"。把宣称拆成多层，追溯证据距离，检查知识谱系，识别利益动机，对每一层给出等级判断。使用怀疑但不阴谋论的立场：很多传统是混合对象，不是纯粹事实，也不是纯粹骗局。

## 工程结构

```
.agents/                           # agent 工程配置（skill + 工作流 + 初始化来源）
├── README.md                      # 本目录索引（结构以根目录 AGENTS.md 为准）
├── skills/
│   └── truth-discovery/           # skill：辩证法主干 + 经典案例 + 长参考
│       ├── SKILL.md               # 辩证法主干（通用入口）
│       ├── cases/                 # 经典案例
│       ├── tools/checklist.md     # 操作检查清单
│       └── references/            # 专题长参考与旧版框架
├── skills-init/
│   ├── README.md                  # 来源引用清单（谁初始化了本工程）
│   └── init-loop-agents/
│       └── SKILL.md               # init-loop-agents 本地副本（通用工作流执行引擎）
├── roles/                         # 5个角色（collector/challenger/reasoner/judge/optimizer）
├── RULES.md                       # 执行规则（含角色能力同步规则）
├── debate-workflow.yaml           # 全流程辩论工作流（14步）
├── automations.yaml               # 自动化定义唯一真相源（调度+完整提示词+薄引导）
├── AUTOMATION.md                  # 人类可读版：统一规范 + Agent 执行手册
├── run-debate.sh                  # 命令行兜底：无头 CLI 读真相源跑一轮/循环
├── loop-debate.sh                 # 旧方案：IDE 会话内定时脚本（薄引导）
└── debate-git-publish.sh          # 辩论落盘提交推送

debates/                           # 辩论场地（产出，留在根目录）
├── topics.md                      # 600个辩题（18领域，✅=已辩论）
├── process/                       # 辩论过程记录
└── conclusions/                   # 裁判结论 + README汇总

findings/                          # skill直接判断（非辩论产出，与debates平行）
docs/inquiry-log.md                # 问询分类记录
tests/                             # 场景与验收
```

> 目录约定：`.agents/` 存放"agent 如何思考与执行"（配置与能力），根目录存放"辩论产生了什么"（数据与结论）。
> 迁移历史：2026-11-17 由根目录 `skills/`、`agents/` 迁入 `.agents/`；同年取消 `.agents/agents/` 嵌套，工作流与角色文件平铺在 `.agents/` 根级；上游路径引用见 `.agents/skills-init/README.md`。

## 初始化来源（重要）

本工程由上游 skill 仓库 https://github.com/superproxy/skills 的 **`init-loop-agents`** skill 初始化，
其 `patterns/loop-enginerring/` 是本工程辩论工作流的原型。引用与副本见 `.agents/skills-init/`。
- **引擎（上游）**：`.agents/skills-init/init-loop-agents/SKILL.md` — 通用工作流解析/调度/执行/保存协议
- **实例（本项目）**：`.agents/debate-workflow.yaml` + `.agents/roles/` — 求真辨伪 14 步与五个角色（与 skill 同层，均在 `.agents/`）
- 上游 skill 更新时只同步协议层改动，不改本项目角色/工作流实例。

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
        ├── 角色同步   → .agents/roles/*.md
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

## 定时触发与 agent 执行

- **唯一真相源**：`.agents/automations.yaml`（调度字段 + 完整 `execution_prompt` + 薄 `bootstrap_prompt`）。
  平台与命令行脚本都只存薄引导/读取同一份，**禁止在别处复制完整提示词**。
- **人类执行手册**：`.agents/AUTOMATION.md`（含 L1-L9 拓扑层、闭环三件套、统一规范、命令行兜底）。
- **触发方式（三选一，勿双开）**：
  1. 平台 recurring automation「求真辨伪辩论·定时循环」——注入薄引导，agent 读 yaml 取全文执行（主用）；
  2. 命令行兜底 `bash .agents/run-debate.sh [--loop]`——平台不支持时用 `codebuddy -p` 无头跑同一份定义；
  3. 旧方案 `.agents/loop-debate.sh`——IDE 会话内 Monitored shell（薄引导）。
- **agent 醒来后做什么**：读 yaml 取 `execution_prompt` → 读 AUTOMATION.md/RULES/workflow → 取首个未标 ✅ 辩题 → 按 L1-L9 层执行（层内并行、层间串行）→ 落盘 → 标 ✅ + 计数 +1 → 记问询 → 实跑 git 发布 → 报告。
- **改什么同步到哪里**：改流程/提示词只改 yaml（平台不用动）；改 `rrule`/`status`/`cwd` 才同步平台；按 name 精确匹配更新，禁止新建同名任务（详见 AUTOMATION.md 第 2.3 节）。

## 已结案（41 场，全表见 `debates/conclusions/README.md`）

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
| 18 | [《国语》与《左传》是否为同一作者？](debates/conclusions/guoyu-zuozhuan-same-author.md) | 共享传统高度可能，同一作者过度宣称，左氏二书为经学单名压缩 | 经学包装 |
| 19 | [班固是否独立完成《汉书》？](debates/conclusions/ban-gu-hanshu-ban-biao.md) | 主撰与承父未竟高度可能，强独立完成过度宣称，累积成书 | 累积发明 |
| 20 | [司马迁《史记》可靠记录与文学虚构](debates/conclusions/shiji-reliable-record-vs-fiction.md) | 分层史料综合体；载言与五帝前过度宣称；全书信史品牌化 | 分层史料 |
| 21 | [司马迁对秦始皇的描述是否存在汉代政治偏见？](debates/conclusions/sima-qian-qinshihuang-han-bias.md) | 事件骨架高度可信；暴君内核真实但道德框架带汉初过秦话语结构性投影；暴君常识形象后世品牌化 | 结构性投影 |

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
| 隐匿模式 | 七种隐匿模式类型学 |
| 完美犯罪问题 | 可判断/可推断/永久待证/不可知 四层处理 |
| 异常聚类 | 七种异常类型、概率聚合、与隐匿模式对照 |
| 归因污染梯度 | 单一人物叙事骨架→属性→框架→品牌分层、结构性投影 vs 个人偏见 |
| 制造传统 vs 商业放大 | 从零制造 vs 商业放大、社会强制维持机制、知情≠自由 |
| 科学共识污染 | 引用级联/基金偏向/选择性发表/Meta分析污染/旋转门 |
| 防御模式识别 | "承认小错、坚持大结论"模式 |
| 旧方法论全文 | `.agents/skills/truth-discovery/references/legacy-methodology.md` |

## 关键命令

| 任务 | 命令 |
|---|---|
| 查看方法论 | `cat .agents/skills/truth-discovery/SKILL.md \| head -5` |
| 查看辩题库 | `grep ✅ debates/topics.md` |
| 查看结论汇总 | `cat debates/conclusions/README.md` |
| 查看角色 | `ls .agents/roles/` |
| 查看自动化定义（真相源） | `cat .agents/automations.yaml` |
| 查看执行手册/统一规范 | `cat .agents/AUTOMATION.md` |
| 查看初始化来源 | `cat .agents/skills-init/README.md` |
| 查看问询记录 | `cat docs/inquiry-log.md` |
| 手动跑一轮辩论 | `bash .agents/run-debate.sh`（或把 yaml 的 execution_prompt 发给 agent） |

## 约定

- **单源维护**：本仓库 = source of truth
- **SKILL.md 体积控制**：只放通用辩证法主干；专题长参考放 `references/`，样本放 `cases/`，清单放 `tools/`
- **问询分类记录**：每次问询记录到 inquiry-log.md，标注"提炼点/需求/参考资料"
- **角色能力同步**：`SKILL.md`、`references/` 或核心案例更新后 24h 内同步角色文件
- **中文优先**：说明、案例、记录、方法论使用中文
- **没有构建/测试运行器**：靠 prompt 触发验证

## 指令源优先级

1. 本文件 = 仓库结构与命令的唯一权威
2. `.agents/skills/truth-discovery/SKILL.md` = skill 行为的唯一权威
3. `.agents/RULES.md` = 多角色辩论执行规则
4. `.agents/automations.yaml` = 自动化定义唯一真相源（调度 + 提示词）
5. `.agents/AUTOMATION.md` = 人类可读版执行手册与统一规范
6. `.agents/skills-init/README.md` = 初始化来源引用
