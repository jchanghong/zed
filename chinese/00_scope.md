# 简体中文本地化执行边界

## 目标
本轮只做一件事：

- 只修改程序运行时 UI 源码中的硬编码静态英文字符串。

## 允许修改
只允许修改以下场景中的字符串字面量：

- `Label::new("...")`
- `Button::new(_, "...")`
- `Tooltip::text("...")`
- `Tooltip::simple("...")`
- `ContextMenuEntry::new("...")`
- `set_placeholder_text("...")`
- `window.prompt(..., "...", ..., &["...", "..."], ...)`
- `.label("...")`
- `.title("...")`
- `.subtitle("...")`
- `.description("...")`
- `.empty_message("...")`
- `MenuItem::action("...")`
- `MenuItem::os_action("...")`

## 严禁修改
以下内容全部禁止改动：

- 任何代码逻辑
- 任何函数签名、结构体字段、枚举值、match 分支、调用关系
- 动态字符串
说明：
包括 `format!`、`anyhow!`、`bail!`、`.context("...")`、运行时拼接文案、后端错误透传文案
- 协议字段、serde 字段、JSON key、action id、command id、event name
- URL、路径、环境变量名、shell 命令、代码片段本体
- 文档文件
说明：
包括 `*.md`、README、docs、注释说明文本、模板说明文档
- 测试代码
说明：
包括 `tests`、`test`、fixture、eval、example、storybook、stories、bench
- 安装器语言文件、设置模板注释、非运行时文档资源

## 翻译风格
- Zed、GitHub、GitHub Copilot、OpenAI、Anthropic、Ollama、LM Studio、WSL、MCP、REPL、JSON、debug.json 等专有名词保留英文。
- 菜单、按钮、Tooltip 统一用简洁中文，不解释功能实现。
- “Cancel / Close / Dismiss / Remove / Delete / Restore / Retry / Configure / Learn More” 等高频动作在同一批次内保持一致译法。
- 保留现有省略号风格。
说明：
源码中如果原本是 `…` 就继续保留 `…`，如果原本是 `...` 就不要顺手改成别的。
- 不要改命令示例和代码示例本体。
说明：
如 `ollama run ...`、`debug.json`、`settings.json`、快捷键文本、路径示例。

## 并行原则
- 以“文件”为最小并行单元。
- 每个批次的文件集合必须完全不重叠。
- 合并时只接受“字符串字面量替换”类型的 diff。

## 交付标准
单个文件完成后必须满足：

- diff 中没有逻辑变更
- diff 中没有测试改动
- diff 中没有注释/文档改动
- 只替换 UI 可见静态字符串

