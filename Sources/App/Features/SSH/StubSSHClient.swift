import Foundation
import NIO

/// Stub implementation of SSH client for testing and development
/// TODO: Replace with real SSH implementation using libssh2 or SwiftNIO-SSH
public final class StubSSHClient: SSHClientProtocol {
    public var isConnected: Bool = false
    public var onStdout: ((ByteBuffer) -> Void)?
    public var onStderr: ((ByteBuffer) -> Void)?
    public var onError: ((Error) -> Void)?
    
    private var config: SSHConnectionConfig?
    private var simulationTask: Task<Void, Never>?
    
    public init() {}
    
    public func connect(_ config: SSHConnectionConfig) async throws {
        self.config = config
        
        // Simulate connection delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        self.isConnected = true
        
        // Simulate welcome message
        await sendWelcomeMessage()
    }
    
    public func send(_ data: ByteBuffer) {
        guard isConnected else { return }
        
        // Echo back the input (simulated)
        var buffer = data
        if let bytes = buffer.readBytes(length: buffer.readableBytes) {
            let echoBuffer = ByteBufferAllocator().buffer(bytes: bytes)
            onStdout?(echoBuffer)
        }
    }
    
    public func resize(cols: Int, rows: Int) {
        // Stub: No-op for now
        // TODO: Implement actual terminal resize
    }
    
    public func close() async throws {
        simulationTask?.cancel()
        simulationTask = nil
        isConnected = false
    }
    
    public func openSFTPSession() async throws -> SFTPClientProtocol {
        guard isConnected else {
            throw SSHError.notConnected
        }
        
        // Return stub SFTP client
        let sftpClient = StubSFTPClient()
        try await sftpClient.connect()
        return sftpClient
    }
    
    // MARK: - Private Helpers
    
    private func sendWelcomeMessage() async {
        let welcomeText = """
        Welcome to Onyx Terminal (Stub Mode)
        Connected to \(config?.host ?? "unknown")
        
        This is a stub SSH client for testing purposes.
        Type commands and they will be echoed back.
        
        TODO: Implement real SSH/PTY integration
        
        $ 
        """
        
        var buffer = ByteBufferAllocator().buffer(capacity: welcomeText.utf8.count)
        buffer.writeString(welcomeText)
        onStdout?(buffer)
    }
}

public enum SSHError: Error, LocalizedError {
    case notConnected
    case authenticationFailed
    case connectionFailed(String)
    case channelOpenFailed
    
    public var errorDescription: String? {
        switch self {
        case .notConnected:
            return "SSH not connected"
        case .authenticationFailed:
            return "Authentication failed"
        case .connectionFailed(let reason):
            return "Connection failed: \(reason)"
        case .channelOpenFailed:
            return "Failed to open SSH channel"
        }
    }
}
