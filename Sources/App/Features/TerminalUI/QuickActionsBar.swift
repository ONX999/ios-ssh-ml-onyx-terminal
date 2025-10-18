import SwiftUI

struct QuickAction: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let command: String
}

struct QuickActionsBar: View {
    let actions: [QuickAction]
    var onTap: (QuickAction) -> Void
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(actions) { action in
                    Button(LocalizedStringKey(action.title)) { onTap(action) }
                        .buttonStyle(.bordered)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 48)
    }
}

extension Array where Element == QuickAction {
    static var modelCLIShortcuts: [QuickAction] {
        [
            .init(title: "qa.llama_help", command: "llama-cli --help"),
            .init(title: "qa.ollama_llama3", command: "ollama run llama3"),
            .init(title: "qa.hf_env", command: "python3 -m transformers_cli env"),
            .init(title: "qa.conda_envs", command: "conda env list"),
            .init(title: "qa.tmux_attach", command: "tmux attach || tmux new -s session1"),
            .init(title: "qa.nvidia_smi", command: "nvidia-smi || echo 'No NVIDIA GPU'"),
        ]
    }
}