# Onyx Terminal

[![iOS CI](https://github.com/ONX999/ios-ssh-ml-onyx-terminal/actions/workflows/ci.yml/badge.svg)](https://github.com/ONX999/ios-ssh-ml-onyx-terminal/actions/workflows/ci.yml)
[![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2016%2B-lightgrey.svg)](https://www.apple.com/ios/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**Onyx Terminal** 是一個功能完整的 iOS SSH 終端與 SFTP 客戶端，提供專業的遠端伺服器管理體驗。

## 🌟 功能特色

- ✅ **SSH 終端模擬器**: 完整的 VT100 終端支援（基於 SwiftTerm）
- ✅ **SFTP 檔案傳輸**: 上傳、下載、瀏覽遠端檔案系統
- ✅ **多語言支援**: 繁體中文/English（預設繁體中文）
- ✅ **快捷指令列**: 常用指令一鍵執行（llama.cpp、ollama、conda、tmux 等）
- 🔐 **安全連線**: SSH 密碼與金鑰認證（金鑰支援開發中）
- 📱 **原生 SwiftUI**: 流暢的 iOS 原生體驗

## 📋 專案資訊

- **App 名稱**: Onyx Terminal
- **Bundle ID**: com.onx999.OnyxTerminal
- **最低版本**: iOS 16.0+
- **開發語言**: Swift 5.9
- **介面框架**: SwiftUI

## 🏗️ 專案結構
# Onyx Terminal - iOS SSH & SFTP Client

![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

A professional iOS application providing SSH terminal access and SFTP file transfer capabilities with an intuitive SwiftUI interface.

## ✨ Features

### Current Implementation
- 🖥️ **Full VT100 Terminal** - Complete terminal emulation using SwiftTerm
- 🔐 **SSH Connection** - Secure shell access using SwiftNIO-SSH
- 📁 **SFTP File Transfer** - Upload and download files using Shout/libssh2
- 🌍 **Multi-language Support** - Traditional Chinese (default) and English
- ⚡ **Quick Actions** - Shortcuts for common ML/AI commands (llama.cpp, ollama, transformers, conda, tmux)
- 🎨 **SwiftUI Interface** - Modern, native iOS design

### Architecture Highlights
- **Protocol-based Design** - Abstract SSH/SFTP clients with stub implementations
- **MVVM Architecture** - Clean separation of concerns
- **Dependency Injection** - Testable and maintainable codebase
- **Security First** - Keychain integration for credential storage (interface ready)
- **Host Key Verification** - Known hosts management (interface ready)

## 📋 Requirements

- **iOS**: 16.0+
- **Xcode**: 15.0+
- **Swift**: 5.9+
- **Ruby**: 3.0+ (for Fastlane)
- **XcodeGen**: Latest (for project generation)

## 🏗️ Project Structure

```
ios-ssh-ml-onyx-terminal/
├── Sources/
│   └── App/
│       ├── Features/          # 功能模組
│       │   ├── SSH/          # SSH 客戶端協定與實作
│       │   ├── SFTP/         # SFTP 客戶端協定與實作
│       │   └── TerminalUI/   # 終端介面元件
│       ├── Core/             # 核心模組
│       │   ├── Networking/   # 網路層
│       │   ├── Security/     # 安全性（Keychain、金鑰驗證）
│       │   ├── Storage/      # 資料儲存
│       │   └── DesignSystem/ # 設計系統
│       ├── Models/           # 資料模型
│       ├── Views/            # SwiftUI 視圖
│       ├── Services/         # 業務邏輯服務
│       └── Utils/            # 工具函式
├── Tests/
│   ├── Unit/                 # 單元測試
│   └── UITests/              # UI 測試
├── fastlane/                 # Fastlane 自動化腳本
└── Tools/                    # 開發工具

```

## 🚀 快速開始

### 前置需求

- macOS 13.0+ with Xcode 15.0+
- Homebrew（用於安裝工具）
- Ruby 3.2+（用於 Fastlane）

### 本機開發

1. **安裝必要工具**
   ```bash
   # 安裝 XcodeGen
   brew install xcodegen
   
   # 安裝 SwiftLint（可選）
   brew install swiftlint
   ```

2. **生成 Xcode 專案**
   ```bash
   xcodegen generate
   ```

3. **開啟專案**
   ```bash
   open OnyxTerminal.xcodeproj
   ```

4. **選擇開發團隊**
   - 在 Xcode 中選擇你的 Apple Developer Team
   - 設定自動簽章（Automatically manage signing）

5. **執行應用程式**
   - 選擇模擬器或真機
   - 按下 Cmd+R 執行

### 使用 Fastlane

```bash
# 安裝 Ruby 依賴
bundle install

# 執行 SwiftLint
bundle exec fastlane lint

# 執行測試
bundle exec fastlane test

# 建置 Debug 版本
bundle exec fastlane build_debug
```

## 🧪 測試

專案包含完整的測試套件：

- **單元測試**: 測試核心業務邏輯和協定實作
- **UI 測試**: 測試使用者介面流程

執行測試：

```bash
# 透過 xcodebuild
xcodebuild test -project OnyxTerminal.xcodeproj \
  -scheme OnyxTerminal \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# 透過 Fastlane
bundle exec fastlane test
```

## 🔧 架構設計

### MVVM 架構

專案採用 **MVVM (Model-View-ViewModel)** 架構：

- **Model**: 資料模型（`SSHConnection`, `SFTPFileEntry` 等）
- **View**: SwiftUI 視圖
- **ViewModel**: `@StateObject` 管理狀態
- **Services**: 業務邏輯層
- **Protocols**: 協定導向設計，便於測試和替換實作

### 協定抽象層

為了支援測試和未來的實作替換，核心功能都定義為協定：

- `SSHClientProtocol`: SSH 客戶端介面
- `SFTPClientProtocol`: SFTP 客戶端介面
- `KeychainServiceProtocol`: Keychain 安全儲存
- `HostKeyVerifierProtocol`: SSH 主機金鑰驗證

目前提供 Stub 實作供測試使用，未來可替換為真實實作。

## 📦 相依套件（SPM）

- [SwiftTerm](https://github.com/migueldeicaza/SwiftTerm): VT100/Xterm 終端模擬器
- [Shout](https://github.com/jakeheis/Shout): libssh2 Swift 包裝器（SFTP）
- [swift-nio-ssh](https://github.com/apple/swift-nio-ssh): Apple 官方 SSH 實作

## 🔄 CI/CD

### GitHub Actions

專案使用 GitHub Actions 進行持續整合：

- **觸發時機**: Push to main、Pull Request
- **執行項目**:
  - ✅ SwiftLint 程式碼檢查
  - ✅ 單元測試
  - ✅ UI 測試
  - ✅ Debug 建置

### 工作流程檔案

- `.github/workflows/ci.yml`: 主要 CI 流程

## 📝 開發指南

詳細的開發指南請參考 [CONTRIBUTING.md](CONTRIBUTING.md)

## 🗺️ 開發路線圖

### ✅ 已完成

- [x] iOS 專案基礎架構
- [x] SSH 協定抽象層
- [x] SFTP 協定抽象層
- [x] Stub 實作（用於測試）
- [x] 基礎終端 UI
- [x] 連線管理介面
- [x] SFTP 檔案瀏覽
- [x] 單元測試與 UI 測試
- [x] SwiftLint 整合
- [x] Fastlane 自動化
- [x] CI/CD 流程

### 🚧 開發中

- [ ] 真實 SSH/PTY 整合（取代 Stub）
- [ ] 真實 SFTP 實作完善
- [ ] SSH 金鑰認證
- [ ] Keychain 整合（儲存密碼/金鑰）
- [ ] known_hosts 主機金鑰驗證

### 📅 計劃中

- [ ] 進階終端功能：
  - [ ] 完整 PTY 支援
  - [ ] VT100 控制序列完整支援
  - [ ] 自訂配色主題
  - [ ] 字型選擇
  - [ ] 游標樣式
- [ ] SFTP 進階功能：
  - [ ] 大檔案傳輸進度顯示
  - [ ] 背景傳輸
  - [ ] 斷點續傳
  - [ ] 批次操作
- [ ] 連線管理：
  - [ ] 儲存常用連線設定
  - [ ] 連線分組
  - [ ] 快速切換
- [ ] 其他功能：
  - [ ] Port forwarding（通道轉發）
  - [ ] Session 錄製與重播
  - [ ] 多分頁/分割視窗

## ⚠️ 注意事項

- SFTP 路徑建議使用絕對路徑，`~` 在部分庫中可能無法正確展開
- 長時間執行的指令建議搭配 `tmux` 或 `screen` 使用
- 目前 SSH 與 SFTP 使用不同的底層實作庫（NIOSSH vs Shout），未來考慮統一

## 📄 授權

本專案採用 MIT 授權條款 - 詳見 [LICENSE](LICENSE) 檔案

## 🤝 貢獻

歡迎提交 Issue 和 Pull Request！

請參考 [CONTRIBUTING.md](CONTRIBUTING.md) 了解貢獻指南。

## 📧 聯絡方式

- GitHub Issues: [https://github.com/ONX999/ios-ssh-ml-onyx-terminal/issues](https://github.com/ONX999/ios-ssh-ml-onyx-terminal/issues)

---

**Made with ❤️ for the iOS Developer Community**
│   ├── App/                    # Application entry point and main views
│   │   ├── TerminalCLIApp.swift
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── Views/
│   │   └── Utils/
│   ├── Features/               # Feature modules
│   │   ├── SSH/               # SSH client implementations
│   │   ├── SFTP/              # SFTP client implementations
│   │   └── TerminalUI/        # Terminal UI components
│   └── Core/                  # Core infrastructure
│       ├── Networking/        # SSH/SFTP protocols
│       ├── Security/          # Keychain, host key verification
│       ├── Storage/           # Data persistence
│       └── DesignSystem/      # UI components and themes
├── Tests/
│   ├── Unit/                  # Unit tests
│   └── UITests/               # UI tests
├── Tools/                     # Development tools and scripts
├── fastlane/                  # Fastlane configuration
│   ├── Fastfile
│   ├── Appfile
│   └── Scanfile
├── .github/
│   └── workflows/
│       └── ci.yml            # GitHub Actions CI workflow
├── project.yml               # XcodeGen project specification
├── Gemfile                   # Ruby dependencies
├── .swiftlint.yml           # SwiftLint configuration
└── .gitignore
```

## 🚀 Quick Start

### 1. Install Dependencies

```bash
# Install XcodeGen
brew install xcodegen

# Install Ruby dependencies (Fastlane)
bundle install

# Install SwiftLint
brew install swiftlint
```

### 2. Generate Xcode Project

```bash
xcodegen generate
```

This will create `OnyxTerminal.xcodeproj` and `OnyxTerminal.xcworkspace` from the `project.yml` specification.

### 3. Open in Xcode

```bash
open OnyxTerminal.xcworkspace
```

Select your development team in Xcode project settings, then build and run on a simulator or device.

### 4. Run with Fastlane (Alternative)

```bash
# Lint code
bundle exec fastlane lint

# Run tests
bundle exec fastlane test

# Build debug version
bundle exec fastlane build_debug

# Run all checks
bundle exec fastlane ci
```

## 🧪 Testing

### Run Tests via Xcode
- Select the test target
- Press `Cmd+U` to run all tests
- View results in the Test Navigator

### Run Tests via Command Line
```bash
# Using xcodebuild
xcodebuild test \
  -workspace OnyxTerminal.xcworkspace \
  -scheme OnyxTerminal \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Using Fastlane
bundle exec fastlane test
```

### Test Coverage
- Unit tests for SSH/SFTP protocol implementations
- UI tests for main user flows
- Code coverage reports generated in CI

## 🔧 Development

### Code Style
- **SwiftLint** enforces consistent coding style
- Configuration in `.swiftlint.yml`
- Run `bundle exec fastlane lint` before committing

### Commit Convention
Follow conventional commits:
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `test:` - Test additions/changes
- `refactor:` - Code refactoring
- `chore:` - Build/tooling changes

### Branch Strategy
- `main` - Production-ready code
- `develop` - Development integration branch
- `feature/*` - Feature branches
- `fix/*` - Bug fix branches

## 🔄 CI/CD

### GitHub Actions
The project includes automated CI workflow (`.github/workflows/ci.yml`) that:
- ✅ Runs SwiftLint
- ✅ Builds the app
- ✅ Runs unit and UI tests
- ✅ Generates code coverage reports
- ✅ Archives test results and build artifacts

Triggers on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches
- Manual workflow dispatch

### Fastlane Lanes

```bash
# Development
fastlane lint           # Run SwiftLint
fastlane test           # Run tests
fastlane build_debug    # Build debug version
fastlane build_release  # Build release (requires signing setup)
fastlane ci             # Run all checks

# Deployment (TODO: Configure signing)
fastlane beta           # Deploy to TestFlight
```

## 📱 App Configuration

- **Bundle ID**: `com.onx999.OnyxTerminal`
- **Display Name**: Onyx Terminal
- **Minimum iOS Version**: 16.0
- **Default Language**: Traditional Chinese (zh-Hant)
- **Supported Languages**: Traditional Chinese, English

## 🔐 Security Features

### Implemented
- Abstract protocols for secure credential management
- Host key verification interfaces
- Secure password fields in UI

### TODO (Marked in code)
- [ ] Complete Keychain integration for credential storage
- [ ] Implement persistent known_hosts storage
- [ ] Add host key verification workflow
- [ ] Support private key authentication
- [ ] Implement SSH key generation

## 🗺️ Roadmap

### Phase 1: Foundation ✅ (Current PR)
- [x] Project scaffold and structure
- [x] Protocol abstractions for SSH/SFTP
- [x] Stub implementations
- [x] Basic UI framework
- [x] Testing infrastructure
- [x] CI/CD pipeline
- [x] Documentation

### Phase 2: Core SSH/SFTP (Next)
- [ ] Replace stub SSH client with full SwiftNIO-SSH implementation
- [ ] Replace stub SFTP client with Shout/libssh2 implementation
- [ ] Implement complete PTY/terminal interaction
- [ ] Add VT100 escape sequence handling
- [ ] Improve terminal rendering and performance

### Phase 3: Security & Authentication
- [ ] Complete Keychain credential storage
- [ ] Implement known_hosts persistence and verification
- [ ] Add SSH key pair generation
- [ ] Support multiple authentication methods
- [ ] Add certificate-based authentication

### Phase 4: Advanced Features
- [ ] Background file transfer with progress tracking
- [ ] Transfer pause/resume/cancel
- [ ] Multiple concurrent sessions
- [ ] Session persistence and restoration
- [ ] Custom terminal themes and fonts
- [ ] Keyboard shortcuts and customization

### Phase 5: Polish & Distribution
- [ ] Complete UI/UX refinements
- [ ] Accessibility improvements
- [ ] Localization for more languages
- [ ] Performance optimizations
- [ ] App Store preparation
- [ ] TestFlight beta testing

## 🛠️ Dependencies

### Swift Package Manager
- **SwiftTerm** - Terminal emulation (https://github.com/migueldeicaza/SwiftTerm)
- **Shout** - SFTP support (https://github.com/jakeheis/Shout)
- **SwiftNIO-SSH** - SSH protocol (https://github.com/apple/swift-nio-ssh)

### Ruby Gems (via Bundler)
- **fastlane** - Automation and deployment
- **cocoapods** - Dependency management

## 📄 License

MIT License - See LICENSE file for details

## 🤝 Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## 👥 Authors

- ONX999 - Initial work and maintenance

## 🙏 Acknowledgments

- SwiftTerm by Miguel de Icaza for excellent terminal emulation
- Apple's SwiftNIO team for SwiftNIO-SSH
- The Shout team for SFTP support
- All contributors to the open-source libraries used in this project

## 📞 Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check existing issues and discussions
- Refer to documentation in the Wiki

---

**Note**: This is an active development project. Some features are marked as TODO and will be implemented in future releases. The current version provides a solid foundation for SSH/SFTP operations with stub implementations for testing and development.
