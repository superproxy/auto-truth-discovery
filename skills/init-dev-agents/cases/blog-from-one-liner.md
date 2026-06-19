# 案例：从一句话需求 bootstrap Astro 博客工程

> 这是 init-dev-agents skill 的第二个真实运行：在临时空目录 `/var/folders/.../opencode/blog-test/` 上跑端到端验证。

## 0. 输入

用户原话（一行）：

> "想做个个人博客，markdown 写文章，支持标签和归档。参考 Astro 和 Hugo。测试要覆盖：空文章列表、超长标题截断、标签筛选。用 Astro。"

仓库状态：完全空目录。

## 1. Step 1 仓库探测

`ls -la` 结果：空。判定为 **空仓库** 分支 → 直接走 Step 2 按用户输入 bootstrap，跳过调研。

## 2. Step 2 三分类

完全无歧义，未触发 `question` 工具：

| 分类 | 内容 |
|---|---|
| 需求 | markdown 写文章 / 支持标签 / 支持归档 / Astro 技术栈 |
| 参考 | Astro、Hugo |
| 测试场景 | 空文章列表 / 超长标题截断 / 标签筛选 |

**红线检查**：上述内容**未**复述进 AGENTS.md。✓

## 3. Step 3 工程类型

主语含 "Astro 技术栈" → 软件工程 → 用 `src/` + `tests/` + `package.json` 脚手架。

## 4. Step 4 落盘

| 文件 | 行数 | 角色 |
|---|---|---|
| `AGENTS.md` | 39 | 入口地图（命令 + 约定 + 分流） |
| `README.md` | 16 | 一句话定位 + quick start |
| `package.json` | 19 | manifest（astro + vitest） |
| `.gitignore` | 7 | node_modules/dist/.astro |
| `docs/requirements.md` | 23 | P0/P1/P2 + 非目标 |
| `docs/references.md` | 11 | Astro / Hugo + Astro 关键文档章节 |
| `tests/scenarios/empty-post-list.md` | 21 | Given-When-Then |
| `tests/scenarios/long-title-truncation.md` | 24 | + 反例段 |
| `tests/scenarios/tag-filtering.md` | 28 | + 边界情况段 |

合计 9 个文件，5 项最小产出契约齐全。

## 5. AGENTS.md 体积与高信号验证

39 行 < 50 行阈值。逐段过"agent 不知道会踩坑吗"：

| 段落 | 必要性 |
|---|---|
| `src/content/posts/` 路径 | ✓ Astro Content Collections 默认路径，agent 不知道会乱放 |
| `astro check` = typecheck | ✓ 跨 Astro 项目通用，但非 Astro 出身的 agent 会去装 tsc |
| frontmatter 三必填字段 | ✓ Content Collections schema 校验机制，不写必踩坑 |
| `dist/` 禁止手改 | ✓ 防 agent 误改构建产物 |
| 三分流指引 | ✓ 强制后续工作引向正确文件 |
| 关键命令表 | ✓ 直接从 package.json 推出，但比让 agent 自己读快 |

无段落填不出真实内容。

## 6. 红线复检

跑 `grep -E '标签|归档|Hugo'` 在 AGENTS.md 中：

- 初版命中 1 处："个人博客，Astro + markdown，**支持标签与归档**" → 复述需求，违规 → 已修为"基于 Astro 的个人博客静态站点"
- 终版剩 1 处："实现**标签筛选页** `/tags/[tag]`" → 出现在"当前优先级"段，是**工作进展**而非需求复述 → 合规

## 7. 自检结果

- [x] 三分类完整无混塞
- [x] 工程类型正确（软件工程）
- [x] AGENTS.md 每行通过踩坑测试
- [x] 命令均从 package.json 实际找出
- [x] 39 行 < 50 行
- [x] 5 项最小产出齐全
- [x] 红线被 grep 抓出并修复

## 8. 经验沉淀（与首个案例对比）

新发现：

1. **"主语含技术栈"是软件工程的强信号**：用户提了 "Astro" 就锁定软件工程子型，避免误判为文档工程
2. **AGENTS.md 第一行很危险**：人写定位句容易顺手把需求点带进去（"支持 X 和 Y"），需要在自检里专门 grep
3. **测试场景文件应分文件**：每场景一个 .md，方便后续 PR 单独引用，比塞进一个 `test-scenarios.md` 好（本案例已遵循）
4. **优先级段写"在做什么"是合规的**：跟"复述需求"不同，是工作进展提示

复用首案例经验：

5. ✓ 多轮 question 已等同 dry-run 时可省二次预览（本次跳过预览，OK）
6. ✓ 历史素材目录要标"不要改"（本次无该需求）

待累积更多案例后回灌进 SKILL.md 的潜在改进：

- **AGENTS.md 第一行红线 grep**：在 Step 7 自检里加一条"AGENTS.md 不应出现需求关键词"的可执行检查
- **测试场景模板**：Given-When-Then + 反例段 + 验收清单 这套结构很好用，可作为 skill 推荐模板

## 9. OpenCode 加载机制踩坑（重要副产物）

跑这次端到端时发现：`skill init-dev-agents` 工具加载到的是**会话开始时**的 SKILL.md 快照，会话中跑 sync.sh 不会让本会话的 `skill` 工具看到新版。

→ 已写入本仓库 `AGENTS.md` "约定与陷阱"段。

→ 未来要验证 skill 改动，必须**新开会话**。
