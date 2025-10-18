import XCTest
@testable import OnyxTerminal

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
