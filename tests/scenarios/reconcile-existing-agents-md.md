# 场景：reconcile 已有 AGENTS.md

## 输入

仓库已有：
- `AGENTS.md`（其中含过期命令 `npm run build:legacy`，以及通用建议"记得写测试"）
- `package.json` 里实际命令是 `pnpm build`
- 用户说 "刷新一下 AGENTS.md"

## 期望产出

### Step 1 探测

识别为"已有工程"分支 → 走 reconcile（Step 6），不是重铺骨架

### Reconcile 操作

- **删除**：`npm run build:legacy`（与 package.json 不符）
- **删除**：通用建议 "记得写测试"
- **改写**：把 build 命令改成 `pnpm build`
- **保留**：所有可被当前代码验证的事实

### 工具

用 `edit` 工具逐段改，**禁止** `write` 整文件覆盖

## 验收点

- [ ] AGENTS.md 行数变少（删除了过期+通用内容）
- [ ] 没有出现新的未验证命令
- [ ] git diff 体现是"段落级修改"而非整文件重写
- [ ] 三分流文档（如已有）未被动到

## 反例

- 整文件 `write` 覆盖 → 违反 Step 6
- 直接 append 新章节而不删过期内容 → reconcile 失败
