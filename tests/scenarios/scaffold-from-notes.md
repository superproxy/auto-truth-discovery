# 场景：从散乱笔记生成工程骨架

## 输入

用户在一个空目录里说：

> "做一个待办应用。要支持标签和优先级。参考 Things 3 和 todoist。测试要覆盖：空列表、超长标题、删除已完成项三种场景。用 React + Vite。"

## 期望产出

### 三分类（Step 2）

| 分类 | 内容 |
|---|---|
| 需求 | 待办、标签、优先级、React + Vite 技术栈 |
| 参考 | Things 3、Todoist |
| 测试场景 | 空列表、超长标题、删除已完成项 |

### 工程类型（Step 3）

软件工程（提到了 React + Vite 技术栈）

### 落盘文件（Step 4 dry-run 后）

```
todo-app/
├── AGENTS.md                          # 写命令+约定+目录指引，不写"要支持标签"
├── README.md                          # 一句话定位
├── src/                               # 空目录待开发
├── tests/scenarios/
│   ├── empty-list.md                  # Given-When-Then
│   ├── long-title.md
│   └── delete-completed.md
├── docs/
│   ├── requirements.md                # 待办/标签/优先级 + 技术栈，P0/P1 标注
│   └── references.md                  # Things 3 / Todoist 各一句话用途
├── package.json                       # vite + react
└── .gitignore
```

## 验收点

- [ ] AGENTS.md 不出现"标签"、"优先级"、"Things 3" 等需求/参考词
- [ ] 三分流文档齐全且无内容串通
- [ ] tests/scenarios/ 下三个文件，每个一场景
- [ ] AGENTS.md 关键命令表里 `npm run dev` / `npm test` 等命令是从 package.json 实际推出来的，不是猜的
- [ ] AGENTS.md 长度 < 50 行
- [ ] 落盘前先给了用户方案预览

## 反例（必须拒绝）

- AGENTS.md 里写"## 需求 - 支持标签和优先级" → 红线，违反 Phase 0
- 跳过 dry-run 直接 write 一堆文件 → 违反 Step 4
- `docs/references.md` 里抄 Things 3 的功能介绍 → 违反"仅列名+一句话"
