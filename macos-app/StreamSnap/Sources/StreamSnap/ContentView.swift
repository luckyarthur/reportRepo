import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DownloadViewModel()
    @FocusState private var urlFieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            urlSection
            formatSection
            destinationSection
            actionSection
            if !viewModel.recentDownloads.isEmpty {
                Divider()
                recentDownloadsSection
            }
            Spacer(minLength: 0)
        }
        .padding(20)
        .frame(minWidth: 460, idealWidth: 480, minHeight: 360)
    }

    private var urlSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Stream URL")
                .font(.headline)
            TextField("https://example.com/stream.m3u8", text: $viewModel.urlString)
                .textFieldStyle(.roundedBorder)
                .focused($urlFieldFocused)
                .disabled(viewModel.isDownloading)
            Text("Paste a direct link to content you have the right to download (HLS .m3u8, DASH .mpd, or a progressive MP4/audio URL).")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var formatSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Output Format")
                .font(.headline)
            Picker("Output Format", selection: $viewModel.selectedFormat) {
                ForEach(OutputFormat.allCases) { format in
                    Label(format.displayName, systemImage: format.symbolName)
                        .tag(format)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            .disabled(viewModel.isDownloading)
        }
    }

    private var destinationSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Save To")
                .font(.headline)
            HStack {
                Text(viewModel.destinationDirectory.path)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Spacer()
                Button("Choose…") {
                    viewModel.chooseDestinationDirectory()
                }
                .disabled(viewModel.isDownloading)
            }
        }
    }

    private var actionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: viewModel.startDownload) {
                    Label("Download", systemImage: "arrow.down.circle.fill")
                        .frame(minWidth: 100)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canStartDownload)

                statusView
            }
        }
    }

    @ViewBuilder
    private var statusView: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
        case .downloading(let progress):
            if let progress {
                ProgressView(value: progress)
                    .frame(width: 160)
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ProgressView()
                    .controlSize(.small)
                Text("Working…")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        case .finished:
            Label("Done", systemImage: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.caption)
        case .failed(let message):
            Label(message, systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.red)
                .font(.caption)
                .lineLimit(2)
        }
    }

    private var recentDownloadsSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Recent Downloads")
                .font(.headline)
            ForEach(viewModel.recentDownloads.prefix(5)) { item in
                HStack {
                    Image(systemName: item.format.symbolName)
                        .foregroundStyle(.secondary)
                    Text(item.destination.lastPathComponent)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    Spacer()
                    Button("Show in Finder") {
                        viewModel.revealInFinder(item)
                    }
                    .buttonStyle(.link)
                    .font(.caption)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
