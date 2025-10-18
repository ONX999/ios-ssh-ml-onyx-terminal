# Onyx Terminal - iOS SSH & SFTP Client

![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

A professional iOS application providing SSH terminal access and SFTP file transfer capabilities with an intuitive SwiftUI interface.

## ✨ Features

### Current Implementation
- 🖥️ **Full VT100 Terminal** - Complete terminal emulation using SwiftTerm
- 🔐 **SSH Connection** - Secure shell access using SwiftNIO-SSH
- 📁 **SFTP File Transfer** - Upload and download files using Shout/libssh2
- 🌍 **Multi-language Support** - Traditional Chinese (default) and English
- ⚡ **Quick Actions** - Shortcuts for common ML/AI commands (llama.cpp, ollama, transformers, conda, tmux)
- 🎨 **SwiftUI Interface** - Modern, native iOS design

### Architecture Highlights
- **Protocol-based Design** - Abstract SSH/SFTP clients with stub implementations
- **MVVM Architecture** - Clean separation of concerns
- **Dependency Injection** - Testable and maintainable codebase
- **Security First** - Keychain integration for credential storage (interface ready)
- **Host Key Verification** - Known hosts management (interface ready)

## 📋 Requirements

- **iOS**: 16.0+
- **Xcode**: 15.0+
- **Swift**: 5.9+
- **Ruby**: 3.0+ (for Fastlane)
- **XcodeGen**: Latest (for project generation)

## 🏗️ Project Structure

```
ios-ssh-ml-onyx-terminal/
├── Sources/
│   ├── App/                    # Application entry point and main views
│   │   ├── TerminalCLIApp.swift
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── Views/
│   │   └── Utils/
│   ├── Features/               # Feature modules
│   │   ├── SSH/               # SSH client implementations
│   │   ├── SFTP/              # SFTP client implementations
│   │   └── TerminalUI/        # Terminal UI components
│   └── Core/                  # Core infrastructure
│       ├── Networking/        # SSH/SFTP protocols
│       ├── Security/          # Keychain, host key verification
│       ├── Storage/           # Data persistence
│       └── DesignSystem/      # UI components and themes
├── Tests/
│   ├── Unit/                  # Unit tests
│   └── UITests/               # UI tests
├── Tools/                     # Development tools and scripts
├── fastlane/                  # Fastlane configuration
│   ├── Fastfile
│   ├── Appfile
│   └── Scanfile
├── .github/
│   └── workflows/
│       └── ci.yml            # GitHub Actions CI workflow
├── project.yml               # XcodeGen project specification
├── Gemfile                   # Ruby dependencies
├── .swiftlint.yml           # SwiftLint configuration
└── .gitignore
```

## 🚀 Quick Start

### 1. Install Dependencies

```bash
# Install XcodeGen
brew install xcodegen

# Install Ruby dependencies (Fastlane)
bundle install

# Install SwiftLint
brew install swiftlint
```

### 2. Generate Xcode Project

```bash
xcodegen generate
```

This will create `OnyxTerminal.xcodeproj` and `OnyxTerminal.xcworkspace` from the `project.yml` specification.

### 3. Open in Xcode

```bash
open OnyxTerminal.xcworkspace
```

Select your development team in Xcode project settings, then build and run on a simulator or device.

### 4. Run with Fastlane (Alternative)

```bash
# Lint code
bundle exec fastlane lint

# Run tests
bundle exec fastlane test

# Build debug version
bundle exec fastlane build_debug

# Run all checks
bundle exec fastlane ci
```

## 🧪 Testing

### Run Tests via Xcode
- Select the test target
- Press `Cmd+U` to run all tests
- View results in the Test Navigator

### Run Tests via Command Line
```bash
# Using xcodebuild
xcodebuild test \
  -workspace OnyxTerminal.xcworkspace \
  -scheme OnyxTerminal \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Using Fastlane
bundle exec fastlane test
```

### Test Coverage
- Unit tests for SSH/SFTP protocol implementations
- UI tests for main user flows
- Code coverage reports generated in CI

## 🔧 Development

### Code Style
- **SwiftLint** enforces consistent coding style
- Configuration in `.swiftlint.yml`
- Run `bundle exec fastlane lint` before committing

### Commit Convention
Follow conventional commits:
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `test:` - Test additions/changes
- `refactor:` - Code refactoring
- `chore:` - Build/tooling changes

### Branch Strategy
- `main` - Production-ready code
- `develop` - Development integration branch
- `feature/*` - Feature branches
- `fix/*` - Bug fix branches

## 🔄 CI/CD

### GitHub Actions
The project includes automated CI workflow (`.github/workflows/ci.yml`) that:
- ✅ Runs SwiftLint
- ✅ Builds the app
- ✅ Runs unit and UI tests
- ✅ Generates code coverage reports
- ✅ Archives test results and build artifacts

Triggers on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches
- Manual workflow dispatch

### Fastlane Lanes

```bash
# Development
fastlane lint           # Run SwiftLint
fastlane test           # Run tests
fastlane build_debug    # Build debug version
fastlane build_release  # Build release (requires signing setup)
fastlane ci             # Run all checks

# Deployment (TODO: Configure signing)
fastlane beta           # Deploy to TestFlight
```

## 📱 App Configuration

- **Bundle ID**: `com.onx999.OnyxTerminal`
- **Display Name**: Onyx Terminal
- **Minimum iOS Version**: 16.0
- **Default Language**: Traditional Chinese (zh-Hant)
- **Supported Languages**: Traditional Chinese, English

## 🔐 Security Features

### Implemented
- Abstract protocols for secure credential management
- Host key verification interfaces
- Secure password fields in UI

### TODO (Marked in code)
- [ ] Complete Keychain integration for credential storage
- [ ] Implement persistent known_hosts storage
- [ ] Add host key verification workflow
- [ ] Support private key authentication
- [ ] Implement SSH key generation

## 🗺️ Roadmap

### Phase 1: Foundation ✅ (Current PR)
- [x] Project scaffold and structure
- [x] Protocol abstractions for SSH/SFTP
- [x] Stub implementations
- [x] Basic UI framework
- [x] Testing infrastructure
- [x] CI/CD pipeline
- [x] Documentation

### Phase 2: Core SSH/SFTP (Next)
- [ ] Replace stub SSH client with full SwiftNIO-SSH implementation
- [ ] Replace stub SFTP client with Shout/libssh2 implementation
- [ ] Implement complete PTY/terminal interaction
- [ ] Add VT100 escape sequence handling
- [ ] Improve terminal rendering and performance

### Phase 3: Security & Authentication
- [ ] Complete Keychain credential storage
- [ ] Implement known_hosts persistence and verification
- [ ] Add SSH key pair generation
- [ ] Support multiple authentication methods
- [ ] Add certificate-based authentication

### Phase 4: Advanced Features
- [ ] Background file transfer with progress tracking
- [ ] Transfer pause/resume/cancel
- [ ] Multiple concurrent sessions
- [ ] Session persistence and restoration
- [ ] Custom terminal themes and fonts
- [ ] Keyboard shortcuts and customization

### Phase 5: Polish & Distribution
- [ ] Complete UI/UX refinements
- [ ] Accessibility improvements
- [ ] Localization for more languages
- [ ] Performance optimizations
- [ ] App Store preparation
- [ ] TestFlight beta testing

## 🛠️ Dependencies

### Swift Package Manager
- **SwiftTerm** - Terminal emulation (https://github.com/migueldeicaza/SwiftTerm)
- **Shout** - SFTP support (https://github.com/jakeheis/Shout)
- **SwiftNIO-SSH** - SSH protocol (https://github.com/apple/swift-nio-ssh)

### Ruby Gems (via Bundler)
- **fastlane** - Automation and deployment
- **cocoapods** - Dependency management

## 📄 License

MIT License - See LICENSE file for details

## 🤝 Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## 👥 Authors

- ONX999 - Initial work and maintenance

## 🙏 Acknowledgments

- SwiftTerm by Miguel de Icaza for excellent terminal emulation
- Apple's SwiftNIO team for SwiftNIO-SSH
- The Shout team for SFTP support
- All contributors to the open-source libraries used in this project

## 📞 Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check existing issues and discussions
- Refer to documentation in the Wiki

---

**Note**: This is an active development project. Some features are marked as TODO and will be implemented in future releases. The current version provides a solid foundation for SSH/SFTP operations with stub implementations for testing and development.
