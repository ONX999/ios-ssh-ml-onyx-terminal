# Quick Reference - Onyx Terminal

## 🚀 快速指令

```bash
# 設置環境
make setup                  # 安裝所有依賴
make generate              # 生成 Xcode 專案

# 開發
make build                 # 建置專案
make test                  # 執行測試
make lint                  # 執行 SwiftLint
make format                # 自動修正格式

# Fastlane
make fastlane-lint         # Fastlane lint
make fastlane-test         # Fastlane test
make fastlane-build        # Fastlane build

# 工具
./Tools/check-structure.sh # 檢查專案結構
```

## 📁 重要檔案

| 檔案 | 說明 |
|------|------|
| `project.yml` | XcodeGen 專案配置 |
| `.swiftlint.yml` | SwiftLint 規則 |
| `Gemfile` | Ruby 依賴 |
| `Makefile` | 常用指令 |
| `.github/workflows/ci.yml` | CI 配置 |

## 🧪 測試

```bash
# 單元測試
xcodebuild test -project OnyxTerminal.xcodeproj \
  -scheme OnyxTerminal \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# 特定測試
xcodebuild test -project OnyxTerminal.xcodeproj \
  -scheme OnyxTerminal \
  -only-testing:OnyxTerminalTests/SSHClientTests

# UI 測試
xcodebuild test -project OnyxTerminal.xcodeproj \
  -scheme OnyxTerminal \
  -only-testing:OnyxTerminalUITests
```

## 🏗️ 模組結構

### SSH 模組
```swift
// 協定
SSHClientProtocol

// 實作
NIOSSHClientAdapter  // 真實實作
StubSSHClient        // 測試用

// 模型
SSHConnectionConfig
SSHAuthMethod
```

### SFTP 模組
```swift
// 協定
SFTPClientProtocol

// 實作
SFTPServiceAdapter   // 真實實作
StubSFTPClient       // 測試用

// 模型
SFTPFileEntry
SFTPFileAttributes
```

### Security 模組
```swift
// Keychain
KeychainServiceProtocol
StubKeychainService

// Host Key
HostKeyVerifierProtocol
StubHostKeyVerifier
```

## 🔧 常見任務

### 新增功能

1. 建立協定（如果需要）
2. 建立實作
3. 建立測試
4. 更新文檔

### 新增測試

```swift
// Tests/Unit/NewFeatureTests.swift
import XCTest
@testable import OnyxTerminal

final class NewFeatureTests: XCTestCase {
    func testSomething() {
        // Arrange
        // Act
        // Assert
    }
}
```

### 新增本地化字串

1. 在 `en.lproj/Localizable.strings` 新增鍵值
2. 在 `zh-Hant.lproj/Localizable.strings` 新增翻譯
3. 在程式碼中使用：
   ```swift
   NSLocalizedString("key", comment: "說明")
   // 或
   LocalizedStringKey("key")
   ```

## 📚 文檔位置

| 文檔 | 路徑 |
|------|------|
| 專案介紹 | `README.md` |
| 開發指南 | `CONTRIBUTING.md` |
| 開發筆記 | `DEVELOPMENT.md` |
| 架構說明 | `docs/ARCHITECTURE.md` |
| SSH 配置 | `docs/SSH_CONFIGURATION.md` |
| 專案總結 | `docs/PROJECT_SUMMARY.md` |

## 🐛 除錯

### SwiftLint 錯誤

```bash
# 查看所有問題
swiftlint

# 自動修正
swiftlint --fix

# 忽略特定規則
// swiftlint:disable rule_name
code here
// swiftlint:enable rule_name
```

### 建置錯誤

```bash
# 清理專案
make clean

# 重新生成
make generate

# 刪除 DerivedData
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### 測試失敗

```bash
# 查看詳細日誌
xcodebuild test ... | xcpretty --color

# 執行單一測試
xcodebuild test -only-testing:Target/TestClass/testMethod
```

## 🔐 安全性

### 儲存密碼

```swift
// TODO: 實作 Keychain
let keychain = StubKeychainService()
try keychain.save(data: passwordData, forKey: "ssh.password.\(host)")
```

### Host Key 驗證

```swift
// TODO: 實作 known_hosts
let verifier = StubHostKeyVerifier()
let result = try await verifier.verify(
    hostKey: key,
    host: host,
    port: port
)
```

## 📊 專案指標

- **Swift 檔案**: 17 個
- **測試檔案**: 3 個
- **程式碼行數**: ~1,600 行
- **測試覆蓋**: 核心協定已覆蓋
- **文檔**: 6 個 Markdown 文件

## 🎯 下一步

1. 查看 `DEVELOPMENT.md` 的 TODO 清單
2. 選擇一個任務開始開發
3. 建立 feature branch
4. 實作、測試、文檔
5. 提交 PR

## 💡 提示

- 使用 `make help` 查看所有可用指令
- 執行 `./Tools/check-structure.sh` 驗證結構
- 查看 `docs/ARCHITECTURE.md` 了解架構設計
- 遵循 `CONTRIBUTING.md` 的開發流程

---

**Happy Coding! 🎉**
