# 定时辩论循环 · 自动化规范

> 本文件是「求真辨伪辩论」定时循环的**单一真相源**。
> WorkBuddy 读取本文件后，应按下方 `automation` 定义自动创建/更新定时任务。
> 修改调度或提示词时，只改本文件，然后让 WorkBuddy 重新同步即可。

## 1. 意图

让 agent 每 1 小时自动醒来，执行一轮 `.agents/agents/debate-workflow.yaml` 全流程辩论，
从 `debates/topics.md` 消费下一个未辩题，产出过程与结论，并把该题标记完成。

这是一场 agent **自己给自己定时发消息**的接力——不依赖 IDE 的 Shell 输出监视器，
也不依赖任何常驻脚本。

## 2. 自动化定义（供 WorkBuddy 读取）

```yaml
name: "求真辨伪辩论·定时循环"
scheduleType: "recurring"
rrule: "FREQ=HOURLY;INTERVAL=1"
status: "ACTIVE"
cwds: "/Users/yangxuezeng/Desktop/auto-truth-discovery"
sync_key: "truth-discovery-debate-loop"   # 按此 key 查找已有任务，存在则 update，避免重复创建
```

## 3. 提示词（automation 运行时注入，必须自包含）

自动化运行时是全新会话，看不到任何历史对话，因此提示词自带全部路径与规则：

```
执行 auto-truth-discovery 项目的一轮「求真辨伪」辩论工作流。

工作目录：/Users/yangxuezeng/Desktop/auto-truth-discovery
（下文路径均相对该目录；如工具不继承工作目录，请自行切换到该目录）

步骤：
1. 读取 .agents/agents/RULES.md（执行规则）与 .agents/agents/debate-workflow.yaml（工作流定义）。
2. 从 debates/topics.md 中选取「第一个行尾没有 ✅ 的辩题」作为 topic。
   若全部已标 ✅，输出「辩题库已耗尽」并正常结束，不报错。
3. 按 depends_on 做拓扑排序，逐层执行 debate-workflow.yaml 的步骤：
   - 同一拓扑层用子智能体并行派发，并发数遵守 concurrency（默认 6）；
   - 优化者裁判后层为 6 路并行（optimizer_skill_review + 五角色同步 + optimizer_finalize）；
   - 每一步读取 .agents/agents/roles/{role}.md，完全化身该角色，禁止通用回复；
   - 带 loop 的步骤辩论到质疑者「无新问题」，且不超过 max_iterations。
4. 过程写入 debates/process/，结论写入 debates/conclusions/。
5. 【关键闭环】结论落盘后，回到 debates/topics.md，在刚辩完那一题的行尾补上 " ✅"，
   并同步更新文件头部「共 N 场已完成辩论」的计数。不写这一步，下一轮会重复选同一题。
6. 按 RULES.md 要求：记录到 docs/inquiry-log.md；检查是否需要同步更新角色方法论武器库与 SKILL.md。
7. 结束后在仓库根目录执行：`bash .agents/agents/debate-git-publish.sh "<本轮 topic>"`（无变更跳过；有变更则 commit 并 push origin）。
8. 简要报告：本轮辩题、结论文件位置、题库剩余未辩题数、Git 发布结果。
```

## 3.5 Agent 执行手册：定时器触发后，agent 具体怎么做

> 这一节回答「谁来触发、agent 醒来后按什么顺序做什么」。新会话 agent 不知上下文时，先读本节。

### 触发链路

```
平台调度器（每小时）
   └─ 注入第 3 节提示词 → 新会话 agent（无历史上下文）
         └─ agent 读本文件 + RULES.md + debate-workflow.yaml
               └─ 按下方拓扑层逐层执行一轮辩论
                     └─ 落盘 → 标 ✅ → 记问询 → git 提交推送 → 简要报告
```

- **触发者**：WorkBuddy 平台的 recurring automation（第 2 节定义），到点自动注入提示词。
- **执行者**：收到提示词的 agent，**完全自包含**，不依赖任何历史对话。
- **终止条件**：题库耗尽（全部 ✅）时输出「辩题库已耗尽」并正常结束。

### 一轮执行的拓扑层（严格层间顺序，层内可并行）

| 层 | 步骤（step id） | 执行方式 | 读取的人格文件 |
|---|---|---|---|
| L1 | `collector_search` + `challenger_round_1` | 2 个子智能体并行 | `collector.md`、`challenger.md` |
| L2 | `reasoner_round_1` | 单步 | `reasoner.md` |
| L3 | `challenger_round` | 单步 | `challenger.md` |
| L4 | `reasoner_round` | 单步 | `reasoner.md` |
| L5 | `challenger_loop` | 循环体：未达「无新问题」则回到 L4，≤98 轮 | `challenger.md` |
| L6 | `judge_summary` | 单步，产出裁判报告 | `judge.md` |
| L7 | 6 路并行：`optimizer_skill_review` + `optimizer_sync_{collector,challenger,reasoner,judge,optimizer_self}` | 6 个子智能体并行 | `optimizer.md` |
| L8 | `optimizer_finalize` | 汇总落盘：更新 SKILL/角色/topics ✅/inquiry-log | `optimizer.md` |
| L9 | `debate_git_publish` | Shell 实跑 `bash .agents/agents/debate-git-publish.sh "<topic>"` | — |

### 执行要点（每轮不可跳过）

1. **角色化身**：每个 step 必须 `Read .agents/agents/roles/{role}.md`，提取 frontmatter 之后内容作为人格，**禁止通用回复**。
2. **落盘**：过程写 `debates/process/truth-discovery-debate-<日期>-<slug>/steps/{N}-{step_id}.md`；结论写 `debates/conclusions/<slug>.md`。
3. **闭环三件套**（漏掉则下轮空转）：
   - `debates/topics.md` 本题行尾补 ` ✅`，头部计数 +1；
   - `debates/conclusions/README.md` 已结案数 +1 并追加结论行；
   - `docs/inquiry-log.md` 追加一条「需求」记录。
4. **能力同步**：若产生方法论增量，按 RULES.md 第 8 节同步 SKILL.md / references / cases / 五个角色文件。
5. **Git 闭环**：必须用 Shell **实际执行**发布脚本（会 `git add` → `commit` → `push origin`），禁止只写「已推送」。

### 手动触发

不定时器等，直接把第 3 节提示词发给 agent 即可跑一轮；或用旧方案
`LOOP_DEBATE_INTERVAL=3600 .agents/agents/loop-debate.sh`（与 automation 二选一，勿双开）。

## 4. 设计说明（why）

- **为什么自包含**：定时任务在独立会话运行，无法引用当前对话上下文；任何隐含前提都会导致空转。
- **为什么要标记 ✅**：原 `loop-debate.sh` 的提示词只「选首个未标 ✅」却从不标记，循环会永远停在第一题。
  本规范用第 5 步补上消费闭环，这是整套循环能真正推进的关键。
- **为什么用 automation 而非 Shell 监视器**：Shell 监视器依赖 IDE 会话常驻并匹配输出，
  关掉窗口即失效；automation 由平台调度，与会话生命周期解耦。
- **为什么有 sync_key**：保证「重新同步」时更新已有任务而不是重复新建，避免两个循环同时跑。

## 5. 生命周期操作

| 目的 | 操作 |
|---|---|
| 创建/重建 | 让 WorkBuddy 读本文件，按第 2、3 节调用自动化工具；按 `sync_key` 去重 |
| 改频率 | 改第 2 节 `rrule` 后重新同步。每 1h=`FREQ=HOURLY;INTERVAL=1`，每 6h=`FREQ=HOURLY;INTERVAL=6`，每天 9 点=`FREQ=DAILY;BYHOUR=9;BYMINUTE=0` |
| 暂停 | 将 `status` 改为 `PAUSED` 后同步，或直接暂停对应自动化 |
| 停止 | 删除 name 为「求真辨伪辩论·定时循环」的自动化；保留本文件以便日后重建 |
| 立即验证一轮 | 手动把第 3 节提示词发一次给 agent，不必等 6 小时 |

## 6. 与旧方案的关系

`.agents/agents/loop-debate.sh` 是 IDE 会话内的旧方案（Monitored shell + `notify_on_output`），
本规范是其在 WorkBuddy 平台上的替代实现。二者**不要同时启用**，否则会双开辩论。
