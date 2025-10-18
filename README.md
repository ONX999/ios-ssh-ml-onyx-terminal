# Onyx Terminal (iOS SSH 終端 + SFTP + 模型指令快捷鍵)

這是一個可在 iOS 上使用的完整 SSH 終端 App，具備：
- 完整 VT100 終端（SwiftTerm）
- SSH（基於 swift-nio-ssh）
- SFTP 上傳/下載（Shout/libssh2）
- 語言切換：繁體中文/英文（預設為繁體中文）
- 常用模型指令快捷鍵列（llama.cpp、ollama、transformers、conda、tmux 等）

專案名稱與識別
- App 顯示名稱：Onyx Terminal
- Bundle ID：com.onx999.OnyxTerminal
- iOS 版本需求：iOS 16+
- 依賴（SPM）
  - SwiftTerm: https://github.com/migueldeicaza/SwiftTerm
  - Shout: https://github.com/jakeheis/Shout
  - swift-nio-ssh: https://github.com/apple/swift-nio-ssh

快速開始（本機）
1) 安裝 XcodeGen：`brew install xcodegen`
2) 生成 Xcode 專案：`xcodegen generate`
3) 使用 Xcode 開啟 `OnyxTerminal.xcodeproj`，選擇你的 Apple Developer Team，接上真機執行

語言切換
- 設定 -> 語言：繁體中文/English，預設為繁體中文（zh-Hant）
- 切換後立即生效（使用 AppStorage 持久化）

CI（GitHub Actions）
- 兩個工作流程：
  - `.github/workflows/ios-ci.yml`：每次 push/PR 自動建置（不發佈）
  - `.github/workflows/testflight.yml`：手動/標籤觸發，以 fastlane 打包並上傳 TestFlight
- 需要 Secrets（若要使用 TestFlight 發佈）：
  - `ASC_KEY_ID`：App Store Connect API Key 的 Key ID
  - `ASC_ISSUER_ID`：App Store Connect API Key 的 Issuer ID
  - `ASC_PRIVATE_KEY`：App Store Connect API Key 私鑰內容的 Base64（請將 .p8 內容 Base64 後填入）
  - `DEV_TEAM_ID`：（可選）你的 Developer Team ID（若有需要指定）

TestFlight（fastlane）
- lanes：
  - `fastlane ios build`：本地打包（不上傳）
  - `fastlane ios beta`：打包並上傳 TestFlight（需設定上方 Secrets）
- 需在 Xcode 啟用「自動簽章」或在 CI 配置憑證/Provisioning Profile

建立 GitHub 倉庫與推送
1) 請先在 GitHub 建立空倉庫：ONX999/ios-ssh-ml-onyx-terminal（注意：名稱不可含空白）
2) 將本專案所有檔案（含此 README、project.yml、Sources、fastlane 與 .github/workflows）放到同一資料夾
3) 在該資料夾執行：
   ```
   git init
   git add .
   git commit -m "feat: Onyx Terminal – zh-Hant/en 語言切換（預設繁中）、SSH 終端 + SFTP + 快捷鍵 + CI/fastlane"
   git branch -M main
   git remote add origin https://github.com/ONX999/ios-ssh-ml-onyx-terminal.git
   git push -u origin main
   ```
4) 在 GitHub -> Settings -> Secrets and variables -> Actions，新增：
   - ASC_KEY_ID
   - ASC_ISSUER_ID
   - ASC_PRIVATE_KEY（.p8 內容做 Base64 後貼上）
   - DEV_TEAM_ID（可選）

觸發 CI/發佈
- 每次推送或開 PR，自動跑 ios-ci（建置）
- 要發佈 TestFlight：
  - 在 Actions 頁面手動觸發 testflight Workflow「Run workflow」
  - 或推送標籤（例如 `v1.0.0`）

注意事項
- SFTP 路徑請盡量用絕對路徑；`~` 在 SFTP 庫不一定會自動展開
- 長任務建議搭配 tmux/screen
- 若 TestFlight 發佈遇到簽章問題，先確認 Xcode 專案使用自動簽章，或在 fastlane 配置憑證（match）
