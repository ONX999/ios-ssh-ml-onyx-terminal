import XCTest
@testable import OnyxTerminal

final class SFTPClientTests: XCTestCase {
    
    var sftpClient: StubSFTPClient!
    
    override func setUp() {
        super.setUp()
        sftpClient = StubSFTPClient()
    }
    
    override func tearDown() {
        sftpClient = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertFalse(sftpClient.isConnected, "SFTP client should not be connected initially")
    }
    
    func testConnect() async throws {
        try await sftpClient.connect()
        XCTAssertTrue(sftpClient.isConnected, "SFTP client should be connected after connect()")
    }
    
    func testListDirectory() async throws {
        try await sftpClient.connect()
        
        let files = try await sftpClient.list(path: "/home/user")
        
        XCTAssertFalse(files.isEmpty, "Should return some files")
        XCTAssertTrue(files.contains { $0.filename == "." }, "Should contain current directory")
        XCTAssertTrue(files.contains { $0.filename == ".." }, "Should contain parent directory")
    }
    
    func testListWithoutConnection() async {
        do {
            _ = try await sftpClient.list(path: "/")
            XCTFail("Should throw error when not connected")
        } catch {
            XCTAssertTrue(error is SFTPError)
        }
    }
    
    func testDownload() async throws {
        try await sftpClient.connect()
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("txt")
        
        var progressCalled = false
        try await sftpClient.download(
            from: "/remote/file.txt",
            to: tempURL,
            progressHandler: { transferred, total in
                progressCalled = true
                XCTAssertLessThanOrEqual(transferred, total)
            }
        )
        
        XCTAssertTrue(progressCalled, "Progress handler should be called")
        XCTAssertTrue(FileManager.default.fileExists(atPath: tempURL.path), "File should be created")
        
        // Cleanup
        try? FileManager.default.removeItem(at: tempURL)
    }
    
    func testUpload() async throws {
        try await sftpClient.connect()
        
        // Create a test file
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("txt")
        let testData = "Test file content".data(using: .utf8)!
        try testData.write(to: tempURL)
        
        var progressCalled = false
        try await sftpClient.upload(
            from: tempURL,
            to: "/remote/uploaded.txt",
            progressHandler: { transferred, total in
                progressCalled = true
                XCTAssertLessThanOrEqual(transferred, total)
            }
        )
        
        XCTAssertTrue(progressCalled, "Progress handler should be called")
        
        // Cleanup
        try? FileManager.default.removeItem(at: tempURL)
    }
    
    func testMakeDirectory() async throws {
        try await sftpClient.connect()
        
        // Should not throw
        try await sftpClient.makeDirectory(at: "/remote/newdir")
    }
    
    func testRemove() async throws {
        try await sftpClient.connect()
        
        // Should not throw
        try await sftpClient.remove(path: "/remote/file.txt")
    }
    
    func testGetAttributes() async throws {
        try await sftpClient.connect()
        
        let attributes = try await sftpClient.getAttributes(path: "/remote/file.txt")
        
        XCTAssertNotNil(attributes.size, "Should have file size")
        XCTAssertNotNil(attributes.permissions, "Should have permissions")
    }
    
    func testClose() async throws {
        try await sftpClient.connect()
        XCTAssertTrue(sftpClient.isConnected)
        
        try await sftpClient.close()
        XCTAssertFalse(sftpClient.isConnected, "SFTP client should be disconnected after close()")
    }
}
