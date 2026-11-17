# 定时辩论循环 · 自动化规范与执行手册

> **定义在哪里？** 调度的权威定义（name / rrule / status / cwd / 完整提示词）在
> [`.agents/agents/automations.yaml`](automations.yaml) 的 `truth-discovery-debate-loop` 条目。
> 本文件是它的**人类可读版执行手册**：讲清定时器触发后 agent 具体怎么做。
> 两者分工：yaml = 机器可读单一真相源；本文件 = 执行时的操作说明。

## 1. 意图

让 agent 每 1 小时自动醒来，执行一轮 `.agents/agents/debate-workflow.yaml` 全流程辩论，
从 `debates/topics.md` 消费下一个未辩题，产出过程与结论，并把该题标记完成。

这是一场 agent **自己给自己定时发消息**的接力——不依赖 IDE 的 Shell 输出监视器，
也不依赖任何常驻脚本。

## 2. 自动化定义的统一规范（如何处理"定义散落"）

### 2.1 问题与原则

历史上，同一个自动化的定义被复制到多处：平台任务提示词、`AUTOMATION.md` §3、
`loop-debate.sh` 的 heredoc、`RULES.md`/`AGENTS.md`/`README.md` 的散述。
结果任一处改动都会造成副本漂移（曾出现平台提示词含"README 追加结论行"、
而本文件 §3 缺失的版本不一致）。

**统一原则（单一真相源 + 薄引导）：**

| 角色 | 载体 | 存什么 | 禁止 |
|---|---|---|---|
| 权威定义 | `.agents/agents/automations.yaml` | 调度字段 + 完整 `execution_prompt` + 薄 `bootstrap_prompt` | — |
| 定时载体 | 平台 automation | 仅 `bootstrap_prompt`（薄引导，指向 yaml） | 内嵌完整提示词 |
| 本地载体 | `.agents/agents/loop-debate.sh` | 仅薄引导 | 内嵌完整提示词 |
| 人类说明 | 本文件 / RULES / AGENTS / README | 执行手册与入口指针 | 复制完整提示词正文 |

### 2.2 平台字段与去重

- 平台实际字段：`name` / `prompt` / `scheduleType` / `rrule` / `status` / `cwds`。
- **去重靠 `name` 精确匹配**：存在则 update，不存在才 create，禁止新建第二个同名任务。
- 旧版本曾写 `sync_key: truth-discovery-debate-loop`，但**平台无此字段**，是无效契约，已废弃。
  以 yaml 中 `platform.known_id` 仅作核对，不作去重依据。

### 2.3 改什么、同步到哪里（决策表）

| 改动 | 只需改 | 是否动平台 |
|---|---|---|
| 辩论步骤 / 提示词措辞 / 拓扑层 | `automations.yaml` 的 `execution_prompt` | ❌ 不用（平台只存薄引导） |
| 调度频率 `rrule` / `status` / `cwd` | `automations.yaml` 的 `schedule` | ✅ 同步更新平台同名字段 |
| 薄引导本身 | `automations.yaml` 的 `bootstrap_prompt` | ✅ 同步平台 prompt |
| 角色人格 / 方法论 | `roles/*.md`、SKILL | ❌ 不用 |

> 这正是薄引导的核心收益：绝大多数改动只落一处，平台不再持有会漂移的副本。

### 2.4 范围边界

本规范只管**读写本仓库产出**（`debates/`、`docs/`）的自动化。平台级/个人任务
（如"生成昨日 AI 重点资讯总结"）在 yaml 的 `out_of_scope` 登记，不纳入同步。

## 3. 薄引导（平台与脚本注入的原文）

```
执行 auto-truth-discovery 项目的一轮「求真辨伪」辩论工作流。
工作目录：/Users/yangxuezeng/Desktop/auto-truth-discovery（若工具不继承工作目录，先切换到该目录）。
本任务为薄引导：完整执行指令在 .agents/agents/automations.yaml 中 id=truth-discovery-debate-loop 的 execution_prompt 字段。
请先用 Read 读取该文件，取出 execution_prompt 全文并严格执行；不要自行简化或改写步骤。
```

**完整执行提示词**请读 `.agents/agents/automations.yaml` → `execution_prompt`（唯一权威正文）。

## 4. Agent 执行手册：定时器触发后，agent 具体怎么做

> 新会话 agent 无历史上下文时，先读本节 + RULES.md + debate-workflow.yaml。
> 若不确定从哪开始，按下方拓扑层逐层执行。

### 触发链路

```
平台调度器（每小时，rrule 在 automations.yaml）
   └─ 注入第 3 节薄引导 → 新会话 agent（无历史上下文）
         └─ agent 读 automations.yaml 取 execution_prompt 全文
               └─ 读本文件 + RULES.md + debate-workflow.yaml
                     └─ 按下方拓扑层逐层执行一轮辩论
                           └─ 落盘 → 标 ✅ → 记问询 → git 提交推送 → 简要报告
```

- **触发者**：WorkBuddy 平台的 recurring automation（薄引导由平台注入）。
- **执行者**：收到提示词的 agent，**完全自包含**，不依赖任何历史对话。
- **终止条件**：题库耗尽（全部 ✅）时输出「辩题库已耗尽」并正常结束。

### 一轮执行的拓扑层（严格层间顺序，层内可并行）

| 层 | 步骤（step id） | 执行方式 | 读取的人格文件 |
|---|---|---|---|
| L1 | `collector_search` + `challenger_round_1` | 2 个子智能体并行 | `collector.md`、`challenger.md` |
| L2 | `reasoner_round_1` | 单步 | `reasoner.md` |
| L3 | `challenger_round` | 单步 | `challenger.md` |
| L4 | `reasoner_round` | 单步 | `reasoner.md` |
| L5 | `challenger_loop` | 循环体：未达「无新问题」则回到 L4，≤ workflow 的 `max_iterations` | `challenger.md` |
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

不定时器等，直接把第 3 节薄引导发给 agent 即可跑一轮（agent 会自行读 yaml 取全文）。

## 4.5 平台不支持时：用命令行完成（兜底路径）

> 若平台 automation 不可用、被禁，或需要在 CI / 裸机 / 无图形环境下调度，
> 用无头 CLI 跑同一份定义——**仍读 `automations.yaml` 的 `execution_prompt`，不另存副本**。

前提（本机 2026-11-17 核实）：
- `codebuddy` CLI 在 PATH 中，支持 `-p/--print` 无头模式与 `--permission-mode`；系统有 `crontab` / `launchctl`。
- **必须先认证**：CLI 无头调用报 `Authentication required` 属正常，首次需交互式运行 `codebuddy` → `/login` 登录一次；
  之后再无头调用即可。CI/裸机环境需提前配好对应凭据，否则兜底链路跑不通。
- PyYAML 不可用，脚本用 awk 提取正文（已实测可正确取出 16 行完整正文，无误抓）。

```bash
# 跑一轮（立即验证）
bash .agents/agents/run-debate.sh

# 定时循环（每 1h，等效平台 rrule）
LOOP_DEBATE_INTERVAL=3600 bash .agents/agents/run-debate.sh --loop

# 权限模式覆盖（无人值守默认 bypassPermissions；收紧可改）
DEBATE_AGENT_PERM_MODE=acceptEdits bash .agents/agents/run-debate.sh

# 日志默认 /tmp/auto-truth-discovery-debate-cli.log，可覆盖
DEBATE_CLI_LOG=/path/to/log bash .agents/agents/run-debate.sh --loop
```

**`run-debate.sh` 做什么**：`cd` 到仓库根 → awk 从 `automations.yaml` 提取 `execution_prompt`
（去缩进，不依赖 PyYAML）→ `codebuddy -p --permission-mode "$PERM_MODE" "$PROMPT"` 无头执行
→ 输出 tee 到日志 → `--loop` 时 sleep 指定间隔重复。辩论末步仍实跑 `debate-git-publish.sh` 闭环。

**系统级常驻（可选，二选一）**：
- cron：`crontab -e` 加 `0 * * * * cd <repo> && bash .agents/agents/run-debate.sh >> <log> 2>&1`
- launchd：写 plist 指向 `run-debate.sh`，`launchctl load`；比 cron 更适合 macOS（权限/唤醒更稳）。
- 脚本自带 `--loop`（前台 sleep 循环）是最简方案，配合 `tmux`/终端保活即可，无需系统调度器。

**与平台互斥**：只启用一条触发链（平台 automation / run-debate.sh / loop-debate.sh 三选一），
否则会双开辩论。命令行兜底不需要薄引导——它直接读真相源全文。

## 5. 设计说明（why）

- **为什么薄引导**：新会话看不到历史对话，但**能读仓库文件**。让平台只存指针、厚定义存仓库，
  改流程无需同步平台——这是消除多副本漂移的根本手段。
- **为什么要标记 ✅**：原 `loop-debate.sh` 的提示词只「选首个未标 ✅」却从不标记，循环会永远停在第一题。
  本规范用闭环三件套补上消费闭环。
- **为什么用 automation 而非 Shell 监视器**：Shell 监视器依赖 IDE 会话常驻并匹配输出，
  关掉窗口即失效；automation 由平台调度，与会话生命周期解耦。
- **为什么按 name 去重**：平台没有 `sync_key` 字段；同名 update 是唯一可靠的"不新建重复任务"手段。

## 6. 生命周期操作

| 目的 | 操作 |
|---|---|
| 创建/重建 | 读 `automations.yaml`，按 `schedule` + `bootstrap_prompt` 调用自动化工具，`name` 匹配去重 |
| 改频率/启停 | 改 `automations.yaml` 的 `schedule`，再按第 2.3 节同步平台；每 1h=`FREQ=HOURLY;INTERVAL=1`，每天 9 点=`FREQ=DAILY;BYHOUR=9;BYMINUTE=0` |
| 改提示词 | 只改 `automations.yaml` 的 `execution_prompt`，平台不用动（见 2.3） |
| 暂停 | `status: PAUSED` 后同步，或直接暂停平台同名任务 |
| 停止 | 删除平台「求真辨伪辩论·定时循环」，保留 yaml 以便重建 |
| 立即验证一轮 | 手动把第 3 节薄引导发给 agent |

## 7. 与旧方案的关系

`.agents/agents/loop-debate.sh` 是 IDE 会话内的旧方案（Monitored shell + `notify_on_output`），
其 heredoc 已改为薄引导（与平台同源）。本 platform automation 是其在 WorkBuddy 上的替代实现。
二者**不要同时启用**，否则会双开辩论（`automations.yaml` 中 shell 载体标为 disabled）。
