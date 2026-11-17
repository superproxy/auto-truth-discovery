# 多角色辩论执行规则

## 1. 核心原则

### 角色能力与 skill 同步

**skill 每次方法论更新后，所有角色必须同步升级。** 方法论更新包括 `SKILL.md` 主干、`references/` 专题长参考和核心案例沉淀。这是本系统的核心飞轮：

```
辩论产生方法论增量
    │
    ▼
主干/参考/案例分流沉淀
    │
    ▼
角色文件同步注入新方法论武器
    │
    ▼
下一场辩论能力更强 → 产生更深的方法论增量
```

**同步规则：**
- 每次 `SKILL.md`、`references/` 或核心案例新增原则/红旗/模式后，相关角色文件必须在 24 小时内更新
- Optimizer 在每场辩论结束后，除了判断是否沉淀到 skill，还必须判断是否需要更新角色能力
- 角色文件末尾的"方法论武器库"章节是同步目标——新增方法论追加到对应角色的武器库

### 辩论记录

每场辩论结束后，辩论记录保存到 `debates/` 目录，与 `.agents/` 平行。

## 2. 解析工作流

读取 `.agents/debate-workflow.yaml`。提取名称、输入、步骤、依赖关系（depends_on）、条件（conditions）和循环（loops）。

## 3. 收集输入

- `required: true` 的输入必须由用户提供
- 有 `default` 的可选输入使用默认值
- 无默认值的可选输入设为空字符串

## 4. 构建执行顺序

按 `depends_on` 进行拓扑排序。无依赖或上游均已完成的步骤划入同一**拓扑层级**。

从 `debate-workflow.yaml` 读取 `concurrency`（默认 `6`）。同一层级内（可用 `parallel_group` 标注，如 `optimizer_post_judge`）：

- `concurrency: 1`：逐步顺序执行。
- `concurrency > 1`：**必须**用子智能体（如 Cursor `Task`）并行派发同层各步骤，每步独立上下文，只注入该步 `task` 与所需 `{{变量}}`。
- 同层并发数不得超过 `concurrency`；超出部分排队到下一批。
- 循环体（`loop`）与 `depends_on` 链上的步骤不得并行，必须等上游输出就绪后再跑下游。

层级全部完成后，再进入下一层。

## 5. 执行步骤

对每个步骤（单进程顺序模式时逐步执行；并发模式下同层批量派发）：

1. 读取 `.agents/roles/{role}.md`
2. 提取 frontmatter（`---`）之后的所有 markdown 内容作为角色人格
3. 将任务中的 `{{变量}}` 替换为上下文值（来自输入或前序步骤输出）
4. **评估条件**：如果设置了 `condition`，评估它。条件不满足则跳过该步骤。运算符：`contains`、`equals`、`not_contains`、`not_equals`
5. **完全化身该角色**——使用该角色的专业知识、方法论框架和沟通风格。输出应有实质内容。
6. 将步骤的输出文本存入上下文变量（如果步骤有 `output` 字段）
7. **检查循环**：如果设置了 `loop` 且退出条件未满足，跳回 `loop.back_to` 步骤（最多 `loop.max_iterations` 轮）

每步标注：`### 步骤 N/总数: step_id (角色名称)`

## 6. 保存结果

将所有输出保存到文件：

```
debates/{工作流名称}-{日期}/
├── steps/
│   ├── 1-{step_id}.md
│   └── ...
├── summary.md          # 最终步骤的完整输出
└── metadata.json       # 步骤状态、耗时、token 统计
```

## 7. 建议迭代

完成后，始终告知用户：

> 如需改进某个步骤，请让我从该步骤重新运行。我会复用所有上游输出。

## 8. 角色能力同步检查清单

每场辩论结束后，Optimizer 必须检查：

| 检查项 | 问题 |
|---|---|
| 新红旗信号 | 是否有新红旗需要加入 Challenger 的武器库？ |
| 新证据模式 | 是否有新证据模式需要加入 Reasoner 的武器库？ |
| 新归属/动机模式 | 是否有新模式需要加入 Judge 的武器库？ |
| 新审核维度 | 是否有新维度需要加入 Collector 的评分体系？ |
| 角色方法论修正 | 辩论中是否暴露了某个角色方法的不足？ |

## 9. 定时后台迭代

> 自动化的**唯一权威定义**在 `.agents/automations.yaml`（调度字段 + 完整提示词）。
> 平台 automation 与本地脚本都只注入薄引导、指向该文件；执行手册见 `.agents/AUTOMATION.md`。
> 去重靠 name 精确匹配更新，禁止新建第二个同名任务；平台无 `sync_key` 字段。

**主用**：平台 recurring automation「求真辨伪辩论·定时循环」（默认每 1h），到点注入薄引导，
新会话 agent 读 yaml 取完整指令后执行一轮。改流程只改 yaml 的 `execution_prompt`，无需同步平台；
改 `rrule`/`status`/`cwd` 才同步平台（详见 AUTOMATION.md 第 2.3 节决策表）。

**命令行兜底（平台不支持时）**：`bash .agents/run-debate.sh`（跑一轮）或加 `--loop` 定时循环。
它用 `codebuddy -p` 无头读 `automations.yaml` 的 `execution_prompt` 执行，与平台同源不另存副本；
详见 AUTOMATION.md 第 4.5 节。三套触发链（平台 / run-debate.sh / loop-debate.sh）只启用其一。

**旧方案（备用，勿与主用同时启用）**：本地会话用 `.agents/loop-debate.sh`
（默认每 **1h** 唤醒，环境变量 `LOOP_DEBATE_INTERVAL` 秒，默认 `3600`；heredoc 同为薄引导）：

```bash
chmod +x .agents/loop-debate.sh .agents/debate-git-publish.sh
.agents/loop-debate.sh
# 自定义间隔例：LOOP_DEBATE_INTERVAL=7200 .agents/loop-debate.sh
```

在 Cursor 中用 **Monitored shell** 后台运行该脚本，`notify_on_output` 匹配 `^AGENT_LOOP_TICK_truth-discovery-debate`。启用后**立即手动跑一轮**。停止：`pkill -f '.agents/loop-debate.sh'`。

**Git 闭环**：工作流末步 `debate_git_publish` 在 `optimizer_finalize` 之后执行 `.agents/debate-git-publish.sh`（提交并 `git push origin` 当前分支；无变更则跳过）。辩论会话内须用 Shell 实际运行该脚本，不得只写「已推送」。

## 10. 重要规则

- 每个步骤必须真正化身所分配的角色——禁止通用回复
- 禁止跳过或合并步骤；严格按拓扑层级执行（同层可并行，不得打乱层间顺序）
- 如果角色文件缺失，告知用户安装 .agents/roles
- 如果条件不满足，将该步骤标记为"已跳过"并继续
- 对于 `depends_on_mode: "any_completed"`，当任意一个上游步骤完成时即可继续（而非等待全部）
- **每次辩论结束后，必须记录到 `docs/inquiry-log.md`**
- **每次 `SKILL.md`、`references/` 或核心案例更新后，检查是否需要同步更新角色文件**
