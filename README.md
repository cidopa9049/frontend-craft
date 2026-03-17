# frontend-craft

面向企业级前端团队的 Claude Code 共享插件，集成代码审查、安全审查、设计稿还原（Figma/Sketch/MasterGo/Pixso/墨刀/摹客）、无障碍检查、自动化质量保障和项目规范模板。

## 安装

> 要求 Claude Code **v1.0.33+**（运行 `claude --version` 查看版本）。

### 方式一：通过 Marketplace 安装（推荐）

在 Claude Code 会话中执行以下命令，先添加 Marketplace，再安装插件：

```
/plugin marketplace add bovinphang/frontend-craft
/plugin install frontend-craft@bovinphang-frontend-craft
```

安装后执行 `/reload-plugins` 激活插件。

### 方式二：团队项目级自动安装（推荐团队使用）

在项目根目录的 `.claude/settings.json` 中添加 Marketplace 配置，团队成员 trust 项目目录后自动提示安装：

```json
{
  "extraKnownMarketplaces": {
    "frontend-craft": {
      "source": {
        "source": "github",
        "repo": "bovinphang/frontend-craft"
      }
    }
  }
}
```

### 方式三：本地开发 / 测试

克隆仓库后使用 `--plugin-dir` 加载（不需要安装，适合开发调试）：

```bash
git clone https://github.com/bovinphang/frontend-craft.git
claude --plugin-dir ./frontend-craft
```

### 方式四：作为 Git Submodule（项目级共享）

```bash
# 在项目根目录下添加为 submodule
git submodule add https://github.com/bovinphang/frontend-craft.git .claude/plugins/frontend-craft

git add .gitmodules .claude/plugins/frontend-craft
git commit -m "feat: add frontend-craft as shared Claude Code plugin"
```

团队成员克隆项目后执行：

```bash
git submodule update --init --recursive
```

然后使用 `--plugin-dir` 加载：

```bash
claude --plugin-dir .claude/plugins/frontend-craft
```

## 快速开始：初始化项目配置

安装插件后，在 Claude Code 中运行 `/frontend-craft:init` 命令，将项目模板初始化到当前项目的 `.claude/` 目录：

```
> /frontend-craft:init
```

初始化后请根据项目实际情况修改：

1. `.claude/CLAUDE.md` — 修改项目基础信息、包管理器、常用命令
2. `.claude/rules/` — 删除不适用的规则文件（如纯 React 项目删除 `vue.md`，不需要 i18n 的项目删除 `i18n.md`）
3. `.claude/settings.json` — 调整权限白名单

> **为什么需要这一步？** 插件提供的是可复用的 Skills、Agents 和 Hooks，而 CLAUDE.md 和 rules 是项目级配置，必须位于项目根目录的 `.claude/` 下才能被 Claude Code 识别。`/init` 命令帮你快速完成这个配置。

## 功能概览

### Commands（斜杠命令）

| 命令 | 用途 |
|------|------|
| `/frontend-craft:init` | 将项目模板初始化到当前项目的 `.claude/` 目录 |
| `/frontend-craft:review` | 对指定文件或最近变更的代码执行规范化评审，输出分级报告 |
| `/frontend-craft:scaffold` | 按项目规范创建 page / feature / component 标准目录结构和样板文件 |

### Skills（自动激活）

| Skill | 用途 |
|-------|------|
| `frontend-code-review` | 从架构、类型、渲染、样式、可访问性等维度审查代码 |
| `security-review` | XSS、CSRF、敏感数据泄露、输入校验等安全审查 |
| `accessibility-check` | WCAG 2.1 AA 无障碍检查 |
| `react-project-standard` | React + TypeScript 项目工程规范（结构、组件、路由、状态、API 层） |
| `vue3-project-standard` | Vue 3 + TypeScript 项目工程规范（结构、组件、路由、Pinia、API 层） |
| `implement-from-design` | 基于 Figma/Sketch/MasterGo/Pixso/墨刀/摹客设计稿实现 UI |
| `test-and-fix` | 执行 lint、type-check、test、build 并修复失败 |
| `legacy-web-standard` | JS + jQuery + HTML 传统项目的开发与维护规范 |

### Agents（子代理）

| Agent | 用途 |
|-------|------|
| `frontend-architect` | 页面拆分、组件架构、状态流设计、目录规划、大型重构 |
| `performance-optimizer` | 分析性能瓶颈（打包体积、渲染性能、网络请求），输出量化优化方案 |
| `ui-checker` | UI 视觉问题排查、设计还原度评估 |
| `figma-implementer` | 按 Figma/Sketch/MasterGo/Pixso/墨刀/摹客设计稿精确实现 UI |
| `design-token-mapper` | 将设计变量映射到项目 Design Token |

### Hooks（自动执行）

| 事件 | 行为 |
|------|------|
| `SessionStart` | 自动检测项目框架和包管理器 |
| `PreToolUse(Bash)` | 拦截危险命令（rm -rf、force push 等） |
| `PostToolUse(Write/Edit)` | 对修改的文件自动执行 Prettier |
| `Stop` | 会话结束时执行 lint、type-check、test、build |
| `Notification` | 跨平台桌面通知（macOS / Linux / Windows） |

### MCP 集成

| 服务 | 用途 |
|------|------|
| Figma | 读取设计上下文、变量定义 |
| Figma Desktop | Figma 桌面端集成 |
| Sketch | 读取设计选区截图 |
| MasterGo | 读取 DSL 结构数据、组件层级和样式 |
| Pixso | 本地 MCP 获取帧数据、代码片段和图片资源 |
| 墨刀 | 获取原型数据、生成设计描述、导入 HTML |
| 摹客 | 无 MCP 集成，通过用户提供的截图/标注/导出 CSS 支持 |

### 项目模板（通过 `/init` 初始化）

| 文件 | 用途 |
|------|------|
| `CLAUDE.md` | 项目说明、常用命令、工作原则、安全要求 |
| `settings.json` | 权限白名单/黑名单、环境变量 |
| `rules/vue.md` | Vue 3 组件规范和反模式 |
| `rules/react.md` | React 组件规范和反模式 |
| `rules/design-system.md` | 设计系统、Token、可访问性规则 |
| `rules/testing.md` | 测试与校验规则 |
| `rules/git-conventions.md` | Conventional Commits 提交规范 |
| `rules/i18n.md` | 国际化文案规范 |
| `rules/performance.md` | 前端性能优化规则 |
| `rules/api-layer.md` | API 层类型化、错误处理规范 |
| `rules/state-management.md` | 状态分类、管理策略、反模式 |
| `rules/error-handling.md` | 错误分层、Error Boundary、降级 UI、上报规范 |
| `rules/naming-conventions.md` | 文件、组件、变量、路由、API、CSS 统一命名规范 |

## 配置

### MCP 服务器

使用设计稿相关功能前，根据团队使用的设计工具设置对应环境变量：

| 环境变量 | 对应工具 | 获取方式 |
|----------|----------|----------|
| `FIGMA_API_KEY` | Figma / Figma Desktop | Figma 账户设置 > Personal Access Tokens |
| `SKETCH_API_KEY` | Sketch | Sketch 开发者设置 |
| `MG_MCP_TOKEN` | MasterGo | MasterGo 账户设置 > 安全设置 > 生成 Token |
| `MODAO_TOKEN` | 墨刀 | 墨刀 AI 功能页面获取访问令牌 |

> Pixso 使用本地 MCP 服务，需在 Pixso 客户端中启用 MCP 功能，无需额外环境变量。
> 摹客暂无 MCP 集成，通过用户提供截图/标注方式工作。

**macOS / Linux:**

```bash
export FIGMA_API_KEY="your-figma-api-key"
export SKETCH_API_KEY="your-sketch-api-key"
export MG_MCP_TOKEN="your-mastergo-token"
export MODAO_TOKEN="your-modao-token"
```

**Windows (PowerShell):**

```powershell
$env:FIGMA_API_KEY = "your-figma-api-key"
$env:SKETCH_API_KEY = "your-sketch-api-key"
$env:MG_MCP_TOKEN = "your-mastergo-token"
$env:MODAO_TOKEN = "your-modao-token"
```

建议将环境变量添加到 shell 配置文件（`~/.bashrc`、`~/.zshrc`）或 Windows 系统环境变量中。

### 前置依赖

- Node.js >= 18
- npm、pnpm 或 yarn
- Git Bash（Windows 用户需要，用于执行 hook 脚本）

## 目录结构

```
frontend-craft/
├── .claude-plugin/
│   ├── plugin.json            # 插件清单
│   └── marketplace.json       # Marketplace 发布配置
├── commands/                   # 斜杠命令
│   ├── init.md
│   ├── review.md
│   └── scaffold.md
├── agents/                     # 子代理定义
│   ├── frontend-architect.md
│   ├── performance-optimizer.md
│   ├── ui-checker.md
│   ├── figma-implementer.md
│   └── design-token-mapper.md
├── skills/                     # 自动激活的技能
│   ├── frontend-code-review/
│   ├── security-review/
│   ├── accessibility-check/
│   ├── react-project-standard/
│   ├── vue3-project-standard/
│   ├── implement-from-design/
│   ├── test-and-fix/
│   └── legacy-web-standard/
├── hooks/
│   └── hooks.json              # 事件钩子配置
├── scripts/                    # 辅助脚本
│   ├── security-check.sh
│   ├── format-changed-file.sh
│   ├── run-tests.sh
│   ├── session-start.sh
│   └── notify.sh
├── templates/                  # 项目级配置模板
│   ├── CLAUDE.md
│   ├── settings.json
│   └── rules/
│       ├── vue.md
│       ├── react.md
│       ├── design-system.md
│       ├── testing.md
│       ├── git-conventions.md
│       ├── i18n.md
│       ├── performance.md
│       ├── api-layer.md
│       ├── state-management.md
│       ├── error-handling.md
│       └── naming-conventions.md
├── .mcp.json                   # MCP 服务器配置
└── README.md
```

## 更新

通过 Marketplace 安装的插件，在 Claude Code 中执行：

```
/plugin marketplace update bovinphang-frontend-craft
```

或开启自动更新，每次启动 Claude Code 时自动拉取最新版本：

1. 在 Claude Code 中执行 `/plugin` 打开插件管理器
2. 切换到 **Marketplaces** 标签页
3. 选中 `bovinphang-frontend-craft`
4. 选择 **Enable auto-update**

> 第三方 Marketplace 默认不开启自动更新，需手动启用。启用后 Claude Code 每次启动时会自动刷新 Marketplace 数据并更新已安装的插件。

如果使用 Git submodule 方式安装：

```bash
git submodule update --remote .claude/plugins/frontend-craft
```

## 许可证

MIT
