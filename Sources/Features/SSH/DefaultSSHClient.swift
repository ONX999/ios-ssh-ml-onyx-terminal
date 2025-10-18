import Foundation
import NIO

/// Default stub implementation of SSHClient for testing and development
/// TODO: Replace with actual implementation using libssh2/SwiftNIO-SSH
public final class DefaultSSHClient: SSHClient {
    public private(set) var state: SSHConnectionState = .idle
    
    private var currentConfig: SSHConnectionConfig?
    private var mockSFTPClient: DefaultSFTPClient?
    
    public var onStdout: ((ByteBuffer) -> Void)?
    public var onStderr: ((ByteBuffer) -> Void)?
    public var onError: ((Error) -> Void)?
    
    public init() {}
    
    public func connect(config: SSHConnectionConfig) async throws {
        guard state == .idle || state == .closed else {
            throw SSHClientError.connectionFailed("Already connected or connecting")
        }
        
        state = .connecting
        currentConfig = config
        
        // Simulate connection delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // TODO: Implement actual SSH connection using SwiftNIO-SSH or libssh2
        // For now, this is a stub implementation
        
        state = .connected
        
        // Send mock welcome message
        if let onStdout = onStdout {
            var buffer = ByteBufferAllocator().buffer(capacity: 100)
            let welcomeMsg = "Connected to \(config.host) (stub mode)\r\n$ "
            buffer.writeString(welcomeMsg)
            onStdout(buffer)
        }
    }
    
    public func authenticate(withPassword password: String) async throws {
        guard state == .connected else {
            throw SSHClientError.notConnected
        }
        
        // TODO: Implement password authentication
        // For now, accept any password
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
    }
    
    public func authenticate(withKey privateKey: Data, passphrase: String?) async throws {
        guard state == .connected else {
            throw SSHClientError.notConnected
        }
        
        // TODO: Implement key-based authentication
        // For now, accept any key
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
    }
    
    public func execute(command: String) async throws -> String {
        guard state == .connected else {
            throw SSHClientError.notConnected
        }
        
        // TODO: Implement actual command execution
        // For now, return mock response
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        return "Stub response for command: \(command)\r\n"
    }
    
    public func openSFTPSession() async throws -> SFTPClient {
        guard state == .connected else {
            throw SSHClientError.notConnected
        }
        
        // TODO: Implement actual SFTP session opening
        // For now, return stub SFTP client
        let sftpClient = DefaultSFTPClient()
        mockSFTPClient = sftpClient
        return sftpClient
    }
    
    public func send(data: ByteBuffer) {
        guard state == .connected else { return }
        
        // TODO: Implement actual data sending
        // For now, echo back the data
        if let onStdout = onStdout {
            onStdout(data)
        }
    }
    
    public func resize(cols: Int, rows: Int) {
        guard state == .connected else { return }
        
        // TODO: Implement terminal resize
        // For now, just log
        print("Terminal resized to \(cols)x\(rows) (stub)")
    }
    
    public func close() async throws {
        mockSFTPClient = nil
        currentConfig = nil
        state = .closed
    }
}
