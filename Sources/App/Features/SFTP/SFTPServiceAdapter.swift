import Foundation
import Shout

enum SFTPError: Error, LocalizedError {
    case notConnected
    case invalidLocalURL
    case generic(String)
    var errorDescription: String? {
        switch self {
        case .notConnected: return "SFTP 尚未連線"
        case .invalidLocalURL: return "本機檔案 URL 不正確"
        case .generic(let msg): return msg
        }
    }
}

final class SFTPService {
    private var ssh: SSH?
    private var sftp: SFTP?
    var isConnected: Bool { sftp != nil }
    func connect(host: String, port: Int, username: String, password: String) throws {
        let s = try SSH(host: host, port: Int32(port))
        try s.authenticate(username: username, password: password)
        let f = try s.openSftp()
        self.ssh = s
        self.sftp = f
    }
    func disconnect() { sftp = nil; ssh = nil }
    func upload(localURL: URL, remotePath: String) throws {
        guard let sftp = sftp else { throw SFTPError.notConnected }
        try sftp.upload(localURL: localURL, remotePath: remotePath)
    }
    func download(remotePath: String, to localURL: URL) throws {
        guard let sftp = sftp else { throw SFTPError.notConnected }
        try sftp.download(remotePath: remotePath, to: localURL)
    }
    func list(path: String) throws -> [SFTPFile] {
        guard let sftp = sftp else { throw SFTPError.notConnected }
        return try sftp.listDirectory(path)
    }
}
