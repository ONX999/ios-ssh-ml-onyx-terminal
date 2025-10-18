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
    }
}
