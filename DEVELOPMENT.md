# Development Notes

## 架構設計決策

### Protocol-Oriented Design（協定導向設計）

專案採用協定導向設計，主要有以下優點：

1. **可測試性**：可以輕鬆建立 stub/mock 實作用於測試
2. **靈活性**：可以在不影響現有程式碼的情況下替換實作
3. **依賴注入**：便於注入不同的實作

### 當前實作狀態

#### SSH 客戶端

- **協定**：`SSHClientProtocol`（`Sources/App/Features/SSH/SSHClientProtocol.swift`）
- **實作**：
  - `NIOSSHClientAdapter`：包裝現有的 NIOSSHClient，用於真實連線
  - `StubSSHClient`：測試用 stub 實作

#### SFTP 客戶端

- **協定**：`SFTPClientProtocol`（`Sources/App/Features/SFTP/SFTPClientProtocol.swift`）
- **實作**：
  - `SFTPService`：使用 Shout 庫的真實實作（待整合到協定）
  - `StubSFTPClient`：測試用 stub 實作

#### 安全性模組

- **Keychain**：`KeychainServiceProtocol`（待實作真實 Keychain 整合）
- **Host Key Verification**：`HostKeyVerifierProtocol`（待實作 known_hosts）

## TODO 清單

### 高優先級

1. **SFTP 協定整合**
   - [ ] 建立 `SFTPServiceAdapter` 使 `SFTPService` 符合 `SFTPClientProtocol`
   - [ ] 處理 Shout 庫的非同步操作
   - [ ] 實作檔案傳輸進度回報

2. **真實 Keychain 整合**
   - [ ] 實作 `KeychainService` 使用 iOS Keychain API
   - [ ] 儲存 SSH 密碼
   - [ ] 儲存 SSH 私鑰與 passphrase

3. **Host Key 驗證**
   - [ ] 實作 known_hosts 檔案讀寫
   - [ ] 實作首次連線時的金鑰確認 UI
   - [ ] 處理金鑰變更警告

### 中優先級

4. **SSH 金鑰認證**
   - [ ] 支援私鑰檔案選擇
   - [ ] 支援 passphrase 保護的私鑰
   - [ ] 整合到 `SSHAuthMethod.privateKey`

5. **連線管理**
   - [ ] 儲存連線設定到 UserDefaults
   - [ ] 連線歷史記錄
   - [ ] 快速連線功能

6. **SFTP UI 改進**
   - [ ] 樹狀目錄瀏覽
   - [ ] 檔案圖示
   - [ ] 檔案操作（重新命名、刪除、新建目錄等）
   - [ ] 拖放上傳

### 低優先級

7. **終端增強**
   - [ ] 自訂配色主題
   - [ ] 字型選擇
   - [ ] 分割視窗
   - [ ] 多分頁支援

8. **其他功能**
   - [ ] Port forwarding（本地/遠端）
   - [ ] Session 錄製
   - [ ] 腳本自動化

## 已知問題

1. **SFTP 路徑展開**
   - Shout 庫可能無法正確展開 `~` 符號
   - 建議：使用絕對路徑或實作路徑展開邏輯

2. **UI 測試**
   - 目前的 UI 測試僅驗證元件存在性
   - 需要：更完整的使用者流程測試

3. **錯誤處理**
   - 某些錯誤訊息僅為英文
   - 需要：完整的本地化錯誤訊息

## 測試策略

### 單元測試

- 測試協定實作的行為
- 使用 stub 實作進行快速測試
- 測試覆蓋率目標：80%+

### UI 測試

- 測試主要使用者流程
- 測試語言切換
- 測試連線流程（使用測試伺服器）

### 整合測試

- TODO: 設置測試 SSH 伺服器
- TODO: 測試真實的 SSH/SFTP 操作

## 建置與發佈

### 本地建置

```bash
# 生成 Xcode 專案
xcodegen generate

# 執行 SwiftLint
swiftlint

# 執行測試
xcodebuild test -project OnyxTerminal.xcodeproj \
  -scheme OnyxTerminal \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

### CI/CD

- GitHub Actions 會在每次 push/PR 時執行
- 執行項目：lint、test、build
- TODO: 設置 TestFlight 自動發佈

## 相依性管理

### Swift Package Manager

- SwiftTerm：終端模擬器
- Shout：SFTP 支援（基於 libssh2）
- swift-nio-ssh：SSH 支援

### 注意事項

- Shout 使用 libssh2（C 語言庫）
- swift-nio-ssh 是純 Swift 實作
- 目前 SSH 和 SFTP 使用不同的底層庫
- 未來可考慮統一使用一個庫

## 程式碼風格

### Swift 風格

- 遵循 Swift API Design Guidelines
- 使用 SwiftLint 確保一致性
- 4 空格縮排

### 註解風格

- 公開 API 使用文檔註解（`///` 或 `/** */`）
- 複雜邏輯加上說明註解
- TODO 註記使用 `// TODO: 描述`

### 檔案組織

- 一個檔案一個主要類型
- 相關的小型類型可以放在同一檔案
- 使用 MARK 註記分隔程式碼區塊

## 本地化

### 支援語言

- 繁體中文（預設）
- English

### 新增翻譯

1. 在兩個 Localizable.strings 檔案中新增鍵值對
2. 在程式碼中使用 `NSLocalizedString("key", comment: "說明")`
3. 或使用 SwiftUI 的 `LocalizedStringKey("key")`

## 除錯技巧

### SSH 連線問題

- 檢查網路連線
- 檢查防火牆設定
- 確認伺服器 SSH 設定
- 查看錯誤訊息（`onError` 回呼）

### SFTP 問題

- 確認 SFTP 子系統已啟用
- 使用絕對路徑
- 檢查檔案權限

### 終端顯示問題

- 檢查終端類型設定（預設 xterm-256color）
- 調整視窗大小（cols/rows）
- 清除終端快取

## 效能考量

### 記憶體

- SwiftTerm 的 scrollback buffer 設為 20000 行
- 大量資料傳輸時注意記憶體使用
- 適時釋放不需要的資源

### 網路

- SSH/SFTP 連線使用獨立的 EventLoopGroup
- 避免在主執行緒執行網路操作
- 大檔案傳輸考慮分塊處理

## 安全性考量

### 密碼儲存

- 使用 iOS Keychain 儲存敏感資料
- 不在 UserDefaults 儲存密碼
- 考慮使用 Face ID/Touch ID 保護

### 網路安全

- 驗證伺服器 host key
- 首次連線時詢問使用者
- 金鑰變更時警告使用者

### 私鑰保護

- 私鑰儲存在安全位置
- 支援 passphrase 保護
- 考慮使用 Secure Enclave（進階功能）
