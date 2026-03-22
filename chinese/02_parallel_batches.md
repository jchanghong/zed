# 并行批次划分

说明：

- 每个批次的文件集合完全不重叠，可以并行开工。
- 每个批次只改静态 UI 字符串，不改逻辑。
- 每个批次内部文件顺序已经排好，按顺序处理即可。

## B01 Zed 主框架与全局入口
文件数：9

工作内容：

- 顶层 Prompt 文案
- 主菜单文案
- 快捷操作栏静态标签、Tooltip、按钮文案
- 启动失败、迁移提示、打开 URL 模态框等界面文案

文件：

- `crates/zed/src/main.rs`
- `crates/zed/src/reliability.rs`
- `crates/zed/src/zed.rs`
- `crates/zed/src/zed/app_menus.rs`
- `crates/zed/src/zed/migrate.rs`
- `crates/zed/src/zed/open_url_modal.rs`
- `crates/zed/src/zed/quick_action_bar.rs`
- `crates/zed/src/zed/quick_action_bar/repl_menu.rs`
- `crates/zed/src/zed/telemetry_log.rs`

注意：

- `app_menus.rs` 只改显示标题，不改绑定的 action。
- `quick_action_bar.rs` 和 `repl_menu.rs` 只改静态按钮/菜单/tooltip 文案，不碰动态状态字符串。

## B02 窗口壳层与工作区
文件数：12

工作内容：

- 标题栏、应用菜单、状态按钮文案
- 工作区 Prompt、标签页菜单、受限模式模态框、欢迎页、错误通知

文件：

- `crates/title_bar/src/application_menu.rs`
- `crates/title_bar/src/collab.rs`
- `crates/title_bar/src/onboarding_banner.rs`
- `crates/title_bar/src/title_bar.rs`
- `crates/workspace/src/history_manager.rs`
- `crates/workspace/src/invalid_item_view.rs`
- `crates/workspace/src/notifications.rs`
- `crates/workspace/src/pane.rs`
- `crates/workspace/src/security_modal.rs`
- `crates/workspace/src/theme_preview.rs`
- `crates/workspace/src/welcome.rs`
- `crates/workspace/src/workspace.rs`

注意：

- `theme_preview.rs` 里的示例文本属于界面预览文本，本轮允许翻译。
- `notifications.rs` 中若按钮标题来自运行时数据，只改源码里直接写死的字面量。

## B03 导航、搜索与项目入口
文件数：10

工作内容：

- 文件查找器、打开路径、搜索栏、项目面板、大纲面板、侧边栏按钮与提示
- 主题选择器固定按钮文案

文件：

- `crates/file_finder/src/file_finder.rs`
- `crates/open_path_prompt/src/open_path_prompt.rs`
- `crates/outline_panel/src/outline_panel.rs`
- `crates/project_panel/src/project_panel.rs`
- `crates/search/src/buffer_search.rs`
- `crates/search/src/project_search.rs`
- `crates/search/src/search_bar.rs`
- `crates/sidebar/src/sidebar.rs`
- `crates/theme_selector/src/icon_theme_selector.rs`
- `crates/theme_selector/src/theme_selector.rs`

注意：

- `open_path_prompt.rs` 只改 Prompt 和固定提示，不改路径示例。
- `file_finder.rs` 只改静态菜单项、按钮、空态文案。

## B04 设置界面与入门流程
文件数：13

工作内容：

- 设置页标题、描述、搜索占位、操作按钮
- Onboarding、AI onboarding、Python onboarding 的固定说明文案

文件：

- `crates/settings_ui/src/components/input_field.rs`
- `crates/settings_ui/src/page_data.rs`
- `crates/settings_ui/src/pages/audio_test_window.rs`
- `crates/settings_ui/src/pages/edit_prediction_provider_setup.rs`
- `crates/settings_ui/src/pages/tool_permissions_setup.rs`
- `crates/settings_ui/src/settings_ui.rs`
- `crates/onboarding/src/basics_page.rs`
- `crates/onboarding/src/multibuffer_hint.rs`
- `crates/onboarding/src/onboarding.rs`
- `crates/ai_onboarding/src/agent_api_keys_onboarding.rs`
- `crates/ai_onboarding/src/ai_onboarding.rs`
- `crates/ai_onboarding/src/ai_upsell_card.rs`
- `crates/language_onboarding/src/python.rs`

注意：

- `page_data.rs` 只改面向用户显示的标题/描述/标签。
- 不要动设置 key、JSON 路径、代码示例、产品名。

## B05 最近项目、远程、终端与 REPL
文件数：15

工作内容：

- 最近项目、远程连接、Dev Container、终端面板、REPL 界面静态文本

文件：

- `crates/dev_container/src/lib.rs`
- `crates/recent_projects/src/disconnected_overlay.rs`
- `crates/recent_projects/src/recent_projects.rs`
- `crates/recent_projects/src/remote_connections.rs`
- `crates/recent_projects/src/remote_servers.rs`
- `crates/recent_projects/src/sidebar_recent_projects.rs`
- `crates/remote_connection/src/remote_connection.rs`
- `crates/repl/src/components/kernel_options.rs`
- `crates/repl/src/kernels/remote_kernels.rs`
- `crates/repl/src/notebook/notebook_ui.rs`
- `crates/repl/src/outputs.rs`
- `crates/repl/src/outputs/json.rs`
- `crates/repl/src/repl_sessions_ui.rs`
- `crates/repl/src/session.rs`
- `crates/terminal_view/src/terminal_panel.rs`

注意：

- 保留 WSL、Dev Container、REPL、Kernel、JSON 等术语。
- 保留命令、地址、路径、`ssh user@example` 之类输入示例格式。

## B06 协作、通知、Copilot 与诊断
文件数：12

工作内容：

- ACP 工具视图、协作面板、来电/共享通知、Copilot 登录、诊断面板、状态提示

文件：

- `crates/acp_tools/src/acp_tools.rs`
- `crates/collab_ui/src/call_stats_modal.rs`
- `crates/collab_ui/src/collab_panel.rs`
- `crates/collab_ui/src/collab_panel/channel_modal.rs`
- `crates/collab_ui/src/collab_panel/contact_finder.rs`
- `crates/collab_ui/src/notification_panel.rs`
- `crates/collab_ui/src/notifications/incoming_call_notification.rs`
- `crates/collab_ui/src/notifications/project_shared_notification.rs`
- `crates/copilot_ui/src/sign_in.rs`
- `crates/diagnostics/src/buffer_diagnostics.rs`
- `crates/diagnostics/src/diagnostics.rs`
- `crates/notifications/src/status_toast.rs`

注意：

- GitHub Copilot 名称保留英文。
- `acp_tools.rs` 只改工具栏与空状态等可见静态文案。

## B07 Git 与调试器
文件数：19

工作内容：

- Git 图、Git 面板、提交/分支/工作树/冲突界面
- 调试器主面板、启动模态框、控制台、内存视图、堆栈帧、日志视图

文件：

- `crates/debugger_tools/src/dap_log.rs`
- `crates/debugger_ui/src/debugger_panel.rs`
- `crates/debugger_ui/src/new_process_modal.rs`
- `crates/debugger_ui/src/session/running/console.rs`
- `crates/debugger_ui/src/session/running/memory_view.rs`
- `crates/debugger_ui/src/session/running/stack_frame_list.rs`
- `crates/git_graph/src/git_graph.rs`
- `crates/git_ui/src/askpass_modal.rs`
- `crates/git_ui/src/branch_picker.rs`
- `crates/git_ui/src/clone.rs`
- `crates/git_ui/src/commit_modal.rs`
- `crates/git_ui/src/commit_view.rs`
- `crates/git_ui/src/conflict_view.rs`
- `crates/git_ui/src/file_history_view.rs`
- `crates/git_ui/src/git_panel.rs`
- `crates/git_ui/src/git_ui.rs`
- `crates/git_ui/src/project_diff.rs`
- `crates/git_ui/src/stash_picker.rs`
- `crates/git_ui/src/worktree_picker.rs`

注意：

- `debug.json`、Git 命令片段、branch/worktree 等技术词保留。
- `dap_log.rs` 只改标题、菜单项、按钮文案，不改日志内容结构。

## B08 Agent UI 配置层
文件数：15

工作内容：

- Agent 配置、Provider/MCP 配置、Profile 配置、模式选择、侧向通知与 onboarding

文件：

- `crates/agent_ui/src/agent_configuration.rs`
- `crates/agent_ui/src/agent_configuration/add_llm_provider_modal.rs`
- `crates/agent_ui/src/agent_configuration/configure_context_server_modal.rs`
- `crates/agent_ui/src/agent_configuration/manage_profiles_modal.rs`
- `crates/agent_ui/src/agent_registry_ui.rs`
- `crates/agent_ui/src/config_options.rs`
- `crates/agent_ui/src/mode_selector.rs`
- `crates/agent_ui/src/profile_selector.rs`
- `crates/agent_ui/src/slash_command_picker.rs`
- `crates/agent_ui/src/ui/acp_onboarding_modal.rs`
- `crates/agent_ui/src/ui/agent_notification.rs`
- `crates/agent_ui/src/ui/claude_agent_onboarding_modal.rs`
- `crates/agent_ui/src/ui/end_trial_upsell.rs`
- `crates/agent_ui/src/ui/hold_for_default.rs`
- `crates/agent_ui/src/ui/model_selector_components.rs`

注意：

- MCP、ACP、Agent、Profile 等术语前后一致。
- `ConfigOptions` 只改按钮和标签字面量，不改配置 id。

## B09 Agent UI 会话层
文件数：9

工作内容：

- Agent 主面板、会话视图、线程视图、Prompt 编辑器、历史与归档

文件：

- `crates/agent_ui/src/agent_diff.rs`
- `crates/agent_ui/src/agent_panel.rs`
- `crates/agent_ui/src/conversation_view.rs`
- `crates/agent_ui/src/conversation_view/thread_view.rs`
- `crates/agent_ui/src/inline_prompt_editor.rs`
- `crates/agent_ui/src/text_thread_editor.rs`
- `crates/agent_ui/src/text_thread_history.rs`
- `crates/agent_ui/src/thread_history_view.rs`
- `crates/agent_ui/src/threads_archive_view.rs`

注意：

- 只改静态文案。
- `conversation_view/thread_view.rs` 中动态拼接标题、运行态状态文本、错误透传文本不要改。
- 代码块、命令块、文件名、模型名、路径名不要翻译。

## B10 模型 Provider 界面
文件数：14

工作内容：

- 各 LLM Provider 设置面板的静态 UI 文案、标签、按钮、帮助文案

文件：

- `crates/language_models/src/provider/anthropic.rs`
- `crates/language_models/src/provider/bedrock.rs`
- `crates/language_models/src/provider/cloud.rs`
- `crates/language_models/src/provider/deepseek.rs`
- `crates/language_models/src/provider/google.rs`
- `crates/language_models/src/provider/lmstudio.rs`
- `crates/language_models/src/provider/mistral.rs`
- `crates/language_models/src/provider/ollama.rs`
- `crates/language_models/src/provider/open_ai.rs`
- `crates/language_models/src/provider/open_ai_compatible.rs`
- `crates/language_models/src/provider/open_router.rs`
- `crates/language_models/src/provider/vercel.rs`
- `crates/language_models/src/provider/vercel_ai_gateway.rs`
- `crates/language_models/src/provider/x_ai.rs`

注意：

- Provider 品牌名、API URL、API Key、模型 id、示例命令保持英文。
- 只翻译周围 UI 文案和说明句。

## B11 语言工具、键位编辑器与通用控件
文件数：8

工作内容：

- 键位编辑器
- LSP/语法树/高亮等工具视图
- 通用复制按钮、通用 Alert 模态框

文件：

- `crates/keymap_editor/src/keymap_editor.rs`
- `crates/keymap_editor/src/ui_components/keystroke_input.rs`
- `crates/language_tools/src/highlights_tree_view.rs`
- `crates/language_tools/src/key_context_view.rs`
- `crates/language_tools/src/lsp_log_view.rs`
- `crates/language_tools/src/syntax_tree_view.rs`
- `crates/ui/src/components/button/copy_button.rs`
- `crates/ui/src/components/notification/alert_modal.rs`

注意：

- `copy_button.rs` 和 `alert_modal.rs` 是共享组件，改完会影响全局，先统一术语再提交。
- `lsp_log_view.rs` 只改面板标题、按钮与说明，不改日志内容。

