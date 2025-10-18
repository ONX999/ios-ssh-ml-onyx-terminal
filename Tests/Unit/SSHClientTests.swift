import XCTest
import NIO
@testable import OnyxTerminal

final class SSHClientTests: XCTestCase {
    
    var sshClient: StubSSHClient!
    
    override func setUp() {
        super.setUp()
        sshClient = StubSSHClient()
    }
    
    override func tearDown() {
        sshClient = nil
@testable import OnyxTerminal

/// Unit tests for SSH client protocol and default implementation
final class SSHClientTests: XCTestCase {
    var sut: DefaultSSHClient!
    
    override func setUp() {
        super.setUp()
        sut = DefaultSSHClient()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertFalse(sshClient.isConnected, "SSH client should not be connected initially")
    }
    
    func testConnect() async throws {
        let config = SSHConnectionConfig(
            host: "test.example.com",
            port: 22,
            username: "testuser",
            authMethod: .password("testpass")
        )
        
        var receivedOutput = false
        sshClient.onStdout = { _ in
            receivedOutput = true
        }
        
        try await sshClient.connect(config)
        
        XCTAssertTrue(sshClient.isConnected, "SSH client should be connected after connect()")
        
        // Give some time for welcome message
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertTrue(receivedOutput, "Should receive welcome message on connect")
    }
    
    func testSendData() async throws {
        let config = SSHConnectionConfig(
            host: "test.example.com",
            port: 22,
            username: "testuser",
            authMethod: .password("testpass")
        )
        
        try await sshClient.connect(config)
        
        var receivedData: [UInt8]?
        sshClient.onStdout = { buffer in
            var buf = buffer
            receivedData = buf.readBytes(length: buf.readableBytes)
        }
        
        let testCommand = "echo test\n"
        var sendBuffer = ByteBufferAllocator().buffer(capacity: testCommand.utf8.count)
        sendBuffer.writeString(testCommand)
        
        sshClient.send(sendBuffer)
        
        // Give some time for echo
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertNotNil(receivedData, "Should receive echoed data")
    }
    
    func testDisconnect() async throws {
        let config = SSHConnectionConfig(
            host: "test.example.com",
            port: 22,
            username: "testuser",
            authMethod: .password("testpass")
        )
        
        try await sshClient.connect(config)
        XCTAssertTrue(sshClient.isConnected)
        
        try await sshClient.close()
        XCTAssertFalse(sshClient.isConnected, "SSH client should be disconnected after close()")
    }
    
    func testOpenSFTPSession() async throws {
        let config = SSHConnectionConfig(
            host: "test.example.com",
            port: 22,
            username: "testuser",
            authMethod: .password("testpass")
        )
        
        try await sshClient.connect(config)
        
        let sftpClient = try await sshClient.openSFTPSession()
        XCTAssertTrue(sftpClient.isConnected, "SFTP client should be connected")
    }
    
    func testOpenSFTPWithoutConnection() async {
        do {
            _ = try await sshClient.openSFTPSession()
            XCTFail("Should throw error when not connected")
        } catch {
            // Expected error
            XCTAssertTrue(error is SSHError)
        }
        // Given: A newly created SSH client
        // When: Checking initial state
        // Then: State should be idle
        XCTAssertEqual(sut.state, .idle)
    }
    
    func testConnectSuccess() async throws {
        // Given: A valid SSH configuration
        let config = SSHConnectionConfig(
            host: "test.example.com",
            port: 22,
            username: "testuser"
        )
        
        // When: Connecting to the server
        try await sut.connect(config: config)
        
        // Then: State should be connected
        XCTAssertEqual(sut.state, .connected)
    }
    
    func testAuthenticateWithPassword() async throws {
        // Given: A connected SSH client
        let config = SSHConnectionConfig(
            host: "test.example.com",
            port: 22,
            username: "testuser"
        )
        try await sut.connect(config: config)
        
        // When: Authenticating with password
        try await sut.authenticate(withPassword: "testpassword")
        
        // Then: No error should be thrown
        XCTAssertEqual(sut.state, .connected)
    }
    
    func testAuthenticateWithoutConnection() async {
        // Given: An unconnected SSH client
        // When: Attempting to authenticate
        // Then: Should throw notConnected error
        do {
            try await sut.authenticate(withPassword: "password")
            XCTFail("Should have thrown error")
        } catch let error as SSHClientError {
            XCTAssertEqual(error, .notConnected)
        } catch {
            XCTFail("Wrong error type")
        }
    }
    
    func testExecuteCommand() async throws {
        // Given: A connected SSH client
        let config = SSHConnectionConfig(
            host: "test.example.com",
            port: 22,
            username: "testuser"
        )
        try await sut.connect(config: config)
        
        // When: Executing a command
        let result = try await sut.execute(command: "ls -la")
        
        // Then: Should return a response
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.contains("ls -la"))
    }
    
    func testOpenSFTPSession() async throws {
        // Given: A connected SSH client
        let config = SSHConnectionConfig(
            host: "test.example.com",
            port: 22,
            username: "testuser"
        )
        try await sut.connect(config: config)
        
        // When: Opening SFTP session
        let sftpClient = try await sut.openSFTPSession()
        
        // Then: Should return a valid SFTP client
        XCTAssertNotNil(sftpClient)
    }
    
    func testClose() async throws {
        // Given: A connected SSH client
        let config = SSHConnectionConfig(
            host: "test.example.com",
            port: 22,
            username: "testuser"
        )
        try await sut.connect(config: config)
        
        // When: Closing the connection
        try await sut.close()
        
        // Then: State should be closed
        XCTAssertEqual(sut.state, .closed)
    }
}
