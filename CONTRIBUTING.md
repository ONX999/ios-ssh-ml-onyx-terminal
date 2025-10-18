# Contributing to Onyx Terminal

感謝您對 Onyx Terminal 的貢獻興趣！本文件提供了參與專案開發的指南。

## 📋 目錄

- [開發環境設置](#開發環境設置)
- [專案結構](#專案結構)
- [開發流程](#開發流程)
- [程式碼規範](#程式碼規範)
- [提交規範](#提交規範)
- [測試要求](#測試要求)
- [Pull Request 流程](#pull-request-流程)

## 🛠️ 開發環境設置

### 必要工具

1. **Xcode 15.0+**
   - 從 Mac App Store 安裝
   - 確保命令列工具已安裝：`xcode-select --install`

2. **Homebrew**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **XcodeGen**
   ```bash
   brew install xcodegen
   ```

4. **SwiftLint**（可選但建議）
   ```bash
   brew install swiftlint
   ```

5. **Ruby & Bundler**
   ```bash
   # 安裝 Ruby（建議使用 rbenv 或 rvm）
   brew install ruby
   
   # 安裝 Bundler
   gem install bundler
   ```

### 設置專案

1. Fork 並複製儲存庫
   ```bash
   git clone https://github.com/YOUR_USERNAME/ios-ssh-ml-onyx-terminal.git
   cd ios-ssh-ml-onyx-terminal
   ```

2. 生成 Xcode 專案
   ```bash
   xcodegen generate
   ```

3. 安裝 Ruby 依賴
   ```bash
   bundle install
   ```

4. 在 Xcode 中開啟專案
   ```bash
   open OnyxTerminal.xcodeproj
   ```

## 📁 專案結構

```
Sources/App/
├── Features/          # 功能模組（按功能組織）
│   ├── SSH/          # SSH 相關功能
│   ├── SFTP/         # SFTP 相關功能
│   └── TerminalUI/   # 終端 UI 元件
├── Core/             # 核心功能（跨功能共用）
│   ├── Networking/   # 網路相關
│   ├── Security/     # 安全性（Keychain、加密等）
│   ├── Storage/      # 資料儲存
│   └── DesignSystem/ # UI 設計系統
├── Models/           # 資料模型
├── Views/            # SwiftUI 視圖
├── Services/         # 服務層
└── Utils/            # 工具函式

Tests/
├── Unit/             # 單元測試
└── UITests/          # UI 測試
```

### 新增功能時的檔案放置原則

- **功能特定**：放在 `Features/` 對應的模組下
- **可重用**：放在 `Core/` 對應的類別下
- **視圖元件**：放在 `Views/`
- **資料模型**：放在 `Models/`

## 🔄 開發流程

### 分支策略

我們使用 **GitHub Flow** 分支策略：

- `main`: 主要分支，應始終保持可部署狀態
- `feature/*`: 新功能分支
- `bugfix/*`: 錯誤修復分支
- `refactor/*`: 重構分支

### 工作流程

1. **建立分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **開發與測試**
   - 編寫程式碼
   - 執行測試：`bundle exec fastlane test`
   - 執行 Lint：`bundle exec fastlane lint`

3. **提交變更**
   ```bash
   git add .
   git commit -m "feat: add your feature"
   ```

4. **推送分支**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **建立 Pull Request**
   - 前往 GitHub 建立 PR
   - 填寫 PR 模板
   - 等待 CI 檢查通過
   - 請求 Code Review

## 📝 程式碼規範

### Swift 風格指南

我們遵循 [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)

主要規則：

1. **命名**
   - 類型名稱使用 `UpperCamelCase`
   - 函式和變數使用 `lowerCamelCase`
   - 常數使用 `lowerCamelCase`（不使用全大寫）

2. **縮排**
   - 使用 4 個空格（不使用 Tab）
   - Xcode 會自動處理

3. **行長度**
   - 建議不超過 120 字元
   - SwiftLint 會警告超過 120 字元的行

4. **註解**
   - 公開 API 必須有文檔註解
   - 使用 `///` 或 `/** */` 格式
   - 複雜邏輯應加上說明註解

### SwiftLint

專案使用 SwiftLint 確保程式碼品質。在提交前執行：

```bash
swiftlint
```

或透過 Fastlane：

```bash
bundle exec fastlane lint
```

### 自動修正

SwiftLint 可以自動修正部分問題：

```bash
swiftlint --fix
```

## 💬 提交規範

我們使用 [Conventional Commits](https://www.conventionalcommits.org/) 規範：

### 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type 類型

- `feat`: 新功能
- `fix`: 錯誤修復
- `docs`: 文檔變更
- `style`: 程式碼格式（不影響功能）
- `refactor`: 重構（不是新功能也不是修復）
- `test`: 測試相關
- `chore`: 建置流程或輔助工具變動

### 範例

```bash
feat(ssh): add private key authentication support

Implement private key authentication for SSH connections.
- Add private key loading from file
- Support passphrase-protected keys
- Update SSHClientProtocol

Closes #123
```

```bash
fix(sftp): handle empty directory listing

Fix crash when listing empty directories.
```

```bash
docs(readme): update installation instructions
```

## 🧪 測試要求

### 測試覆蓋率

- 新功能必須包含單元測試
- 核心業務邏輯的測試覆蓋率應達到 80% 以上
- UI 變更應包含 UI 測試（如適用）

### 執行測試

```bash
# 透過 Fastlane
bundle exec fastlane test

# 透過 xcodebuild
xcodebuild test -project OnyxTerminal.xcodeproj \
  -scheme OnyxTerminal \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

### 測試類型

1. **單元測試** (`Tests/Unit/`)
   - 測試個別函式和類別
   - 使用 mock 和 stub
   - 快速且獨立

2. **UI 測試** (`Tests/UITests/`)
   - 測試使用者介面流程
   - 模擬使用者互動
   - 驗證 UI 元素存在性

### 測試最佳實踐

- 每個測試應該獨立
- 測試名稱應清楚描述測試內容
- 使用 `setUp()` 和 `tearDown()`
- 避免測試之間的依賴

## 🔍 Pull Request 流程

### 提交 PR 前檢查清單

- [ ] 程式碼通過 SwiftLint 檢查
- [ ] 所有測試通過
- [ ] 新增功能包含測試
- [ ] 文檔已更新（如需要）
- [ ] Commit 訊息符合規範
- [ ] 分支已從最新的 `main` 更新

### PR 模板

建立 PR 時請包含：

```markdown
## 變更描述
簡要描述這個 PR 的變更內容

## 變更類型
- [ ] 新功能 (feat)
- [ ] 錯誤修復 (fix)
- [ ] 重構 (refactor)
- [ ] 文檔更新 (docs)
- [ ] 測試 (test)
- [ ] 其他

## 測試
描述測試方法和結果

## 截圖（如適用）
UI 變更請附上截圖

## 相關 Issue
Closes #<issue_number>
```

### Code Review

- 所有 PR 需要至少一位 reviewer 批准
- 回應 review 意見
- CI 必須通過
- 解決所有衝突

## 🆘 尋求幫助

遇到問題？

- 查看 [README.md](README.md)
- 搜尋現有 [Issues](https://github.com/ONX999/ios-ssh-ml-onyx-terminal/issues)
- 建立新 Issue 詢問

## 📜 授權

貢獻到本專案的程式碼將以 MIT 授權發布。

---

感謝您的貢獻！ 🙏
