import Foundation

enum StreamURLValidator {
    /// Basic sanity check: a well-formed http(s) URL. This intentionally does
    /// NOT attempt to detect or special-case any particular streaming
    /// platform — StreamSnap only works with direct, publicly reachable
    /// stream URLs (HLS/.m3u8, DASH/.mpd, progressive MP4/audio, etc.) that
    /// the user already has the right to access.
    static func isValid(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed),
              let scheme = url.scheme?.lowercased(),
              scheme == "http" || scheme == "https",
              url.host != nil else {
            return false
        }
        return true
    }
}
