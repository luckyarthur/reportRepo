# Task: Design and Build a macOS App — "StreamSnap"

Write the result to `output.md` in this folder. Unlike the report-writing tasks elsewhere in this repo, this task has a real code deliverable in addition to the write-up.

## Objective
Build a simple macOS utility app that lets a user paste a video **stream URL**, choose an output format, and save the result locally:
- **MP4** — full video (+ audio).
- **MP3** — audio only, extracted from the stream.

The UI must be minimal and follow Apple's Human Interface Guidelines (native controls, standard window chrome, light/dark mode support, no custom chrome-heavy UI).

## Scope & legal boundary (must follow)
This app targets **direct, publicly accessible stream URLs** the user already has the right to access (e.g., HLS/`.m3u8`, DASH/`.mpd`, or progressive MP4/audio URLs — the kind used for open web video, creator-owned content, podcasts, public livestreams, self-hosted media, Creative-Commons/public-domain sources).
- Do **not** implement or document any DRM circumvention (Widevine/FairPlay/PlayReady decryption, license-key extraction, etc.).
- Do **not** hardcode scraping logic for specific paid/DRM-protected streaming platforms (Netflix, Disney+, Hulu, etc.).
- Include an in-app/README disclaimer that the user is responsible for having the rights to download the content they provide a URL for.

## Phase 1 — Plan
In `output.md`, write a short product/technical plan covering:
- App name, one-line pitch, target macOS version.
- Feature list for the MVP (URL input, format picker, destination picker, download with progress, error handling, recent-downloads list).
- Architecture: SwiftUI UI layer, an `ObservableObject` view model, and a backend process runner that shells out to `ffmpeg`/`ffprobe` (assumed installed via Homebrew) to fetch/remux/transcode the stream.
- UI plan mapped to Apple HIG (window size, controls used, SF Symbols, dark mode, no non-standard chrome).
- Explicit call-out of the legal/scope boundary above.

## Phase 2 — Execute
Implement the app as a Swift Package Manager executable target (buildable with `swift build` / `swift run` on macOS with Xcode command line tools, or opened directly in Xcode) under `macos-app/StreamSnap/`:
- `Package.swift`
- `Sources/StreamSnap/` — SwiftUI app entry point, main view, view model, ffmpeg process wrapper, output-format model.
- `README.md` — prerequisites (macOS 13+, Swift 5.9+, Homebrew `ffmpeg`), how to build/run, and the same legal disclaimer.

Note: the sandbox this task may run in is Linux-based and cannot compile SwiftUI/AppKit code. Write correct, idiomatic Swift and document that a macOS machine with Xcode/Swift toolchain is required to actually build and run it; do not claim it was compiled/tested if it wasn't.

## Phase 3 — Deliverable
`output.md` should end with:
- Confirmation of what was implemented vs. deferred (MVP scope).
- Exact build/run commands.
- File map of everything added under `macos-app/StreamSnap/`.
- Any follow-up work needed to ship it (code signing, notarization, sandbox entitlements, App Store review considerations if ever distributed).

## Style
- `output.md` should be a concise plan + build report (not a long-form essay) — headings, bullet lists, a file tree, and the build commands are more useful here than prose.
