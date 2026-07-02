import Foundation

enum OutputFormat: String, CaseIterable, Identifiable {
    case mp4
    case mp3

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .mp4: return "Video (MP4)"
        case .mp3: return "Audio Only (MP3)"
        }
    }

    var fileExtension: String {
        rawValue
    }

    var symbolName: String {
        switch self {
        case .mp4: return "film"
        case .mp3: return "music.note"
        }
    }

    /// ffmpeg arguments appended after `-i <input>` and before the output path.
    func ffmpegArguments() -> [String] {
        switch self {
        case .mp4:
            // Try to remux without re-encoding first; FFmpegRunner falls back
            // to a re-encode if a stream-copy remux fails.
            return ["-c", "copy", "-bsf:a", "aac_adtstoasc"]
        case .mp3:
            return ["-vn", "-acodec", "libmp3lame", "-q:a", "2"]
        }
    }
}
