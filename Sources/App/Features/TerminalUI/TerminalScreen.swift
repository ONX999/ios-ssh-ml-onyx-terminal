import SwiftUI
import SwiftTerm

struct TerminalScreen: View {
    @StateObject private var terminal = SSHTerminalSession()
    @State private var sftp = SFTPService()
    @State private var ssh = SSHConnection()
    @AppStorage("appLanguage") private var appLanguage: String = "zh-Hant"
    private let languages = [("zh-Hant", "language.zh"), ("en", "language.en")]
    @State private var alsoConnectSFTP = true
    @State private var showImporter = false
    @State private var showExporter = false
    @State private var exportData = Data()
    @State private var exportFileName = "downloaded.bin"
    @State private var sftpStatus: String = NSLocalizedString("sftp.not_connected", comment: "SFTP 未連線")
    @State private var isSFTPBusy = false
    @State private var listPath: String = "~"
    @State private var listResultText: String = ""
    @State private var showListSheet = false
    @State private var remoteUploadDir: String = "~"
    @State private var remoteDownloadPath: String = "~/file.bin"
    @State private var alertMessage: String?
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Form {
                    Section(LocalizedStringKey("section.connection")) {
                        TextField(LocalizedStringKey("field.host"), text: $ssh.host)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        Stepper(value: $ssh.port, in: 1...65535) {
                            HStack {
                                Text(LocalizedStringKey("field.port"))
                                Spacer()
                                Text("\(ssh.port)").foregroundStyle(.secondary)
                            }
                        }
                        TextField(LocalizedStringKey("field.username"), text: $ssh.username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        SecureField(LocalizedStringKey("field.password"), text: $ssh.password)
                        Toggle(LocalizedStringKey("toggle.connect_sftp"), isOn: $alsoConnectSFTP)
                        HStack(spacing: 12) {
                            Button(terminal.isConnected ? LocalizedStringKey("btn.disconnect") : LocalizedStringKey("btn.connect")) {
                                if terminal.isConnected {
                                    terminal.disconnect()
                                    if sftp.isConnected { sftp.disconnect() }
                                    sftpStatus = NSLocalizedString("sftp.not_connected", comment: "SFTP 未連線")
                                } else {
                                    connectAll()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(terminal.isConnecting || !ssh.isFilled)
                            if terminal.isConnecting { ProgressView() }
                            Text(terminal.statusLine)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                        }
                        if alsoConnectSFTP {
                            HStack(spacing: 8) {
                                Text(sftpStatus)
                                    .font(.footnote)
                                    .foregroundStyle(sftp.isConnected ? .green : .secondary)
                                if isSFTPBusy { ProgressView().scaleEffect(0.8) }
                            }
                        }
                    }
                    Section(LocalizedStringKey("section.language")) {
                        Picker(LocalizedStringKey("picker.language"), selection: $appLanguage) {
                            ForEach(languages, id: \(\.0)) { lang in
                                Text(LocalizedStringKey(lang.1)).tag(lang.0)
                            }
                        }
                        .pickerStyle(.segmented)
                        Text(LocalizedStringKey("hint.language_effect"))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .disabled(terminal.isConnecting)
                QuickActionsBar(actions: .modelCLIShortcuts) { action in terminal.sendCommand(action.command) }
                TerminalContainerView(terminalView: terminal.terminalView)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        if !terminal.isConnected {
                            VStack(spacing: 8) {
                                Image(systemName: "network.slash").font(.largeTitle).foregroundStyle(.secondary)
                                Text(LocalizedStringKey("ui.not_connected")).foregroundStyle(.secondary)
                                Text(LocalizedStringKey("ui.fill_then_connect")).font(.footnote).foregroundStyle(.secondary)
                            }.padding()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal)
                sftpPanel
            }
            .navigationTitle("Onyx Terminal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(LocalizedStringKey("menu.clear")) {
                            terminal.terminalView.getTerminal().softReset()
                            terminal.terminalView.resetScrollHistory()
                        }
                        Button(LocalizedStringKey("menu.resize")) {
                            let term = terminal.terminalView.getTerminal()
                            terminal.sizeChanged(source: terminal.terminalView, newCols: Int(term.cols), newRows: Int(term.rows))
                        }
                    } label: { Image(systemName: "ellipsis.circle") }
                }
            }
            .sheet(isPresented: $showImporter) { ImportDocumentPicker { url in Task { await uploadPicked(url) } } }
            .sheet(isPresented: $showExporter) { ExportDocumentPicker(data: exportData, suggestedFileName: exportFileName) }
            .sheet(isPresented: $showListSheet) {
                NavigationView {
                    ScrollView {
                        Text(listResultText)
                            .font(.system(.footnote, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                    .navigationTitle(LocalizedStringKey("sheet.dir_list"))
                    .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button(LocalizedStringKey("btn.done")) { showListSheet = false } } }
                }
            }
            .alert(LocalizedStringKey("alert.title"), isPresented: Binding(get: { alertMessage != nil }, set: { if !$0 { alertMessage = nil } })) {
                Button(LocalizedStringKey("btn.ok"), role: .cancel) { alertMessage = nil }
            } message: { Text(alertMessage ?? "") }
        }
    }
    private var sftpPanel: some View {
        VStack(spacing: 10) {
            Divider().padding(.horizontal)
            Group {
                HStack(spacing: 8) {
                    Text(LocalizedStringKey("label.upload_to")).font(.footnote).foregroundStyle(.secondary)
                    TextField(LocalizedStringKey("ph.remote_dir"), text: $remoteUploadDir)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                    Button {
                        guard sftp.isConnected else { alertMessage = NSLocalizedString("sftp.need_connect", comment: "請先連線 SFTP"); return }
                        showImporter = true
                    } label: { Label(LocalizedStringKey("btn.select_upload"), systemImage: "arrow.up.circle") }
                    .disabled(!sftp.isConnected || isSFTPBusy)
                }
                HStack(spacing: 8) {
                    Text(LocalizedStringKey("label.download_path")).font(.footnote).foregroundStyle(.secondary)
                    TextField(LocalizedStringKey("ph.remote_file"), text: $remoteDownloadPath)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                    Button { Task { await downloadRemote(remotePath: remoteDownloadPath) } } label: { Label(LocalizedStringKey("btn.download_to_device"), systemImage: "arrow.down.circle") }
                    .disabled(!sftp.isConnected || isSFTPBusy)
                }
                HStack(spacing: 8) {
                    Text(LocalizedStringKey("label.list_dir")).font(.footnote).foregroundStyle(.secondary)
                    TextField(LocalizedStringKey("ph.dir"), text: $listPath)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                    Button { Task { await listDirectory(path: listPath) } } label: { Label(LocalizedStringKey("btn.list"), systemImage: "folder") }
                    .disabled(!sftp.isConnected || isSFTPBusy)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }
    private func connectAll() {
        guard ssh.isFilled else { alertMessage = NSLocalizedString("alert.fill_all", comment: "請完整填寫資訊"); return }
        Task { await terminal.connect(ssh) }
        if alsoConnectSFTP {
            isSFTPBusy = true
            Task {
                do {
                    try sftp.connect(host: ssh.host, port: ssh.port, username: ssh.username, password: ssh.password)
                    sftpStatus = NSLocalizedString("sftp.connected", comment: "SFTP 已連線")
                } catch {
                    sftpStatus = String(format: NSLocalizedString("sftp.connect_failed", comment: "SFTP 連線失敗：%@"), error.localizedDescription)
                }
                isSFTPBusy = false
            }
        }
    }
    private func uploadPicked(_ localURL: URL) async {
        guard sftp.isConnected else { alertMessage = NSLocalizedString("sftp.not_connected", comment: "SFTP 尚未連線"); return }
        isSFTPBusy = true; defer { isSFTPBusy = false }
        do {
            let dstDir = remoteUploadDir.isEmpty ? "~" : remoteUploadDir
            let fileName = localURL.lastPathComponent
            var remotePath = dstDir; if !remotePath.hasSuffix("/") { remotePath += "/" }; remotePath += fileName
            try sftp.upload(localURL: localURL, remotePath: remotePath)
            alertMessage = String(format: NSLocalizedString("toast.upload_ok", comment: "上傳成功：%@ -> %@"), fileName, remotePath)
        } catch { alertMessage = String(format: NSLocalizedString("toast.upload_fail", comment: "上傳失敗：%@"), error.localizedDescription) }
    }
    private func downloadRemote(remotePath: String) async {
        guard sftp.isConnected else { alertMessage = NSLocalizedString("sftp.not_connected", comment: "SFTP 尚未連線"); return }
        isSFTPBusy = true; defer { isSFTPBusy = false }
        do {
            let fileName = (remotePath as NSString).lastPathComponent
            let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + "_" + (fileName.isEmpty ? "download.bin" : fileName))
            try sftp.download(remotePath: remotePath, to: tmpURL)
            let data = try Data(contentsOf: tmpURL)
            self.exportData = data
            self.exportFileName = fileName.isEmpty ? "downloaded.bin" : fileName
            self.showExporter = true
        } catch { alertMessage = String(format: NSLocalizedString("toast.download_fail", comment: "下載失敗：%@"), error.localizedDescription) }
    }
    private func listDirectory(path: String) async {
        guard sftp.isConnected else { alertMessage = NSLocalizedString("sftp.not_connected", comment: "SFTP 尚未連線"); return }
        isSFTPBusy = true; defer { isSFTPBusy = false }
        do {
            let files = try sftp.list(path: path)
            var lines: [String] = []
            lines.append(String(format: NSLocalizedString("dir.path", comment: "目錄：%@"), path))
            lines.append(String(repeating: "─", count: max(12, path.count)))
            for f in files {
                let typeChar: String
                switch f.attrs.permissions?.fileType {
                case .some(.directory): typeChar = "d"
                case .some(.symlink):   typeChar = "l"
                default:                typeChar = "-"
                }
                let size = f.attrs.size ?? 0
                lines.append("\(typeChar) \(String(format: "%10d", size))  \(f.filename)")
            }
            listResultText = lines.joined(separator: "\n")
            showListSheet = true
        } catch { alertMessage = String(format: NSLocalizedString("toast.list_fail", comment: "列目錄失敗：%@"), error.localizedDescription) }
    }
}