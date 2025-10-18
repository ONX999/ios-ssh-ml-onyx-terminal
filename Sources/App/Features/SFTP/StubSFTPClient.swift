import Foundation

/// Stub implementation of SFTP client for testing and development
/// TODO: Replace with real SFTP implementation using libssh2 or compatible library
public final class StubSFTPClient: SFTPClientProtocol {
    public private(set) var isConnected: Bool = false
    
    // Simulated file system
    private var fileSystem: [String: SFTPFileEntry] = [:]
    
    public init() {
        setupMockFileSystem()
    }
    
    func connect() async throws {
        // Simulate connection delay
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        isConnected = true
    }
    
    public func list(path: String) async throws -> [SFTPFileEntry] {
        guard isConnected else {
            throw SFTPError.notConnected
        }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Return mock directory listing
        return [
            SFTPFileEntry(
                filename: ".",
                attributes: SFTPFileAttributes(
                    size: 4096,
                    permissions: 0o755,
                    isDirectory: true
                )
            ),
            SFTPFileEntry(
                filename: "..",
                attributes: SFTPFileAttributes(
                    size: 4096,
                    permissions: 0o755,
                    isDirectory: true
                )
            ),
            SFTPFileEntry(
                filename: "documents",
                attributes: SFTPFileAttributes(
                    size: 4096,
                    permissions: 0o755,
                    isDirectory: true
                )
            ),
            SFTPFileEntry(
                filename: "README.txt",
                attributes: SFTPFileAttributes(
                    size: 1024,
                    permissions: 0o644,
                    isDirectory: false
                )
            ),
            SFTPFileEntry(
                filename: "script.sh",
                attributes: SFTPFileAttributes(
                    size: 512,
                    permissions: 0o755,
                    isDirectory: false
                )
            )
        ]
    }
    
    public func download(from remotePath: String, to localURL: URL, progressHandler: ((UInt64, UInt64) -> Void)?) async throws {
        guard isConnected else {
            throw SFTPError.notConnected
        }
        
        // Simulate download with progress
        let totalSize: UInt64 = 1024 * 10 // 10 KB
        let chunkSize: UInt64 = 1024
        
        var downloaded: UInt64 = 0
        while downloaded < totalSize {
            try await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds per chunk
            downloaded += chunkSize
            progressHandler?(min(downloaded, totalSize), totalSize)
        }
        
        // Create a dummy file
        let dummyData = "This is a stub downloaded file from SFTP.\n".data(using: .utf8)!
        try dummyData.write(to: localURL)
    }
    
    public func upload(from localURL: URL, to remotePath: String, progressHandler: ((UInt64, UInt64) -> Void)?) async throws {
        guard isConnected else {
            throw SFTPError.notConnected
        }
        
        // Read file size
        let attributes = try FileManager.default.attributesOfItem(atPath: localURL.path)
        let fileSize = attributes[.size] as? UInt64 ?? 0
        
        // Simulate upload with progress
        let chunkSize: UInt64 = 1024
        var uploaded: UInt64 = 0
        
        while uploaded < fileSize {
            try await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds per chunk
            uploaded += chunkSize
            progressHandler?(min(uploaded, fileSize), fileSize)
        }
    }
    
    public func makeDirectory(at path: String) async throws {
        guard isConnected else {
            throw SFTPError.notConnected
        }
        
        // Simulate operation delay
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Store in mock file system
        let entry = SFTPFileEntry(
            filename: (path as NSString).lastPathComponent,
            attributes: SFTPFileAttributes(
                size: 4096,
                permissions: 0o755,
                isDirectory: true
            )
        )
        fileSystem[path] = entry
    }
    
    public func remove(path: String) async throws {
        guard isConnected else {
            throw SFTPError.notConnected
        }
        
        // Simulate operation delay
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Remove from mock file system
        fileSystem.removeValue(forKey: path)
    }
    
    public func getAttributes(path: String) async throws -> SFTPFileAttributes {
        guard isConnected else {
            throw SFTPError.notConnected
        }
        
        // Return mock attributes
        return SFTPFileAttributes(
            size: 1024,
            permissions: 0o644,
            modificationTime: Date(),
            accessTime: Date(),
            isDirectory: false,
            isSymlink: false
        )
    }
    
    public func close() async throws {
        isConnected = false
        fileSystem.removeAll()
    }
    
    // MARK: - Private Helpers
    
    private func setupMockFileSystem() {
        // Pre-populate with some mock entries
        fileSystem = [:]
    }
}

public enum SFTPError: Error, LocalizedError {
    case notConnected
    case invalidPath
    case fileNotFound
    case permissionDenied
    case operationFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .notConnected:
            return "SFTP not connected"
        case .invalidPath:
            return "Invalid path"
        case .fileNotFound:
            return "File not found"
        case .permissionDenied:
            return "Permission denied"
        case .operationFailed(let reason):
            return "SFTP operation failed: \(reason)"
        }
    }
}
