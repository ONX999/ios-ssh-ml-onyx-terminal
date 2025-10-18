import Foundation
import SwiftUI
import SwiftTerm
import NIO

@MainActor
final class SSHTerminalSession: NSObject, ObservableObject, TerminalViewDelegate {
    let terminalView = TerminalView()
    @Published var isConnected = false
    @Published var isConnecting = false
    @Published var statusLine: String = NSLocalizedString("status.not_connected", comment: "未連線")
    private var config: SSHConnection?
    private let sshClient = NIOSSHClient()
    override init() {
        super.init()
        terminalView.delegate = self
        terminalView.terminalTitle = "SSH"
        terminalView.nativeForegroundColor = UIColor.label
        terminalView.nativeBackgroundColor = UIColor.systemBackground
        sshClient.onStdout = { [weak self] buf in
            guard let self else { return }
            var buffer = buf
            if let data = buffer.readBytes(length: buffer.readableBytes) {
                DispatchQueue.main.async { self.terminalView.feed(byteArray: data) }
            }
        }
        sshClient.onStderr = { [weak self] buf in
            guard let self else { return }
            var buffer = buf
            if let data = buffer.readBytes(length: buffer.readableBytes) {
                DispatchQueue.main.async { self.terminalView.feed(byteArray: data) }
            }
        }
        sshClient.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.statusLine = String(format: NSLocalizedString("status.error", comment: "連線錯誤：%@"), error.localizedDescription)
                self?.isConnected = false
                self?.isConnecting = false
            }
        }
    }
    func connect(_ config: SSHConnection) async {
        guard !isConnecting, !isConnected else { return }
        self.isConnecting = true
        self.statusLine = String(format: NSLocalizedString("status.connecting", comment: "連線中 %@"), "\(config.username)@\(config.host):\(config.port)")
        self.config = config
        let cols = Int(terminalView.getTerminal().cols)
        let rows = Int(terminalView.getTerminal().rows)
        var cfg = NIOSSHClient.Config(host: config.host, port: config.port, username: config.username, password: config.password)
        cfg.cols = cols; cfg.rows = rows
        do {
            try await sshClient.connect(cfg)
            sshClient.resize(cols: cols, rows: rows)
            self.isConnected = true
            self.statusLine = String(format: NSLocalizedString("status.connected", comment: "已連線：%@"), "\(config.username)@\(config.host)")
        } catch {
            self.statusLine = String(format: NSLocalizedString("status.connect_failed", comment: "連線失敗：%@"), error.localizedDescription)
            self.isConnected = false
        }
        self.isConnecting = false
    }
    func disconnect() {
        Task { try? await sshClient.close() }
        isConnected = false
        statusLine = NSLocalizedString("status.disconnected", comment: "已斷線")
    }
    func sendCommand(_ text: String) {
        let cmd = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cmd.isEmpty else { return }
        terminalView.send(text: cmd + "\r\n")
    }
    func send(source: TerminalView, data: ArraySlice<UInt8>) {
        var buf = ByteBufferAllocator().buffer(capacity: data.count)
        buf.writeBytes(Array(data))
        sshClient.send(buf)
    }
    func scrolled(source: TerminalView, position: Double) {}
    func bell(source: TerminalView) {}
    func setTerminalTitle(source: TerminalView, title: String) {}
    func sizeChanged(source: TerminalView, newCols: Int, newRows: Int) { sshClient.resize(cols: newCols, rows: newRows) }
    func hostCurrentDirectoryUpdate(source: TerminalView, directory: String?) {}
}

struct TerminalContainerView: UIViewRepresentable {
    let terminalView: TerminalView
    func makeUIView(context: Context) -> TerminalView {
        terminalView.becomeFirstResponder()
        terminalView.scrollBufferMaximumSize = 20000
        terminalView.installColors(AnsiColors.defaultColorMap)
        terminalView.nativeForegroundColor = UIColor.label
        terminalView.nativeBackgroundColor = UIColor.systemBackground
        return terminalView
    }
    func updateUIView(_ uiView: TerminalView, context: Context) {
        uiView.nativeForegroundColor = UIColor.label
        uiView.nativeBackgroundColor = UIColor.systemBackground
    }
}