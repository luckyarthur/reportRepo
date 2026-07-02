import Foundation
import AppKit

enum DownloadState: Equatable {
    case idle
    case downloading(progress: Double?)
    case finished(DownloadItem)
    case failed(String)
}

@MainActor
final class DownloadViewModel: ObservableObject {
    @Published var urlString: String = ""
    @Published var selectedFormat: OutputFormat = .mp4
    @Published var destinationDirectory: URL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
        ?? FileManager.default.homeDirectoryForCurrentUser
    @Published private(set) var state: DownloadState = .idle
    @Published private(set) var recentDownloads: [DownloadItem] = []

    var isURLValid: Bool {
        StreamURLValidator.isValid(urlString)
    }

    var canStartDownload: Bool {
        isURLValid && !isDownloading
    }

    var isDownloading: Bool {
        if case .downloading = state { return true }
        return false
    }

    func chooseDestinationDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.directoryURL = destinationDirectory
        panel.prompt = "Choose"
        if panel.runModal() == .OK, let url = panel.url {
            destinationDirectory = url
        }
    }

    func startDownload() {
        guard canStartDownload else { return }
        let trimmedURL = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        let format = selectedFormat
        let destinationDir = destinationDirectory
        state = .downloading(progress: nil)

        Task {
            do {
                let fileName = Self.suggestedFileName(for: trimmedURL, format: format)
                let destination = destinationDir.appendingPathComponent(fileName)

                let duration: Double?
                do {
                    duration = try await FFmpegRunner.probeDuration(sourceURL: trimmedURL)
                } catch {
                    duration = nil
                }

                try await FFmpegRunner.run(
                    sourceURL: trimmedURL,
                    destinationURL: destination,
                    format: format,
                    totalDuration: duration
                ) { [weak self] fraction in
                    self?.state = .downloading(progress: fraction)
                }

                let item = DownloadItem(sourceURL: trimmedURL, format: format, destination: destination, completedAt: Date())
                recentDownloads.insert(item, at: 0)
                state = .finished(item)
            } catch {
                state = .failed(error.localizedDescription)
            }
        }
    }

    func revealInFinder(_ item: DownloadItem) {
        NSWorkspace.shared.activateFileViewerSelecting([item.destination])
    }

    func resetState() {
        state = .idle
    }

    private static func suggestedFileName(for sourceURL: String, format: OutputFormat) -> String {
        let base = URL(string: sourceURL)?.deletingPathExtension().lastPathComponent
        let safeBase = (base?.isEmpty == false ? base! : "StreamSnap-\(Int(Date().timeIntervalSince1970))")
        return "\(safeBase).\(format.fileExtension)"
    }
}
