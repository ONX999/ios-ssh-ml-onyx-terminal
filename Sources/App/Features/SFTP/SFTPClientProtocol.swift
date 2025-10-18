import Foundation

/// File attributes for SFTP operations
public struct SFTPFileAttributes {
    public let size: UInt64?
    public let permissions: UInt32?
    public let uid: UInt32?
    public let gid: UInt32?
    public let modificationTime: Date?
    public let accessTime: Date?
    public let isDirectory: Bool
    public let isSymlink: Bool
    
    public init(
        size: UInt64? = nil,
        permissions: UInt32? = nil,
        uid: UInt32? = nil,
        gid: UInt32? = nil,
        modificationTime: Date? = nil,
        accessTime: Date? = nil,
        isDirectory: Bool = false,
        isSymlink: Bool = false
    ) {
        self.size = size
        self.permissions = permissions
        self.uid = uid
        self.gid = gid
        self.modificationTime = modificationTime
        self.accessTime = accessTime
        self.isDirectory = isDirectory
        self.isSymlink = isSymlink
    }
}

/// File entry in SFTP directory listing
public struct SFTPFileEntry {
    public let filename: String
    public let attributes: SFTPFileAttributes
    
    public init(filename: String, attributes: SFTPFileAttributes) {
        self.filename = filename
        self.attributes = attributes
    }
}

/// Protocol defining SFTP client capabilities
public protocol SFTPClientProtocol {
    /// Whether the SFTP session is connected
    var isConnected: Bool { get }
    
    /// List files in a directory
    /// - Parameter path: Remote directory path
    /// - Returns: Array of file entries
    func list(path: String) async throws -> [SFTPFileEntry]
    
    /// Download a file from remote to local
    /// - Parameters:
    ///   - remotePath: Path to remote file
    ///   - localURL: Local URL to save file
    ///   - progressHandler: Optional progress callback (bytes transferred, total bytes)
    func download(from remotePath: String, to localURL: URL, progressHandler: ((UInt64, UInt64) -> Void)?) async throws
    
    /// Upload a file from local to remote
    /// - Parameters:
    ///   - localURL: Local file URL
    ///   - remotePath: Remote path to save file
    ///   - progressHandler: Optional progress callback (bytes transferred, total bytes)
    func upload(from localURL: URL, to remotePath: String, progressHandler: ((UInt64, UInt64) -> Void)?) async throws
    
    /// Create a directory on remote server
    /// - Parameter path: Path of directory to create
    func makeDirectory(at path: String) async throws
    
    /// Remove a file or directory on remote server
    /// - Parameter path: Path to remove
    func remove(path: String) async throws
    
    /// Get file attributes
    /// - Parameter path: Remote file path
    /// - Returns: File attributes
    func getAttributes(path: String) async throws -> SFTPFileAttributes
    
    /// Close the SFTP session
    func close() async throws
}
