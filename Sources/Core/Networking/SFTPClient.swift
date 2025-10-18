import Foundation

/// Protocol defining SFTP client capabilities for file transfer operations
public protocol SFTPClient {
    /// List files and directories at the specified path
    /// - Parameter path: Remote directory path
    /// - Returns: Array of file information
    /// - Throws: SFTPError if listing fails
    func list(path: String) async throws -> [SFTPFileInfo]
    
    /// Download a file from remote server
    /// - Parameters:
    ///   - remotePath: Remote file path
    ///   - localURL: Local destination URL
    /// - Throws: SFTPError if download fails
    func download(from remotePath: String, to localURL: URL) async throws
    
    /// Upload a file to remote server
    /// - Parameters:
    ///   - localURL: Local file URL
    ///   - remotePath: Remote destination path
    /// - Throws: SFTPError if upload fails
    func upload(from localURL: URL, to remotePath: String) async throws
    
    /// Create a directory on remote server
    /// - Parameter path: Remote directory path
    /// - Throws: SFTPError if creation fails
    func makeDirectory(at path: String) async throws
    
    /// Remove a file or directory from remote server
    /// - Parameter path: Remote path to remove
    /// - Throws: SFTPError if removal fails
    func remove(path: String) async throws
    
    /// Check if a path exists on remote server
    /// - Parameter path: Remote path to check
    /// - Returns: True if path exists
    /// - Throws: SFTPError if check fails
    func exists(path: String) async throws -> Bool
    
    /// Close the SFTP session
    func close() async throws
}

/// Information about a file or directory in SFTP
public struct SFTPFileInfo {
    public let filename: String
    public let isDirectory: Bool
    public let size: Int64
    public let permissions: UInt32?
    public let modificationDate: Date?
    
    public init(filename: String, isDirectory: Bool, size: Int64, permissions: UInt32? = nil, modificationDate: Date? = nil) {
        self.filename = filename
        self.isDirectory = isDirectory
        self.size = size
        self.permissions = permissions
        self.modificationDate = modificationDate
    }
}

/// SFTP errors
public enum SFTPError: Error, LocalizedError {
    case notConnected
    case invalidPath(String)
    case fileNotFound(String)
    case permissionDenied(String)
    case operationFailed(String)
    case invalidLocalURL
    
    public var errorDescription: String? {
        switch self {
        case .notConnected:
            return "SFTP session is not connected"
        case .invalidPath(let path):
            return "Invalid path: \(path)"
        case .fileNotFound(let path):
            return "File not found: \(path)"
        case .permissionDenied(let path):
            return "Permission denied: \(path)"
        case .operationFailed(let msg):
            return "SFTP operation failed: \(msg)"
        case .invalidLocalURL:
            return "Invalid local file URL"
        }
    }
}
