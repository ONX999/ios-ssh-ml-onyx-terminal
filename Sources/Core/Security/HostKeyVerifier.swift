import Foundation

/// Protocol for verifying SSH host keys (known_hosts functionality)
public protocol HostKeyVerifier {
    /// Verify a host key against known hosts
    /// - Parameters:
    ///   - host: Hostname or IP address
    ///   - port: Port number
    ///   - publicKey: Host's public key
    /// - Returns: Verification result
    /// - Throws: HostKeyError if verification fails
    func verify(host: String, port: Int, publicKey: Data) async throws -> HostKeyVerificationResult
    
    /// Add a host key to known hosts
    /// - Parameters:
    ///   - host: Hostname or IP address
    ///   - port: Port number
    ///   - publicKey: Host's public key
    /// - Throws: HostKeyError if addition fails
    func addKnownHost(host: String, port: Int, publicKey: Data) async throws
    
    /// Remove a host key from known hosts
    /// - Parameters:
    ///   - host: Hostname or IP address
    ///   - port: Port number
    /// - Throws: HostKeyError if removal fails
    func removeKnownHost(host: String, port: Int) async throws
    
    /// Get all known hosts
    /// - Returns: Array of known host entries
    func getAllKnownHosts() async throws -> [KnownHostEntry]
}

/// Result of host key verification
public enum HostKeyVerificationResult {
    case trusted           // Key matches known host
    case unknown           // Host not in known_hosts
    case changed(Data)     // Key has changed (possible MITM attack) - includes old key
}

/// Entry in the known hosts database
public struct KnownHostEntry {
    public let host: String
    public let port: Int
    public let publicKey: Data
    public let addedDate: Date
    
    public init(host: String, port: Int, publicKey: Data, addedDate: Date = Date()) {
        self.host = host
        self.port = port
        self.publicKey = publicKey
        self.addedDate = addedDate
    }
}

/// Host key verification errors
public enum HostKeyError: Error, LocalizedError {
    case verificationFailed(String)
    case invalidKey
    case storageError(String)
    
    public var errorDescription: String? {
        switch self {
        case .verificationFailed(let msg):
            return "Host key verification failed: \(msg)"
        case .invalidKey:
            return "Invalid host key format"
        case .storageError(let msg):
            return "Host key storage error: \(msg)"
        }
    }
}

/// Default implementation of HostKeyVerifier
/// TODO: Implement actual known_hosts storage and verification
public final class DefaultHostKeyVerifier: HostKeyVerifier {
    private var knownHosts: [String: KnownHostEntry] = [:]
    
    public init() {}
    
    private func makeKey(host: String, port: Int) -> String {
        return "\(host):\(port)"
    }
    
    public func verify(host: String, port: Int, publicKey: Data) async throws -> HostKeyVerificationResult {
        // TODO: Implement actual host key verification against persistent storage
        // For now, use in-memory storage
        
        let key = makeKey(host: host, port: port)
        
        if let known = knownHosts[key] {
            if known.publicKey == publicKey {
                return .trusted
            } else {
                return .changed(known.publicKey)
            }
        } else {
            return .unknown
        }
    }
    
    public func addKnownHost(host: String, port: Int, publicKey: Data) async throws {
        // TODO: Implement persistent storage (UserDefaults, Keychain, or file-based)
        // For now, use in-memory storage
        
        let key = makeKey(host: host, port: port)
        let entry = KnownHostEntry(host: host, port: port, publicKey: publicKey)
        knownHosts[key] = entry
        
        print("Stub: Added known host \(host):\(port)")
    }
    
    public func removeKnownHost(host: String, port: Int) async throws {
        // TODO: Implement persistent storage removal
        // For now, use in-memory storage
        
        let key = makeKey(host: host, port: port)
        knownHosts.removeValue(forKey: key)
        
        print("Stub: Removed known host \(host):\(port)")
    }
    
    public func getAllKnownHosts() async throws -> [KnownHostEntry] {
        // TODO: Implement persistent storage retrieval
        // For now, return in-memory data
        
        return Array(knownHosts.values).sorted { $0.host < $1.host }
    }
}
