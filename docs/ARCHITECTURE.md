# Architecture Overview

Onyx Terminal follows a clean, modular architecture designed for testability and maintainability.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     SwiftUI Views                        │
│            (TerminalScreen, QuickActionsBar)            │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                    View Models                           │
│              (SSHTerminalSession)                        │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                    Protocols                             │
│     (SSHClientProtocol, SFTPClientProtocol, etc.)       │
└─────────────────────────────────────────────────────────┘
                            │
            ┌───────────────┴───────────────┐
            ▼                               ▼
┌──────────────────────┐       ┌──────────────────────┐
│  Real Implementations│       │  Stub Implementations│
│  (NIOSSHClient,      │       │  (StubSSHClient,     │
│   SFTPService)       │       │   StubSFTPClient)    │
└──────────────────────┘       └──────────────────────┘
```

## Directory Structure

```
Sources/App/
├── Features/              # Feature modules
│   ├── SSH/              # SSH-related functionality
│   │   ├── SSHClientProtocol.swift
│   │   ├── NIOSSHClientAdapter.swift
│   │   ├── StubSSHClient.swift
│   │   └── SSHConnection.swift
│   ├── SFTP/             # SFTP-related functionality
│   │   ├── SFTPClientProtocol.swift
│   │   ├── SFTPServiceAdapter.swift
│   │   └── StubSFTPClient.swift
│   └── TerminalUI/       # Terminal UI components
│       ├── TerminalScreen.swift
│       ├── SSHTerminalSession.swift
│       └── QuickActionsBar.swift
├── Core/                 # Core functionality
│   ├── Networking/       # Network utilities
│   ├── Security/         # Security services
│   │   ├── KeychainService.swift
│   │   └── HostKeyVerifier.swift
│   ├── Storage/          # Data persistence
│   │   └── DocumentPickers.swift
│   └── DesignSystem/     # UI design system
├── Resources/            # Assets and localization
│   ├── Assets.xcassets/
│   ├── en.lproj/
│   └── zh-Hant.lproj/
└── TerminalCLIApp.swift  # App entry point
```

## Design Patterns

### 1. Protocol-Oriented Programming

All major components are defined as protocols first:

```swift
public protocol SSHClientProtocol {
    var isConnected: Bool { get }
    func connect(_ config: SSHConnectionConfig) async throws
    func send(_ data: ByteBuffer)
    func close() async throws
}
```

**Benefits:**
- Easy to mock for testing
- Flexible implementation swapping
- Clear contracts between components

### 2. Adapter Pattern

Existing implementations are wrapped in adapters:

```swift
public final class NIOSSHClientAdapter: SSHClientProtocol {
    private let client = NIOSSHClient()
    // Adapter implementation...
}
```

**Benefits:**
- Doesn't break existing code
- Provides protocol compliance
- Allows gradual migration

### 3. MVVM (Model-View-ViewModel)

```swift
// View
struct TerminalScreen: View {
    @StateObject private var terminal = SSHTerminalSession()
    // ...
}

// ViewModel
final class SSHTerminalSession: ObservableObject {
    @Published var isConnected = false
    private let sshClient: SSHClientProtocol
    // ...
}

// Model
struct SSHConnection {
    var host: String
    var port: Int
    // ...
}
```

### 4. Dependency Injection

```swift
final class SSHTerminalSession {
    private let sshClient: SSHClientProtocol
    
    init(sshClient: SSHClientProtocol = NIOSSHClientAdapter()) {
        self.sshClient = sshClient
    }
}
```

**Benefits:**
- Testable with mock objects
- Configurable behavior
- Loose coupling

## Component Responsibilities

### SSH Module

**SSHClientProtocol**
- Defines SSH client interface
- Connection management
- Data transmission
- Terminal resizing

**NIOSSHClientAdapter**
- Wraps NIOSSHClient
- Provides real SSH connectivity
- Handles PTY requests

**StubSSHClient**
- Test implementation
- Simulates SSH behavior
- No network required

### SFTP Module

**SFTPClientProtocol**
- File operations interface
- Directory listing
- Upload/download
- File attributes

**SFTPServiceAdapter**
- Wraps Shout library
- Real SFTP operations
- Error handling

**StubSFTPClient**
- Test implementation
- Mock file system
- Simulated transfers

### Security Module

**KeychainServiceProtocol**
- Credential storage
- Secure data handling
- Password/key management

**HostKeyVerifierProtocol**
- Host key verification
- Known hosts management
- Security warnings

### Terminal UI

**TerminalScreen**
- Main UI view
- Connection management
- SFTP panel
- Language switcher

**SSHTerminalSession**
- Terminal state management
- SSH client coordination
- Terminal input/output

**QuickActionsBar**
- Quick command buttons
- Command injection

## Data Flow

### SSH Connection Flow

```
User Input (TerminalScreen)
    ↓
SSHTerminalSession.connect()
    ↓
SSHClientProtocol.connect()
    ↓
NIOSSHClientAdapter → NIOSSHClient
    ↓
Network Connection
    ↓
Output via callbacks
    ↓
TerminalView updates
```

### SFTP Operation Flow

```
User selects file
    ↓
TerminalScreen handles picker
    ↓
SFTPService.upload()
    ↓
Shout library
    ↓
Network transfer
    ↓
Progress updates
    ↓
UI feedback
```

## Testing Strategy

### Unit Tests

```swift
func testSSHConnect() async throws {
    let stubClient = StubSSHClient()
    let config = SSHConnectionConfig(...)
    try await stubClient.connect(config)
    XCTAssertTrue(stubClient.isConnected)
}
```

### UI Tests

```swift
func testMainNavigation() {
    let app = XCUIApplication()
    app.launch()
    XCTAssertTrue(app.navigationBars["Onyx Terminal"].exists)
}
```

### Integration Tests

- TODO: Set up test SSH server
- TODO: Test real connections
- TODO: Test file transfers

## Concurrency Model

### Async/Await

All network operations use Swift's modern concurrency:

```swift
func connect(_ config: SSHConnectionConfig) async throws {
    // Async network operation
}
```

### Main Actor

UI updates are confined to main thread:

```swift
@MainActor
final class SSHTerminalSession: ObservableObject {
    @Published var isConnected = false
    // ...
}
```

### Background Processing

Network operations run on background threads via NIO's EventLoopGroup.

## Error Handling

### Typed Errors

```swift
public enum SSHError: Error, LocalizedError {
    case notConnected
    case authenticationFailed
    case connectionFailed(String)
}
```

### Error Propagation

```swift
do {
    try await sshClient.connect(config)
} catch {
    // Handle error
    statusLine = error.localizedDescription
}
```

## Localization

### String Keys

```swift
NSLocalizedString("status.connected", comment: "已連線")
LocalizedStringKey("btn.connect")
```

### Supported Languages

- English (en)
- Traditional Chinese (zh-Hant, default)

## Performance Considerations

### Memory Management

- WeakSelf in closures to prevent retain cycles
- Proper cleanup in deinit/close methods
- Limited scrollback buffer (20000 lines)

### Network Efficiency

- Reuse connections when possible
- Batch data transfers
- Proper timeout handling

### UI Responsiveness

- Async operations don't block UI
- Progress indicators for long operations
- Cancellation support

## Security

### Credential Storage

- Use iOS Keychain for passwords
- Encrypt sensitive data
- No plaintext storage

### Network Security

- SSH encryption
- Host key verification
- No plain HTTP

### Input Validation

- Sanitize user inputs
- Validate file paths
- Check permissions

## Future Enhancements

### Planned Features

1. Private key authentication
2. Multiple sessions/tabs
3. Port forwarding
4. Session recording
5. Custom themes
6. Snippet management

### Architecture Improvements

1. Unified SSH/SFTP library
2. Connection pooling
3. Background operations
4. iCloud sync for connections
5. Watch app companion

## References

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [SwiftNIO Documentation](https://github.com/apple/swift-nio)
- [Shout Documentation](https://github.com/jakeheis/Shout)
