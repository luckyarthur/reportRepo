# StreamSnap — Plan & Build Report

**Date:** 2026-07-02

## 1. Plan

**App name:** StreamSnap
**Pitch:** A single-purpose macOS utility — paste a direct video stream URL, pick MP4 (video) or MP3 (audio only), and save it locally.
**Target platform:** macOS 13 Ventura+, Swift 5.9+.

### Scope & legal boundary
StreamSnap only targets **direct, publicly reachable stream URLs** (HLS `.m3u8`, DASH `.mpd`, progressive MP4/audio) that the user already has the right to access — e.g. self-hosted media, creator/CDN links, public livestreams, podcasts, Creative-Commons/public-domain content. It does not implement or plan to implement DRM circumvention (FairPlay/Widevine/PlayReady) or platform-specific scraping of DRM-protected commercial services. The user is responsible for having the rights to whatever URL they provide; this is stated in the README and in-app helper text.

### MVP feature list
- URL text field with basic http(s) validation.
- Output format picker: Video (MP4) / Audio Only (MP3).
- Destination folder picker (defaults to `~/Downloads`).
- Download action with progress (determinate when source duration is probeable, indeterminate spinner otherwise — e.g. live streams).
- Error surfacing (missing `ffmpeg`, invalid URL, ffmpeg failure).
- Recent-downloads list with "Show in Finder".

### Architecture
- **UI layer:** SwiftUI, single fixed-size window, native controls only (`TextField`, segmented `Picker`, `Button`, `ProgressView`) — no custom chrome, per Apple HIG.
- **State:** one `@MainActor` `ObservableObject` (`DownloadViewModel`) holding form state, download state (`idle` / `downloading` / `finished` / `failed`), and recent downloads.
- **Backend:** no bundled codec/network stack — shells out to Homebrew-installed `ffmpeg`/`ffprobe` via `Process`:
  - `ffprobe` first, to get source duration (drives a determinate progress bar).
  - `ffmpeg -i <url> -c copy -bsf:a aac_adtstoasc <out>.mp4` for video (stream-copy remux, no re-encode).
  - `ffmpeg -i <url> -vn -acodec libmp3lame -q:a 2 <out>.mp3` for audio-only.
  - Progress parsed from `-progress pipe:1` (`out_time_ms`).

### UI plan vs. Apple HIG
- Single ~480pt-wide fixed window; no sidebar/toolbar — it's a utility, not a document app.
- SF Symbols for iconography (`film`, `music.note`, `arrow.down.circle.fill`, `checkmark.circle.fill`).
- Automatic Light/Dark mode support (no custom colors).
- Standard `NSOpenPanel` for destination selection.

## 2. What was built

Implemented as a Swift Package Manager executable target (not a hand-written `.xcodeproj`, which is easy to corrupt by hand and wasn't necessary — SPM executable targets with a `SwiftUI.App` build and run directly via `swift run` or by opening `Package.swift` in Xcode).

```
macos-app/StreamSnap/
├── Package.swift
├── StreamSnap.entitlements
├── README.md
└── Sources/StreamSnap/
    ├── StreamSnapApp.swift        # @main App entry point
    ├── ContentView.swift          # main window UI
    ├── DownloadViewModel.swift    # state + actions (ObservableObject)
    ├── DownloadItem.swift         # completed-download record
    ├── OutputFormat.swift         # mp4/mp3 model + ffmpeg args
    ├── StreamURLValidator.swift   # basic URL validation
    └── FFmpegRunner.swift         # Process wrapper around ffmpeg/ffprobe
```

All MVP features from the plan are implemented. Deferred for follow-up: a download queue (currently one at a time), a cancel button, persisting recent downloads across launches, and code signing/notarization/sandboxed distribution.

## 3. Build & run

Requirements: macOS 13+, Xcode 15+ (or Swift 5.9+ CLT), and `ffmpeg` on `PATH` (`brew install ffmpeg`).

```sh
cd macos-app/StreamSnap
swift build
swift run
```

Or open the `macos-app/StreamSnap` folder's `Package.swift` directly in Xcode and run the `StreamSnap` scheme.

**Important caveat:** this was written and reviewed in a Linux sandbox with no Xcode/AppKit/SwiftUI toolchain available (confirmed: no `swift`/`swiftc` binary in this environment), so **the code has not been compiled or run**. It follows standard, idiomatic SwiftUI/Foundation APIs, but please do a first local build on macOS and treat any compiler errors as expected first-pass feedback rather than a sign the plan was wrong.

## 4. Follow-up work before shipping

- First local build/run on macOS to shake out any compile issues.
- Add a cancel-in-progress control and a simple download queue if multiple downloads are desired.
- Persist recent downloads (e.g. `UserDefaults` or a small JSON file) across launches.
- Decide on distribution path: signed + notarized `.app` outside the Mac App Store is the simplest route given the sandbox/`ffmpeg`-launching conflict noted in the README; shipping inside the App Store sandbox would require bundling a signed `ffmpeg` binary (or an XPC helper) instead of relying on a Homebrew install.
- Automated tests would need a macOS CI runner with Xcode — not available in this sandbox.
