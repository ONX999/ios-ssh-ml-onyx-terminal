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
