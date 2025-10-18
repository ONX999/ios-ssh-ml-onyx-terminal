import Foundation

/// Default stub implementation of SFTPClient for testing and development
/// TODO: Replace with actual implementation using Shout/libssh2
public final class DefaultSFTPClient: SFTPClient {
    private var isConnected = true
    
    public init() {}
    
    public func list(path: String) async throws -> [SFTPFileInfo] {
        guard isConnected else {
            throw SFTPError.notConnected
        }
        
        // TODO: Implement actual directory listing
        // For now, return mock file list
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        return [
            SFTPFileInfo(filename: ".", isDirectory: true, size: 4096, permissions: 0o755),
            SFTPFileInfo(filename: "..", isDirectory: true, size: 4096, permissions: 0o755),
            SFTPFileInfo(filename: "Documents", isDirectory: true, size: 4096, permissions: 0o755),
            SFTPFileInfo(filename: "Downloads", isDirectory: true, size: 4096, permissions: 0o755),
            SFTPFileInfo(filename: "test.txt", isDirectory: false, size: 1024, permissions: 0o644),
            SFTPFileInfo(filename: "README.md", isDirectory: false, size: 2048, permissions: 0o644),
        ]
    }
    
    public func download(from remotePath: String, to localURL: URL) async throws {
        guard isConnected else {
            throw SFTPError.notConnected
        }
        
        // TODO: Implement actual file download
        // For now, create a stub file
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        let stubContent = "Stub content for file: \(remotePath)\n"
        try stubContent.write(to: localURL, atomically: true, encoding: .utf8)
    }
    
    public func upload(from localURL: URL, to remotePath: String) async throws {
        guard isConnected else {
            throw SFTPError.notConnected
        }
        
        guard FileManager.default.fileExists(atPath: localURL.path) else {
            throw SFTPError.invalidLocalURL
        }
        
        // TODO: Implement actual file upload
        // For now, just simulate delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
    }
    
    public func makeDirectory(at path: String) async throws {
        guard isConnected else {
            throw SFTPError.notConnected
        }
        
        // TODO: Implement actual directory creation
        // For now, just simulate delay
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
    }
    
    public func remove(path: String) async throws {
        guard isConnected else {
            throw SFTPError.notConnected
        }
        
        // TODO: Implement actual file/directory removal
        // For now, just simulate delay
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
    }
    
    public func exists(path: String) async throws -> Bool {
        guard isConnected else {
            throw SFTPError.notConnected
        }
        
        // TODO: Implement actual path existence check
        // For now, return true for common paths
        try await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        
        return ["/", "~", ".", ".."].contains(path) || path.starts(with: "/home/") || path.starts(with: "/Users/")
    }
    
    public func close() async throws {
        isConnected = false
    }
}
