import Foundation
import NIO

/// Protocol defining SSH client capabilities for connecting to remote servers
public protocol SSHClient {
    /// Connection state
    var state: SSHConnectionState { get }
    
    /// Connect to SSH server
    /// - Parameter config: SSH connection configuration
    /// - Throws: SSHClientError if connection fails
    func connect(config: SSHConnectionConfig) async throws
    
    /// Authenticate with password
    /// - Parameters:
    ///   - username: SSH username
    ///   - password: SSH password
    /// - Throws: SSHClientError if authentication fails
    func authenticate(withPassword password: String) async throws
    
    /// Authenticate with private key
    /// - Parameters:
    ///   - username: SSH username
    ///   - privateKey: Private key data
    ///   - passphrase: Optional passphrase for encrypted keys
    /// - Throws: SSHClientError if authentication fails
    func authenticate(withKey privateKey: Data, passphrase: String?) async throws
    
    /// Execute a command on the remote server
    /// - Parameter command: Command to execute
    /// - Returns: Command output
    /// - Throws: SSHClientError if execution fails
    func execute(command: String) async throws -> String
    
    /// Open an SFTP session
    /// - Returns: SFTPClient instance
    /// - Throws: SSHClientError if SFTP session cannot be opened
    func openSFTPSession() async throws -> SFTPClient
    
    /// Send data to the SSH channel
    /// - Parameter data: Data to send
    func send(data: ByteBuffer)
    
    /// Resize the terminal window
    /// - Parameters:
    ///   - cols: Number of columns
    ///   - rows: Number of rows
    func resize(cols: Int, rows: Int)
    
    /// Close the SSH connection
    func close() async throws
}

/// SSH connection configuration
public struct SSHConnectionConfig {
    public var host: String
    public var port: Int
    public var username: String
    public var terminalType: String
    public var cols: Int
    public var rows: Int
    
    public init(host: String, port: Int = 22, username: String, terminalType: String = "xterm-256color", cols: Int = 120, rows: Int = 30) {
        self.host = host
        self.port = port
        self.username = username
        self.terminalType = terminalType
        self.cols = cols
        self.rows = rows
    }
}

/// SSH connection states
public enum SSHConnectionState {
    case idle
    case connecting
    case connected
    case closed
}

/// SSH client errors
public enum SSHClientError: Error, LocalizedError {
    case notConnected
    case connectionFailed(String)
    case authenticationFailed(String)
    case executionFailed(String)
    case unsupportedChannelType
    case invalidConfiguration
    
    public var errorDescription: String? {
        switch self {
        case .notConnected:
            return "SSH client is not connected"
        case .connectionFailed(let msg):
            return "Connection failed: \(msg)"
        case .authenticationFailed(let msg):
            return "Authentication failed: \(msg)"
        case .executionFailed(let msg):
            return "Command execution failed: \(msg)"
        case .unsupportedChannelType:
            return "Unsupported channel type"
        case .invalidConfiguration:
            return "Invalid SSH configuration"
        }
    }
}
