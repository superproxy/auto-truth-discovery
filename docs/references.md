# 参考资料

## skill 写作规范

- `~/.config/opencode/skills/skill-creator/SKILL.md` — 官方 skill 创作指南
- `~/.config/opencode/skills/writing-skills/SKILL.md` — skill 验证流程
- `~/.config/opencode/skills/customize-opencode` — OpenCode 自身配置约束

## 同类 skill 参考

- `~/.config/opencode/skills/openspec-propose/` — 提案生成的工作流模式
- `~/.config/opencode/skills/writing-plans/` — 计划文档的产出标准
- `~/.config/opencode/skills/brainstorming/` — 需求澄清前置

## 本仓库历史素材

- `.trae/skills/truth-discovery/` — 方法论 skill 的目录结构范本（SKILL.md + cases + tools）

## OpenCode skill 加载机制

- 全局加载点：`~/.config/opencode/skills/{name}/SKILL.md`
- 触发依据：frontmatter 的 `description` 字段语义匹配
- 加载时机：会话开始扫描，运行时通过 `skill` 工具显式调用
