import Foundation
import NIO
import NIOSSH

/// Adapter to make NIOSSHClient conform to SSHClientProtocol
public final class NIOSSHClientAdapter: SSHClientProtocol {
    private let client = NIOSSHClient()
    
    public var isConnected: Bool {
        client.state == .connected
    }
    
    public var onStdout: ((ByteBuffer) -> Void)? {
        get { client.onStdout }
        set { client.onStdout = newValue }
    }
    
    public var onStderr: ((ByteBuffer) -> Void)? {
        get { client.onStderr }
        set { client.onStderr = newValue }
    }
    
    public var onError: ((Error) -> Void)? {
        get { client.onError }
        set { client.onError = newValue }
    }
    
    public init() {}
    
    public func connect(_ config: SSHConnectionConfig) async throws {
        let password: String
        switch config.authMethod {
        case .password(let pwd):
            password = pwd
        case .privateKey:
            // TODO: Implement private key authentication
            throw SSHError.authenticationFailed
        }
        
        let nioConfig = NIOSSHClient.Config(
            host: config.host,
            port: config.port,
            username: config.username,
            password: password
        )
        
        try await client.connect(nioConfig)
    }
    
    public func send(_ data: ByteBuffer) {
        client.send(data)
    }
    
    public func resize(cols: Int, rows: Int) {
        client.resize(cols: cols, rows: rows)
    }
    
    public func close() async throws {
        try await client.close()
    }
    
    public func openSFTPSession() async throws -> SFTPClientProtocol {
        guard isConnected else {
            throw SSHError.notConnected
        }
        
        // TODO: Implement SFTP session over existing SSH connection
        // For now, return stub implementation
        let sftp = StubSFTPClient()
        try await sftp.connect()
        return sftp
    }
}

// MARK: - Original NIOSSHClient Implementation

public final class NIOSSHClient {
    public struct Config {
        public var host: String
        public var port: Int
        public var username: String
        public var password: String?
        public var terminalType: String = "xterm-256color"
        public var cols: Int = 120
        public var rows: Int = 30
        public init(host: String, port: Int, username: String, password: String?) {
            self.host = host
            self.port = port
            self.username = username
            self.password = password
        }
    }
    public enum State { case idle, connecting, connected, closed }
    private var group: EventLoopGroup?
    private var channel: Channel?
    private var sessionChannel: Channel?
    public private(set) var state: State = .idle
    public var onStdout: ((ByteBuffer) -> Void)?
    public var onStderr: ((ByteBuffer) -> Void)?
    public var onError: ((Error) -> Void)?
    public init() {}
    public func connect(_ config: Config) async throws {
        guard state == .idle || state == .closed else { return }
        state = .connecting
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.group = group
        let bootstrap = ClientBootstrap(group: group)
            .channelInitializer { channel in
                let authDelegate = PasswordAuthDelegate(username: config.username, password: config.password ?? "")
                let clientConfig = SSHClientConfiguration(userAuthDelegate: authDelegate)
                let sshHandler = NIOSSHHandler(role: .client(clientConfig), allocator: channel.allocator) { childChannel, channelType in
                    guard case .session = channelType else {
                        return childChannel.eventLoop.makeFailedFuture(SSHClientError.unsupportedChannelType)
                    }
                    return childChannel.pipeline.addHandlers([
                        SSHOutboundHandler(),
                        SSHInboundHandler(stdout: { [weak self] buf in self?.onStdout?(buf) },
                                          stderr: { [weak self] buf in self?.onStderr?(buf) })
                    ], position: .last)
                }
                return channel.pipeline.addHandlers([sshHandler])
            }
        do {
            let channel = try await bootstrap.connect(host: config.host, port: config.port).get()
            self.channel = channel
            let promise = channel.eventLoop.makePromise(of: Channel.self)
            channel.triggerUserOutboundEvent(SSHUserEvent.CreateChannel(promise))
            let sessionChannel = try await promise.futureResult.get()
            self.sessionChannel = sessionChannel
            try await requestPTY(terminalType: config.terminalType, cols: config.cols, rows: config.rows)
            try await requestShell()
            state = .connected
        } catch {
            state = .closed
            onError?(error)
            try? await close()
            throw error
        }
    }
    public func send(_ data: ByteBuffer) {
        guard let sessionChannel else { return }
        let part = SSHChannelData(type: .channel, data: .byteBuffer(data))
        sessionChannel.writeAndFlush(part, promise: nil)
    }
    public func resize(cols: Int, rows: Int) {
        guard let sessionChannel else { return }
        let event = SSHChannelEvent.windowChangeRequest(.init(width: UInt32(cols), height: UInt32(rows), widthPixels: 0, heightPixels: 0))
        sessionChannel.triggerUserOutboundEvent(event, promise: nil)
    }
    public func close() async throws {
        defer {
            self.sessionChannel = nil
            self.channel = nil
            self.state = .closed
        }
        try await self.sessionChannel?.close().get()
        try await self.channel?.close().get()
        try await self.group?.shutdownGracefully()
        self.group = nil
    }
    private func requestPTY(terminalType: String, cols: Int, rows: Int) async throws {
        guard let sessionChannel else { throw SSHClientError.notConnected }
        let term = SSHWindowSize(width: UInt32(cols), height: UInt32(rows), widthPixels: 0, heightPixels: 0)
        let ptyReq = SSHChannelRequestEvent.ptyRequest(.init(term: terminalType, size: term, terminalModes: [:]))
        try await sessionChannel.triggerUserOutboundEvent(ptyReq).get()
    }
    private func requestShell() async throws {
        guard let sessionChannel else { throw SSHClientError.notConnected }
        try await sessionChannel.triggerUserOutboundEvent(SSHChannelRequestEvent.ShellRequest()).get()
    }
}

private final class SSHInboundHandler: ChannelInboundHandler {
    typealias InboundIn = SSHChannelData
    let onStdout: (ByteBuffer) -> Void
    let onStderr: (ByteBuffer) -> Void
    init(stdout: @escaping (ByteBuffer) -> Void, stderr: @escaping (ByteBuffer) -> Void) {
        self.onStdout = stdout
        self.onStderr = stderr
    }
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let data = self.unwrapInboundIn(data)
        switch data.data {
        case .byteBuffer(let buf):
            if data.type == .stderr { onStderr(buf) } else { onStdout(buf) }
        default: break
        }
    }
}
private final class SSHOutboundHandler: ChannelOutboundHandler {
    typealias OutboundIn = SSHChannelData
    typealias OutboundOut = SSHChannelData
}
private final class PasswordAuthDelegate: NIOSSHClientUserAuthenticationDelegate {
    let username: String
    let password: String
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    func nextAuthenticationRequest(_ task: NIOSSHClientUserAuthenticationDelegateTask) {
        task.offer(.init(username: username, service: "ssh-connection", offer: .password(password)))
    }
}
public enum SSHClientError: Error { case unsupportedChannelType, notConnected }
