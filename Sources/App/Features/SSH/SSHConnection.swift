import Foundation

struct SSHConnection: Equatable {
    var host: String = ""
    var port: Int = 22
    var username: String = ""
    var password: String = "" // 若使用金鑰，可改為 passphrase 或留空
    
    var isFilled: Bool {
        !host.isEmpty && (1...65535).contains(port) && !username.isEmpty && !password.isEmpty
    }
}
