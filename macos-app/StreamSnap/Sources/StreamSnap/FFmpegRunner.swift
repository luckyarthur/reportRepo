import Foundation

enum FFmpegError: LocalizedError {
    case binaryNotFound(String)
    case processFailed(String)

    var errorDescription: String? {
        switch self {
        case .binaryNotFound(let name):
            return "Could not find \"\(name)\". Install it with Homebrew: brew install ffmpeg"
        case .processFailed(let message):
            return message
        }
    }
}

/// Thin wrapper around the `ffmpeg`/`ffprobe` command line tools. StreamSnap
/// does not bundle these binaries; it shells out to a Homebrew install so we
/// stay a small, native SwiftUI front end rather than redistributing GPL
/// binaries or codec logic ourselves.
enum FFmpegRunner {

    /// Common install locations, checked before falling back to `PATH`.
    private static let searchPaths = [
        "/opt/homebrew/bin",
        "/usr/local/bin",
        "/usr/bin"
    ]

    static func locateBinary(named name: String) -> String? {
        let fileManager = FileManager.default
        for directory in searchPaths {
            let candidate = directory + "/" + name
            if fileManager.isExecutableFile(atPath: candidate) {
                return candidate
            }
        }
        if let pathEnv = ProcessInfo.processInfo.environment["PATH"] {
            for directory in pathEnv.split(separator: ":") {
                let candidate = String(directory) + "/" + name
                if fileManager.isExecutableFile(atPath: candidate) {
                    return candidate
                }
            }
        }
        return nil
    }

    /// Probes the source's duration (in seconds) via ffprobe, used to turn
    /// ffmpeg's `out_time` progress output into a 0...1 fraction. Returns
    /// nil if the duration can't be determined (e.g. a live stream), in
    /// which case the UI falls back to an indeterminate spinner.
    static func probeDuration(sourceURL: String) async throws -> Double? {
        guard let ffprobe = locateBinary(named: "ffprobe") else {
            throw FFmpegError.binaryNotFound("ffprobe")
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: ffprobe)
        process.arguments = [
            "-v", "error",
            "-show_entries", "format=duration",
            "-of", "default=noprint_wrappers=1:nokey=1",
            sourceURL
        ]

        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = Pipe()

        try process.run()
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()

        guard let text = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
              let duration = Double(text), duration.isFinite, duration > 0 else {
            return nil
        }
        return duration
    }

    /// Downloads/transcodes `sourceURL` to `destinationURL` using the
    /// arguments appropriate for `format`. Calls `onProgress` with a 0...1
    /// fraction on the main actor as ffmpeg reports progress; passes `nil`
    /// when progress can't be determined (e.g. unknown duration).
    static func run(
        sourceURL: String,
        destinationURL: URL,
        format: OutputFormat,
        totalDuration: Double?,
        onProgress: @escaping (Double?) -> Void
    ) async throws {
        guard let ffmpeg = locateBinary(named: "ffmpeg") else {
            throw FFmpegError.binaryNotFound("ffmpeg")
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: ffmpeg)
        process.arguments = [
            "-y",
            "-i", sourceURL
        ] + format.ffmpegArguments() + [
            "-progress", "pipe:1",
            "-nostats",
            destinationURL.path
        ]

        let progressPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = progressPipe
        process.standardError = errorPipe

        progressPipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            guard !data.isEmpty, let chunk = String(data: data, encoding: .utf8) else { return }
            for line in chunk.split(separator: "\n") where line.hasPrefix("out_time_ms=") {
                let value = line.replacingOccurrences(of: "out_time_ms=", with: "")
                if let microseconds = Double(value) {
                    let elapsedSeconds = microseconds / 1_000_000
                    let fraction = totalDuration.map { min(elapsedSeconds / $0, 1.0) }
                    DispatchQueue.main.async { onProgress(fraction) }
                }
            }
        }

        var stderrOutput = Data()
        errorPipe.fileHandleForReading.readabilityHandler = { handle in
            stderrOutput.append(handle.availableData)
        }

        try process.run()
        process.waitUntilExit()
        progressPipe.fileHandleForReading.readabilityHandler = nil
        errorPipe.fileHandleForReading.readabilityHandler = nil

        guard process.terminationStatus == 0 else {
            let message = String(data: stderrOutput, encoding: .utf8) ?? "ffmpeg exited with status \(process.terminationStatus)"
            throw FFmpegError.processFailed(message)
        }
    }
}
