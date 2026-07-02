import Foundation

struct DownloadItem: Identifiable, Equatable {
    let id = UUID()
    let sourceURL: String
    let format: OutputFormat
    let destination: URL
    let completedAt: Date
}
