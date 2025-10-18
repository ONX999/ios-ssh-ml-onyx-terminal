import SwiftUI

@main
struct TerminalCLIApp: App {
    @AppStorage("appLanguage") private var appLanguage: String = "zh-Hant" // 預設繁體中文
    var body: some Scene {
        WindowGroup {
            TerminalScreen()
                .environment(\.locale, Locale(identifier: appLanguage))
        }
    }
}
