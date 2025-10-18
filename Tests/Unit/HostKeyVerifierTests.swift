import XCTest
@testable import OnyxTerminal

/// Unit tests for HostKeyVerifier
final class HostKeyVerifierTests: XCTestCase {
    var sut: DefaultHostKeyVerifier!
    
    override func setUp() {
        super.setUp()
        sut = DefaultHostKeyVerifier()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testVerifyUnknownHost() async throws {
        // Given: A host that hasn't been seen before
        let publicKey = "test_key".data(using: .utf8)!
        
        // When: Verifying the host
        let result = try await sut.verify(host: "unknown.example.com", port: 22, publicKey: publicKey)
        
        // Then: Should return unknown
        if case .unknown = result {
            // Success
        } else {
            XCTFail("Expected unknown result")
        }
    }
    
    func testAddAndVerifyKnownHost() async throws {
        // Given: A new host key
        let host = "test.example.com"
        let port = 22
        let publicKey = "test_key_data".data(using: .utf8)!
        
        // When: Adding the host and then verifying
        try await sut.addKnownHost(host: host, port: port, publicKey: publicKey)
        let result = try await sut.verify(host: host, port: port, publicKey: publicKey)
        
        // Then: Should return trusted
        if case .trusted = result {
            // Success
        } else {
            XCTFail("Expected trusted result")
        }
    }
    
    func testVerifyChangedHostKey() async throws {
        // Given: A known host with a specific key
        let host = "test.example.com"
        let port = 22
        let originalKey = "original_key".data(using: .utf8)!
        let newKey = "different_key".data(using: .utf8)!
        
        try await sut.addKnownHost(host: host, port: port, publicKey: originalKey)
        
        // When: Verifying with a different key
        let result = try await sut.verify(host: host, port: port, publicKey: newKey)
        
        // Then: Should return changed with old key
        if case .changed(let oldKey) = result {
            XCTAssertEqual(oldKey, originalKey)
        } else {
            XCTFail("Expected changed result")
        }
    }
    
    func testRemoveKnownHost() async throws {
        // Given: A known host
        let host = "test.example.com"
        let port = 22
        let publicKey = "test_key".data(using: .utf8)!
        
        try await sut.addKnownHost(host: host, port: port, publicKey: publicKey)
        
        // When: Removing the host
        try await sut.removeKnownHost(host: host, port: port)
        let result = try await sut.verify(host: host, port: port, publicKey: publicKey)
        
        // Then: Should return unknown
        if case .unknown = result {
            // Success
        } else {
            XCTFail("Expected unknown result after removal")
        }
    }
    
    func testGetAllKnownHosts() async throws {
        // Given: Multiple known hosts
        try await sut.addKnownHost(host: "host1.example.com", port: 22, publicKey: "key1".data(using: .utf8)!)
        try await sut.addKnownHost(host: "host2.example.com", port: 2222, publicKey: "key2".data(using: .utf8)!)
        try await sut.addKnownHost(host: "host3.example.com", port: 22, publicKey: "key3".data(using: .utf8)!)
        
        // When: Getting all known hosts
        let hosts = try await sut.getAllKnownHosts()
        
        // Then: Should return all added hosts
        XCTAssertEqual(hosts.count, 3)
        XCTAssertTrue(hosts.contains { $0.host == "host1.example.com" })
        XCTAssertTrue(hosts.contains { $0.host == "host2.example.com" })
        XCTAssertTrue(hosts.contains { $0.host == "host3.example.com" })
    }
    
    func testDifferentPortsAreSeparate() async throws {
        // Given: Same host on different ports
        let host = "test.example.com"
        let key22 = "key_22".data(using: .utf8)!
        let key2222 = "key_2222".data(using: .utf8)!
        
        try await sut.addKnownHost(host: host, port: 22, publicKey: key22)
        try await sut.addKnownHost(host: host, port: 2222, publicKey: key2222)
        
        // When: Verifying both ports
        let result22 = try await sut.verify(host: host, port: 22, publicKey: key22)
        let result2222 = try await sut.verify(host: host, port: 2222, publicKey: key2222)
        
        // Then: Both should be trusted independently
        if case .trusted = result22 {
            // Success
        } else {
            XCTFail("Port 22 should be trusted")
        }
        
        if case .trusted = result2222 {
            // Success
        } else {
            XCTFail("Port 2222 should be trusted")
        }
    }
}
