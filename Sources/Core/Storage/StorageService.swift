import Foundation

/// Protocol for managing persistent storage
public protocol StorageService {
    /// Save a value for a key
    /// - Parameters:
    ///   - value: Value to save (must be Codable)
    ///   - key: Storage key
    /// - Throws: StorageError if save fails
    func save<T: Codable>(_ value: T, forKey key: String) throws
    
    /// Retrieve a value for a key
    /// - Parameter key: Storage key
    /// - Returns: The saved value, or nil if not found
    /// - Throws: StorageError if retrieval fails
    func load<T: Codable>(forKey key: String) throws -> T?
    
    /// Remove a value for a key
    /// - Parameter key: Storage key
    /// - Throws: StorageError if deletion fails
    func remove(forKey key: String) throws
    
    /// Check if a value exists for a key
    /// - Parameter key: Storage key
    /// - Returns: True if value exists
    func exists(forKey key: String) -> Bool
    
    /// Clear all stored values
    /// - Throws: StorageError if clear fails
    func clearAll() throws
}

/// Storage errors
public enum StorageError: Error, LocalizedError {
    case encodingFailed(String)
    case decodingFailed(String)
    case saveFailed(String)
    case loadFailed(String)
    case deleteFailed(String)
    case notFound(String)
    
    public var errorDescription: String? {
        switch self {
        case .encodingFailed(let msg):
            return "Failed to encode data: \(msg)"
        case .decodingFailed(let msg):
            return "Failed to decode data: \(msg)"
        case .saveFailed(let msg):
            return "Failed to save data: \(msg)"
        case .loadFailed(let msg):
            return "Failed to load data: \(msg)"
        case .deleteFailed(let msg):
            return "Failed to delete data: \(msg)"
        case .notFound(let key):
            return "Data not found for key: \(key)"
        }
    }
}

/// UserDefaults-based storage implementation
/// TODO: Consider using Core Data or file-based storage for complex objects
public final class UserDefaultsStorageService: StorageService {
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    public func save<T: Codable>(_ value: T, forKey key: String) throws {
        do {
            let data = try encoder.encode(value)
            userDefaults.set(data, forKey: key)
        } catch {
            throw StorageError.encodingFailed(error.localizedDescription)
        }
    }
    
    public func load<T: Codable>(forKey key: String) throws -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw StorageError.decodingFailed(error.localizedDescription)
        }
    }
    
    public func remove(forKey key: String) throws {
        userDefaults.removeObject(forKey: key)
    }
    
    public func exists(forKey key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
    
    public func clearAll() throws {
        // Note: This clears ALL UserDefaults, use with caution
        // In production, consider maintaining a list of app-specific keys
        if let bundleID = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundleID)
        }
    }
}

/// In-memory storage implementation for testing
public final class InMemoryStorageService: StorageService {
    private var storage: [String: Data] = [:]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init() {}
    
    public func save<T: Codable>(_ value: T, forKey key: String) throws {
        do {
            let data = try encoder.encode(value)
            storage[key] = data
        } catch {
            throw StorageError.encodingFailed(error.localizedDescription)
        }
    }
    
    public func load<T: Codable>(forKey key: String) throws -> T? {
        guard let data = storage[key] else {
            return nil
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw StorageError.decodingFailed(error.localizedDescription)
        }
    }
    
    public func remove(forKey key: String) throws {
        storage.removeValue(forKey: key)
    }
    
    public func exists(forKey key: String) -> Bool {
        return storage[key] != nil
    }
    
    public func clearAll() throws {
        storage.removeAll()
    }
}
