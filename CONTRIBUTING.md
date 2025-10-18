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
Thank you for your interest in contributing to Onyx Terminal! This document provides guidelines and instructions for contributing.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of background or identity.

### Our Standards

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## 🚀 Getting Started

### Prerequisites

1. **macOS** with Xcode 15.0+
2. **Homebrew** package manager
3. **Ruby** 3.0+ (for Fastlane)
4. **Git** for version control

### Setup Development Environment

```bash
# Clone the repository
git clone https://github.com/ONX999/ios-ssh-ml-onyx-terminal.git
cd ios-ssh-ml-onyx-terminal

# Install XcodeGen
brew install xcodegen

# Install Ruby dependencies
bundle install

# Install SwiftLint
brew install swiftlint

# Generate Xcode project
xcodegen generate

# Open in Xcode
open OnyxTerminal.xcworkspace
```

## 🔄 Development Workflow

### Branch Strategy

We use **Git Flow** branching model:

- `main` - Production-ready code, only accepts PRs from `develop` or hotfix branches
- `develop` - Development integration branch
- `feature/*` - Feature development branches
- `fix/*` - Bug fix branches
- `hotfix/*` - Emergency fixes for production
- `release/*` - Release preparation branches

### Creating a Feature Branch

```bash
# Start from develop
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b fix/bug-description
```

### Working on Your Changes

1. Make your changes in small, logical commits
2. Write or update tests as needed
3. Run linter and tests locally before committing
4. Keep your branch up to date with develop

```bash
# Sync with develop regularly
git fetch origin
git rebase origin/develop

# Run linter
bundle exec fastlane lint

# Run tests
bundle exec fastlane test
```

## 💻 Coding Standards

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and enforce them with SwiftLint.

### Key Principles

1. **Clarity at the point of use** is your most important goal
2. **Prefer clarity over brevity**
3. **Use terminology well** - avoid obscure terms
4. **Strive for fluent usage**
5. **Name protocols** according to what they do
6. **Name types** according to what they are

### SwiftLint Rules

All code must pass SwiftLint checks:

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
Common rules:
- Line length: max 150 characters
- Function body length: max 60 lines (warning), 100 (error)
- Type body length: max 300 lines (warning), 500 (error)
- Cyclomatic complexity: max 15 (warning), 25 (error)

### Code Organization

```swift
// MARK: - Type Definition
class MyClass {
    // MARK: - Properties
    private let dependency: Dependency
    
    // MARK: - Initialization
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Public Methods
    func publicMethod() {
        // Implementation
    }
    
    // MARK: - Private Methods
    private func privateMethod() {
        // Implementation
    }
}

// MARK: - Protocol Conformance
extension MyClass: SomeProtocol {
    func protocolMethod() {
        // Implementation
    }
}
```

### Documentation

- Document all public APIs with doc comments
- Use `///` for documentation comments
- Include parameter descriptions and return values
- Add code examples for complex functionality

```swift
/// Connects to an SSH server with the specified configuration
///
/// - Parameter config: SSH connection configuration including host, port, and credentials
/// - Throws: `SSHClientError` if connection fails
/// - Returns: A connected SSH client instance
func connect(config: SSHConnectionConfig) async throws -> SSHClient {
    // Implementation
}
```

## 🧪 Testing Guidelines

### Test Coverage

- All new features must include unit tests
- UI changes should include UI tests
- Aim for >80% code coverage
- Test edge cases and error conditions

### Test Structure

```swift
// Arrange-Act-Assert pattern
func testFeatureName() async throws {
    // Given: Setup test conditions
    let sut = SystemUnderTest()
    
    // When: Perform action
    let result = try await sut.performAction()
    
    // Then: Verify results
    XCTAssertEqual(result, expectedValue)
}
```

### Running Tests

```bash
# All tests
bundle exec fastlane test

# Unit tests only
xcodebuild test -workspace OnyxTerminal.xcworkspace -scheme OnyxTerminal -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -only-testing:OnyxTerminalTests

# UI tests only
xcodebuild test -workspace OnyxTerminal.xcworkspace -scheme OnyxTerminal -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -only-testing:OnyxTerminalUITests
```

## 📝 Commit Message Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Format

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
### Types

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, missing semicolons, etc.)
- `refactor:` - Code refactoring
- `perf:` - Performance improvements
- `test:` - Adding or updating tests
- `chore:` - Build process or auxiliary tool changes
- `ci:` - CI/CD changes

### Scopes (optional)

- `ssh` - SSH client
- `sftp` - SFTP client
- `ui` - User interface
- `security` - Security features
- `terminal` - Terminal emulation
- `tests` - Testing infrastructure
- `ci` - Continuous integration

### Examples

```bash
# Feature
git commit -m "feat(ssh): add host key verification"

# Bug fix
git commit -m "fix(sftp): handle file upload errors correctly"

# Documentation
git commit -m "docs: update contributing guidelines"

# Breaking change
git commit -m "feat(ssh)!: change authentication API

BREAKING CHANGE: authenticate() now requires async/await"
```

### Commit Message Rules

- Use imperative mood ("add feature" not "added feature")
- First line should be 50 characters or less
- Reference issue numbers in footer (e.g., "Fixes #123")
- Use body to explain what and why, not how

## 🔍 Pull Request Process

### Before Submitting

1. ✅ Code passes all linter checks
2. ✅ All tests pass
3. ✅ Code coverage is maintained or improved
4. ✅ Documentation is updated
5. ✅ Commit messages follow conventions
6. ✅ Branch is up to date with develop

### PR Checklist

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] UI tests added/updated (if applicable)
- [ ] All tests passing
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Passes all CI checks
```

### PR Review Process

1. Create PR targeting `develop` branch
2. Fill in PR template completely
3. Ensure CI checks pass
4. Request review from maintainers
5. Address review feedback
6. Wait for approval from at least one maintainer
7. Maintainer will merge when ready

### PR Guidelines

- Keep PRs focused on a single feature or fix
- Limit PR size (ideally <500 lines of code)
- Write clear PR description
- Link related issues
- Respond to review comments promptly
- Don't force push after review has started (use additional commits)

## 🚢 Release Process

Releases are managed by maintainers following semantic versioning.

### Version Numbering

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Steps (Maintainers)

1. Create release branch from develop
2. Update version number
3. Update CHANGELOG.md
4. Create PR to main
5. After merge, tag release
6. Deploy to TestFlight
7. Merge main back to develop

## 🐛 Reporting Bugs

### Bug Report Template

When reporting bugs, include:

1. **Description**: Clear and concise description
2. **Steps to Reproduce**: Numbered steps to reproduce the issue
3. **Expected Behavior**: What should happen
4. **Actual Behavior**: What actually happens
5. **Environment**:
   - iOS version
   - Device model
   - App version
6. **Screenshots**: If applicable
7. **Logs**: Relevant error messages or logs

## 💡 Feature Requests

### Feature Request Template

When requesting features, include:

1. **Problem**: What problem does this solve?
2. **Proposed Solution**: Your suggested solution
3. **Alternatives**: Alternative solutions considered
4. **Additional Context**: Any other relevant information

## 📞 Getting Help

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Documentation**: Check the Wiki for detailed guides

## 🙏 Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes
- Project README

Thank you for contributing to Onyx Terminal! 🎉
