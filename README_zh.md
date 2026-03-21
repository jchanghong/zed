# Zed

[![Zed](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/zed-industries/zed/main/assets/badge/v0.json)](https://zed.dev)
[![CI](https://github.com/zed-industries/zed/actions/workflows/run_tests.yml/badge.svg)](https://github.com/zed-industries/zed/actions/workflows/run_tests.yml)

欢迎使用 Zed，这是一款来自 [Atom](https://github.com/atom/atom) 和 [Tree-sitter](https://github.com/tree-sitter/tree-sitter) 创建者的高性能多人代码编辑器。

---

### 安装

在 macOS、Linux 和 Windows 上，您可以 [直接下载 Zed](https://zed.dev/download) 或通过本地包管理器安装 Zed（[macOS](https://zed.dev/docs/installation#macos)/[Linux](https://zed.dev/docs/linux#installing-via-a-package-manager)/[Windows](https://zed.dev/docs/windows#package-managers)）。

其他平台暂不可用：

- Web ([跟踪问题](https://github.com/zed-industries/zed/issues/5396))

### 开发 Zed

- [为 macOS 构建 Zed](./docs/src/development/macos.md)
- [为 Linux 构建 Zed](./docs/src/development/linux.md)
- [为 Windows 构建 Zed](./docs/src/development/windows.md)

### 贡献

有关如何为 Zed 做出贡献的方式，请参阅 [CONTRIBUTING.md](./CONTRIBUTING.md)。

另外...我们正在招聘！查看我们的 [职位](https://zed.dev/jobs) 页面了解空缺职位。

### 许可

第三方依赖的许可信息必须正确提供才能使 CI 通过。

我们使用 [`cargo-about`](https://github.com/EmbarkStudios/cargo-about) 自动遵守开源许可证。如果 CI 失败，请检查以下内容：

- 它是否显示您创建的 crate 有 `no license specified` 错误？如果是，请在您的 crate 的 Cargo.toml 中的 `[package]` 下添加 `publish = false`。
- 是否是依赖项的 `failed to satisfy license requirements` 错误？如果是，首先确定项目具有什么许可证，以及该系统是否足以满足该许可证的要求。如果不确定，请咨询律师。一旦您确认该系统可接受，请将许可证的 SPDX 标识符添加到 `script/licenses/zed-licenses.toml` 中的 `accepted` 数组中。
- `cargo-about` 是否无法找到依赖项的许可证？如果是，请在 `script/licenses/zed-licenses.toml` 的末尾添加一个澄清字段，如 [cargo-about 手册](https://embarkstudios.github.io/cargo-about/cli/generate/config.html#crate-configuration) 中指定的那样。

## 赞助

Zed 由 **Zed Industries, Inc.** 开发，这是一家盈利性公司。

如果您想从财务上支持该项目，您可以通过 GitHub Sponsors 进行。赞助直接流向 Zed Industries，并用作公司一般收入。赞助没有任何额外福利或权利。