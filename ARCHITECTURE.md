# Architecture Overview

This document provides a visual overview of the Onyx Terminal architecture.

## 📐 Layered Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         UI Layer                             │
│                      (SwiftUI Views)                         │
├─────────────────────────────────────────────────────────────┤
│  TerminalScreen  │  QuickActionsBar  │  DocumentPickers     │
│  ConnectionForm  │  SFTPBrowser      │  SettingsView        │
└─────────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                     ViewModel Layer                          │
│                    (Business Logic)                          │
├─────────────────────────────────────────────────────────────┤
│  SSHTerminalSession  │  ConnectionManager  │  FileManager   │
└─────────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                     Use Case Layer                           │
│                   (Domain Logic)                             │
├─────────────────────────────────────────────────────────────┤
│  ConnectUseCase  │  TransferFileUseCase  │  ExecuteCommand  │
└─────────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    Repository Layer                          │
│               (Data Source Abstraction)                      │
├─────────────────────────────────────────────────────────────┤
│  SSHRepository  │  SFTPRepository  │  CredentialRepository  │
└─────────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      Service Layer                           │
│                    (Protocol Definitions)                    │
├─────────────────────────────────────────────────────────────┤
│  SSHClient  │  SFTPClient  │  KeychainService               │
│  HostKeyVerifier  │  StorageService                          │
└─────────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                  Implementation Layer                        │
│               (Concrete Implementations)                     │
├─────────────────────────────────────────────────────────────┤
│  DefaultSSHClient (Stub)  │  NIOSSHClient (Existing)        │
│  DefaultSFTPClient (Stub) │  SFTPService (Existing)         │
│  DefaultKeychainService   │  DefaultHostKeyVerifier         │
│  UserDefaultsStorage      │  InMemoryStorage                │
└─────────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    External Libraries                        │
│                   (Third-party SDKs)                         │
├─────────────────────────────────────────────────────────────┤
│  SwiftTerm  │  SwiftNIO-SSH  │  Shout  │  iOS Keychain     │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 Data Flow

### SSH Connection Flow

```
User Input (UI)
    ↓
ConnectionForm (SwiftUI)
    ↓
SSHTerminalSession (ViewModel)
    ↓
SSHClient Protocol
    ↓
DefaultSSHClient / NIOSSHClient (Implementation)
    ↓
SwiftNIO-SSH (Library)
    ↓
Network → Remote Server
```

### SFTP File Transfer Flow

```
User Selects File (UI)
    ↓
DocumentPicker → TerminalScreen
    ↓
SSHTerminalSession (ViewModel)
    ↓
SFTPClient Protocol
    ↓
DefaultSFTPClient / SFTPService (Implementation)
    ↓
Shout (Library)
    ↓
SFTP → Remote Server
```

### Credential Storage Flow

```
User Enters Password
    ↓
ConnectionForm
    ↓
Save Credentials Action
    ↓
KeychainService Protocol
    ↓
DefaultKeychainService (Implementation)
    ↓
iOS Keychain API
    ↓
Secure Enclave
```

## 🏛️ Module Structure

### Core Module
```
Core/
├── Networking/
│   ├── SSHClient.swift          (Protocol)
│   └── SFTPClient.swift         (Protocol)
├── Security/
│   ├── KeychainService.swift    (Protocol)
│   └── HostKeyVerifier.swift    (Protocol)
├── Storage/
│   └── StorageService.swift     (Protocol + Implementations)
└── DesignSystem/
    └── DesignSystem.swift       (UI Constants & Extensions)
```

### Features Module
```
Features/
├── SSH/
│   └── DefaultSSHClient.swift   (Stub Implementation)
├── SFTP/
│   └── DefaultSFTPClient.swift  (Stub Implementation)
└── TerminalUI/
    └── TerminalComponents.swift (UI Components)
```

### App Module
```
App/
├── TerminalCLIApp.swift         (App Entry Point)
├── Models/
│   └── SSHConnection.swift      (Data Models)
├── Services/
│   ├── NIOSSHClient.swift       (Real SSH Implementation)
│   ├── SFTPService.swift        (Real SFTP Implementation)
│   └── SSHTerminalSession.swift (ViewModel)
├── Views/
│   ├── TerminalScreen.swift     (Main View)
│   └── QuickActionsBar.swift    (Quick Actions)
└── Utils/
    └── DocumentPickers.swift    (File Pickers)
```

## 🔌 Dependency Injection

### Current Approach (Direct Instantiation)
```swift
class SSHTerminalSession {
    private let sshClient = NIOSSHClient()
    // Direct dependency - hard to test
}
```

### Recommended Approach (Protocol-based)
```swift
class SSHTerminalSession {
    private let sshClient: SSHClient
    
    init(sshClient: SSHClient = NIOSSHClient()) {
        self.sshClient = sshClient
    }
    // Now testable with DefaultSSHClient stub
}
```

### Testing with Stubs
```swift
func testConnection() {
    let stubClient = DefaultSSHClient()
    let session = SSHTerminalSession(sshClient: stubClient)
    // Test with predictable stub behavior
}
```

## 🔒 Security Architecture

### Credential Flow
```
User Input (Password/Key)
    ↓
Encrypted in Memory
    ↓
KeychainService Protocol
    ↓
iOS Keychain (Secure Enclave)
    ↓
Biometric Protection (Optional)
    ↓
Retrieved Only When Needed
    ↓
Zero in Memory After Use
```

### Host Key Verification
```
SSH Connection Initiated
    ↓
Server Sends Public Key
    ↓
HostKeyVerifier Protocol
    ↓
Check Known Hosts Database
    ↓
┌─────────────────────────┐
│  Match?   │  New?       │  Changed?        │
│  ✓ Trust  │  ? Ask User │  ✗ Warn MITM     │
└─────────────────────────┘
    ↓
User Decision
    ↓
Add to Known Hosts / Reject
```

## 🧪 Testing Architecture

### Test Pyramid

```
           ┌──────────┐
          /  UI Tests  \           8 tests
         /  (8 cases)   \
        /________________\
       /                  \
      /   Integration      \      (Future)
     /      Tests           \
    /______________________\
   /                        \
  /     Unit Tests          \    25 tests
 /    (SSHClient, SFTP,     \
/    HostKeyVerifier)       \
/__________________________\
```

### Test Strategy

1. **Unit Tests** (Bottom Layer)
   - Test protocols with stub implementations
   - Fast, isolated, numerous
   - No external dependencies
   - Mock data and behavior

2. **Integration Tests** (Middle Layer - Future)
   - Test real implementations
   - Test with actual libraries
   - Still no network calls
   - Local test servers

3. **UI Tests** (Top Layer)
   - Test user flows
   - Test UI interactions
   - Fewer but comprehensive
   - Use stub services

### Test Doubles Used

```swift
// Stub - Provides canned responses
class DefaultSSHClient: SSHClient {
    func connect() async throws {
        // Return success with mock data
    }
}

// Spy - Records method calls (Future)
class SpySSHClient: SSHClient {
    var connectCalled = false
    func connect() async throws {
        connectCalled = true
    }
}

// Mock - Verifies behavior (Future)
class MockSSHClient: SSHClient {
    var expectedCalls = 0
    var actualCalls = 0
    func connect() async throws {
        actualCalls += 1
    }
}
```

## 📦 Build & Deployment

### Build Flow

```
Source Code
    ↓
XcodeGen (project.yml → .xcodeproj)
    ↓
Swift Package Manager (Resolve Dependencies)
    ↓
SwiftLint (Code Quality)
    ↓
Compilation (Swift Compiler)
    ↓
Unit Tests (XCTest)
    ↓
UI Tests (XCTest)
    ↓
Archive (.ipa)
    ↓
Code Signing (Certificates & Profiles)
    ↓
TestFlight / App Store
```

### CI/CD Pipeline

```
GitHub Push/PR
    ↓
GitHub Actions (macOS Runner)
    ↓
┌──────────────────────────┐
│  1. Setup Environment    │ (Xcode, Ruby, Tools)
│  2. Install Dependencies │ (SPM, Bundler)
│  3. Generate Project     │ (XcodeGen)
│  4. Run SwiftLint        │ (Code Quality)
│  5. Build Debug          │ (Compilation)
│  6. Run Tests            │ (Unit + UI)
│  7. Generate Coverage    │ (Code Coverage)
│  8. Upload Artifacts     │ (Test Results)
└──────────────────────────┘
    ↓
✅ Success / ❌ Failure
    ↓
PR Status Check
```

## 🚀 Future Enhancements

### Phase 1: Real Implementations
- Replace stubs with actual SwiftNIO-SSH/Shout implementations
- Complete Keychain integration
- Implement persistent known_hosts storage

### Phase 2: Advanced Features
- Background file transfers with progress
- Multiple concurrent sessions
- Terminal customization (themes, fonts)
- Session persistence

### Phase 3: Production Ready
- Code signing automation
- TestFlight continuous deployment
- App Store submission
- Crash reporting and analytics

---

## 📚 References

- **SwiftUI**: Apple's declarative UI framework
- **SwiftNIO-SSH**: Apple's SSH implementation
- **SwiftTerm**: Terminal emulation library
- **Shout**: SFTP library for Swift
- **Fastlane**: iOS automation tool
- **XcodeGen**: Xcode project generator

---

Last Updated: 2025-10-18
Version: 1.0.0 (Initial Scaffold)
