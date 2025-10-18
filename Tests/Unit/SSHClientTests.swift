import XCTest
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
