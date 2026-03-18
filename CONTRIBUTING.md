# 贡献指南

感谢你对 frontend-craft 插件的关注。欢迎通过 Issue 和 Pull Request 参与贡献。

## 开发环境

- Node.js >= 18
- Git

## 分支策略

- `main` — 稳定发布分支
- `develop` — 开发分支（如有）
- `feature/xxx` — 新功能
- `fix/xxx` — Bug 修复
- `docs/xxx` — 文档更新

## 提交规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/)：

```
<type>(<scope>): <description>

[optional body]
[optional footer]
```

**type 示例：**

| type | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | Bug 修复 |
| `docs` | 文档 |
| `refactor` | 重构 |
| `chore` | 构建、配置等 |

**示例：**

```
feat(skills): add e2e-testing skill
fix(hooks): resolve Windows path in run-tests.mjs
docs(readme): update installation steps
```

## 如何添加 Skill

1. 在 `skills/` 下创建目录，如 `skills/my-skill/`
2. 创建 `SKILL.md`，包含 YAML frontmatter 和正文：

```markdown
---
name: my-skill
description: 简短描述，说明何时自动激活。当用户提到 xxx 时自动激活。
version: 1.0.0
---

# 技能标题

## 适用场景
- ...

## 核心规则
- ...
```

3. 在 README 的 Skills 表格中新增一行
4. 在 README 的目录结构中补充对应条目

## 如何添加 Agent

1. 在 `agents/` 下创建 `my-agent.md`
2. 使用 YAML frontmatter 定义：

```markdown
---
name: my-agent
description: 当任务涉及 xxx 时，使用该子代理。
tools: Read, Edit, Write, Glob, Grep, Bash
model: sonnet
skills:
  - relevant-skill
---
```

3. 在 README 的 Agents 表格中新增一行

## 如何添加 Command

1. 在 `commands/` 下创建 `my-command.md`
2. 使用 YAML frontmatter 和 Markdown 描述执行步骤
3. 在 README 的 Commands 表格中新增一行

## 如何添加 Rule 模板

1. 在 `templates/rules/` 下创建 `my-rule.md`
2. 在 `commands/init.md` 的复制清单中新增该文件
3. 在 `templates/CLAUDE.md` 的规则导入示例中补充（如适用）

## 如何添加 Hook

1. 在 `hooks/hooks.json` 中新增配置
2. 如需脚本，在 `scripts/` 下创建 `.mjs` 文件（跨平台优先 Node.js）
3. 在 README 的 Hooks 表格中更新

## Pull Request 流程

1. Fork 本仓库
2. 从 `main` 拉取最新代码，创建 `feature/xxx` 或 `fix/xxx` 分支
3. 完成修改，确保符合提交规范
4. 提交 PR，描述变更内容和动机
5. 等待维护者 Review，根据反馈修改
6. 合并后删除分支

## 代码风格

- Markdown：使用标准 Markdown 语法，表格对齐
- 中文与英文、数字之间加空格（如：`使用 React 18`）
- 技能描述简洁，避免冗长

## 问题反馈

- 使用 [GitHub Issues](https://github.com/bovinphang/frontend-craft/issues) 提交 Bug 或功能建议
- 描述清晰，包含复现步骤或使用场景
