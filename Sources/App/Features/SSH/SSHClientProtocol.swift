import Foundation
import NIO

/// Authentication method for SSH connection
public enum SSHAuthMethod {
    case password(String)
    case privateKey(Data, passphrase: String?)
}

/// SSH connection configuration
public struct SSHConnectionConfig {
    public let host: String
    public let port: Int
    public let username: String
    public let authMethod: SSHAuthMethod
    public let terminalType: String
    public let cols: Int
    public let rows: Int
    
    public init(
        host: String,
        port: Int = 22,
        username: String,
        authMethod: SSHAuthMethod,
        terminalType: String = "xterm-256color",
        cols: Int = 120,
        rows: Int = 30
    ) {
        self.host = host
        self.port = port
        self.username = username
        self.authMethod = authMethod
        self.terminalType = terminalType
        self.cols = cols
        self.rows = rows
    }
}

/// Protocol defining SSH client capabilities
public protocol SSHClientProtocol {
    /// Connection state
    var isConnected: Bool { get }
    
    /// Callback for stdout data
    var onStdout: ((ByteBuffer) -> Void)? { get set }
    
    /// Callback for stderr data
    var onStderr: ((ByteBuffer) -> Void)? { get set }
    
    /// Callback for errors
    var onError: ((Error) -> Void)? { get set }
    
    /// Connect to SSH server
    /// - Parameter config: Connection configuration
    func connect(_ config: SSHConnectionConfig) async throws
    
    /// Send data to the SSH session
    /// - Parameter data: Data to send
    func send(_ data: ByteBuffer)
    
    /// Resize the terminal window
    /// - Parameters:
    ///   - cols: Number of columns
    ///   - rows: Number of rows
    func resize(cols: Int, rows: Int)
    
    /// Close the SSH connection
    func close() async throws
    
    /// Open an SFTP session over this SSH connection
    /// - Returns: SFTP client instance
    /// - Note: This is a TODO for future implementation
    func openSFTPSession() async throws -> SFTPClientProtocol
}
