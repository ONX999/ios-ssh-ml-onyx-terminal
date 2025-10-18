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
/// Unit tests for SFTP client protocol and default implementation
final class SFTPClientTests: XCTestCase {
    var sut: DefaultSFTPClient!
    
    override func setUp() {
        super.setUp()
        sut = DefaultSFTPClient()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testListDirectory() async throws {
        // Given: A connected SFTP client
        // When: Listing a directory
        let files = try await sut.list(path: "/home/user")
        
        // Then: Should return file list
        XCTAssertFalse(files.isEmpty)
        XCTAssertTrue(files.contains { $0.filename == "." })
        XCTAssertTrue(files.contains { $0.filename == ".." })
    }
    
    func testListDirectoryReturnsExpectedTypes() async throws {
        // Given: A connected SFTP client
        // When: Listing a directory
        let files = try await sut.list(path: "/")
        
        // Then: Should return both files and directories
        let directories = files.filter { $0.isDirectory }
        let regularFiles = files.filter { !$0.isDirectory }
        
        XCTAssertFalse(directories.isEmpty)
        XCTAssertFalse(regularFiles.isEmpty)
    }
    
    func testDownloadFile() async throws {
        // Given: A connected SFTP client and a temporary local path
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("test_download.txt")
        defer { try? FileManager.default.removeItem(at: tempURL) }
        
        // When: Downloading a file
        try await sut.download(from: "/remote/path/file.txt", to: tempURL)
        
        // Then: File should exist locally
        XCTAssertTrue(FileManager.default.fileExists(atPath: tempURL.path))
    }
    
    func testUploadFile() async throws {
        // Given: A connected SFTP client and a local file
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("test_upload.txt")
        try "Test content".write(to: tempURL, atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: tempURL) }
        
        // When: Uploading the file
        // Then: Should not throw error
        try await sut.upload(from: tempURL, to: "/remote/path/uploaded.txt")
    }
    
    func testUploadNonexistentFile() async {
        // Given: A connected SFTP client and a nonexistent local file
        let nonexistentURL = FileManager.default.temporaryDirectory.appendingPathComponent("nonexistent_\(UUID()).txt")
        
        // When: Attempting to upload
        // Then: Should throw error
        do {
            try await sut.upload(from: nonexistentURL, to: "/remote/path/file.txt")
            XCTFail("Should have thrown error")
        } catch let error as SFTPError {
            XCTAssertEqual(error, .invalidLocalURL)
        } catch {
            XCTFail("Wrong error type")
        }
    }
    
    func testMakeDirectory() async throws {
        // Given: A connected SFTP client
        // When: Creating a directory
        // Then: Should not throw error
        try await sut.makeDirectory(at: "/remote/path/newdir")
    }
    
    func testRemoveFile() async throws {
        // Given: A connected SFTP client
        // When: Removing a file
        // Then: Should not throw error
        try await sut.remove(path: "/remote/path/file.txt")
    }
    
    func testFileExists() async throws {
        // Given: A connected SFTP client
        // When: Checking if common paths exist
        let rootExists = try await sut.exists(path: "/")
        let homeExists = try await sut.exists(path: "~")
        
        // Then: Should return true for common paths
        XCTAssertTrue(rootExists)
        XCTAssertTrue(homeExists)
    }
    
    func testClose() async throws {
        // Given: A connected SFTP client
        // When: Closing the session
        try await sut.close()
        
        // Then: Should throw notConnected on subsequent operations
        do {
            _ = try await sut.list(path: "/")
            XCTFail("Should have thrown error")
        } catch let error as SFTPError {
            XCTAssertEqual(error, .notConnected)
        } catch {
            XCTFail("Wrong error type")
        }
    }
}
