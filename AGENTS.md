# truth-discovery

求真辨伪 skill 工程——通过方法论 + 大模型知识库 + 网络知识库 + 本地案例库，对历史、文化、经典文本、人物品牌与公共叙事做分层求真判断。

## 核心原则

不回答二元化的"真/假"。把宣称拆成多层，追溯证据距离，检查知识谱系，识别利益动机，对每一层给出等级判断。使用怀疑但不阴谋论的立场：很多传统是混合对象，不是纯粹事实，也不是纯粹骗局。

## 工程结构

```
.agents/                           # agent 工程配置（skill + 工作流 + 初始化来源）
├── README.md                      # 本目录索引（结构以根目录 AGENTS.md 为准）
├── skills/
│   ├── truth-discovery/           # 本工程形成：方法论 + cases + references
│   ├── README.md                  # skill 说明
│   └── paths.yaml                 # 上游 / Loop skill 引用路径
├── roles/                         # 辩论五角色 + git 发布（L9）
├── RULES.md                       # 执行规则（含角色能力同步规则）
├── debate-workflow.yaml           # 全流程辩论工作流（14步）
├── automations.yaml               # Cursor/WorkBuddy 入口 → debate-workflow

debates/                           # 辩论场地（产出，留在根目录）
├── topics.md                      # 600个辩题（18领域，✅=已辩论）
├── process/                       # 辩论过程记录
└── conclusions/                   # 裁判结论 + README汇总

findings/                          # skill直接判断（非辩论产出，与debates平行）
docs/inquiry-log.md                # 问询分类记录
tests/                             # 场景与验收
```

> 目录约定：`.agents/` 存放"agent 如何思考与执行"（配置与能力），根目录存放"辩论产生了什么"（数据与结论）。
> 迁移历史：2026-11-17 由根目录 `skills/`、`agents/` 迁入 `.agents/`；同年取消 `.agents/agents/` 嵌套。项目初始化见下文。

## 项目初始化

本仓库**不**把上游 skill 正文拷进 git。初始化 = 用上游 **pattern 落地本仓库实例** + 会话内 **Read 上游 SKILL 路径**。

### 上游来源

| 项 | 值 |
|---|---|
| 仓库 | https://github.com/superproxy/skills |
| Pattern | `patterns/loop-enginerring/`（求真辨伪原型） |
| 工作流引擎 skill | **`init-role-agents/SKILL.md`** |
| 调度说明 skill | `init-loop-agents/SKILL.md`（通用 `/loop`，非 workflow 正文） |

### 上游 vs 本仓库

| 层级 | 上游（superproxy-skills） | 本仓库（git） |
|---|---|---|
| 工作流引擎说明 | init-role-agents | 只读引用，无副本 |
| 定时自动化实例 | — | `.agents/automations.yaml` |
| Loop 能力 | init-loop-agents、Cursor `loop` skill、**本仓库** `.agents/cursor-loop.sh`（Cursor 专用） | 见「自动化」；与 WorkBuddy 互斥 |
| 工作流实例 | pattern yaml | `.agents/debate-workflow.yaml` |
| 角色 | pattern roles | `.agents/roles/*.md` |
| 执行规则 | pattern RULES | `.agents/RULES.md` |
| 方法论 | — | `.agents/skills/truth-discovery/` |
| 辩论产出 | — | `debates/`、`findings/` |

### 新环境检查清单

1. Clone 本仓库。
2. Clone 或已有上游目录（默认 `~/Desktop/superproxy-skills`）；可选 `export SUPERPROXY_SKILLS=/path/to/superproxy-skills`。
3. **Read** `$SUPERPROXY_SKILLS/init-role-agents/SKILL.md`（跑辩论必须）。
4. 读本仓库：`.agents/RULES.md`、`debate-workflow.yaml`、`automations.yaml`；路径表见 `.agents/skills/paths.yaml`。

勿在本仓库建 vendor / fetch 副本。上游协议变更在 superproxy 维护；本仓库只维护**实例**（yaml、roles、RULES）兼容性。

### Skill 命名分工

- **init-role-agents** — 解析 yaml、化身 roles、Subagent 同层并行、步骤 `loop:`。
- **init-loop-agents** — 调度语义（Read 引用）；本项目 tick 落地在 **`.agents/automations.yaml`**。
- **Cursor `loop` skill** — IDE 内 `/loop` 机制（非本仓库文件）；配置定时时 Read 该 skill + init-loop-agents，再读本仓库 `automations.yaml`。

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

## 自动化

入口：[`.agents/automations.yaml`](.agents/automations.yaml)（`platforms` + `execution_prompt` → `debate-workflow.yaml`）。

### 指令：自动化执行

用户说出「自动化执行」（或同义：跑一轮辩论 / 执行辩论工作流）时，agent **立即**按下列步骤执行，勿再问是否确认：

1. Read `.agents/automations.yaml` → 取 `execution_prompt`
2. 按 `execution_prompt`：读 `.agents/RULES.md` 与 `.agents/debate-workflow.yaml`，用 init-role-agents 跑一整轮
3. 辩题 = `debates/topics.md` 第一个行尾无 ✅；若全无 ✅ 则报告结束并停止
4. 落盘、标 ✅、问询记录、L9 git（`roles/git.md`）按工作流末步完成

平台定时（WorkBuddy recurring / Cursor `cursor-loop.sh` 或 `/loop`）唤醒时同样执行本指令；WorkBuddy 与 Cursor 勿同时开（见 yaml `mutex`）。

## 已结案（45 场，全表见 `debates/conclusions/README.md`）

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
| 22 | [希罗多德"历史之父"还是"谎言之父"](debates/conclusions/herodotus-credibility.md) | 两称号皆后世包装、分层兼容；骨架粗粒度高度可信；内容沿来源梯度递减 | 双极品牌化 |
| 23 | [修昔底德演讲词（葬礼演说）实录还是文学创作？](debates/conclusions/thucydides-speeches.md) | 骨架高度可能；措辞近已证伪；论旨无弱可推断正份额；代言式拟辞＋民主圣典品牌化 | 张力元文本 / 载言分裁 |
| 24 | [普鲁塔克《希腊罗马名人传》是历史还是道德寓言？](debates/conclusions/plutarch-parallel-lives.md) | 道德化平行列传工程；塑形已确认≠寓言；轶事零正份额；3a相容待核；Synkrisis设计污染；双重品牌 | 道德塑形 / 设计污染 |
| 25 | [苏埃托尼乌斯《十二凯撒传》中的轶事是史料还是八卦？](debates/conclusions/suetonius-twelve-caesars.md) | 帝王轶事—类型学 bios；职位光环≠保管链；文书(a)/(b)；V0–V3；轶事零正份额；谓词隔离；双重品牌 | 零正份额 / 声誉史 / 职位光环 |

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
| 作者方法元文本／载言保真 | 三层切割 (a)/(b)/(c)、软约束空转、弱可推断禁令、证据类型 0／100；见 `references/author-method-meta-text-fidelity.md` |
| 道德化传记／bios 工程 | 塑形≠寓言、3a≠3b、比较装置设计污染、跨体裁双标、B1–B3；帝王轶事变体（职位光环≠保管链、文书(a)/(b)、V0–V3、谓词隔离、声誉史不回流）；见 `references/moralized-bios-engineering.md` |
| 旧方法论全文 | `.agents/skills/truth-discovery/references/legacy-methodology.md` |

## 关键命令

| 任务 | 命令 |
|---|---|
| 查看项目初始化 | 本文件「项目初始化」节 |
| 查看方法论 | `cat .agents/skills/truth-discovery/SKILL.md \| head -5` |
| 查看辩题库 | `grep ✅ debates/topics.md` |
| 查看结论汇总 | `cat debates/conclusions/README.md` |
| 查看角色 | `ls .agents/roles/` |
| 查看自动化入口 | `cat .agents/automations.yaml` |
| 查看 skill 说明 | `cat .agents/skills/README.md` |
| 查看 Loop 引用 | `cat .agents/skills/paths.yaml` |
| 查看问询记录 | `cat docs/inquiry-log.md` |
| **自动化执行** | 用户指令 → 本文件「指令：自动化执行」→ `automations.yaml` `execution_prompt` |
| **Cursor 专用 loop** | `.agents/cursor-loop.sh`（默认 3600s；`LOOP_INTERVAL=秒`；发 `AGENT_LOOP_TICK_*`；与 WorkBuddy/`/loop` 互斥） |

## 约定

- **单源维护**：辩论产出 + **方法论 skill**（`skills/truth-discovery`）在本仓库 git；**自动化**在 `.agents/automations.yaml`；**Loop** 为外部 skill 引用
- **外部 skill**：不进库；新环境见本文件「项目初始化」
- **问询分类记录**：每次问询记录到 inquiry-log.md，标注"提炼点/需求/参考资料"
- **角色能力同步**：`SKILL.md`、`references/` 或核心案例更新后 24h 内同步角色文件
- **中文优先**：说明、案例、记录、方法论使用中文
- **没有构建/测试运行器**：靠 prompt 触发验证

## 指令源优先级

1. 本文件 = 仓库结构与命令的唯一权威
2. `.agents/skills/truth-discovery/SKILL.md` = skill 行为唯一权威
3. `.agents/RULES.md` = 多角色辩论执行规则
4. `.agents/automations.yaml` = Cursor/WorkBuddy 唤醒与 execution_prompt
5. 本文件「项目初始化」= 上游对齐与新环境说明
6. 外部 **init-role-agents**（`paths.yaml`）= 工作流引擎；**init-loop-agents** / Cursor **loop** = 调度能力（引用，非本仓库）
