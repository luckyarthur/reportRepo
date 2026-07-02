# StreamSnap

A small, native macOS utility to save a video stream you already have the
right to access — as a full **MP4** video, or as **MP3** audio only.

## Scope & legal notice

StreamSnap works with **direct, publicly reachable stream URLs**
(HLS `.m3u8`, DASH `.mpd`, or a progressive MP4/audio URL) — for example
your own hosted content, creator/CDN links you're authorized to use,
public livestreams, podcasts, or public-domain/Creative-Commons media.

StreamSnap does **not** implement, and will not add, DRM circumvention
(FairPlay/Widevine/PlayReady license or key extraction) or platform-specific
scraping for DRM-protected commercial services. **You are responsible for
having the rights to download whatever URL you provide.**

## How it works

StreamSnap is a thin SwiftUI front end. All the actual stream fetching and
transcoding is delegated to [`ffmpeg`](https://ffmpeg.org)/`ffprobe`, which
the app shells out to via `Process` — StreamSnap does not bundle or
reimplement any codec/container logic itself.

- **MP4**: `ffmpeg -i <url> -c copy -bsf:a aac_adtstoasc <output>.mp4` (stream copy/remux; no re-encoding, so it's fast and lossless for compatible sources).
- **MP3**: `ffmpeg -i <url> -vn -acodec libmp3lame -q:a 2 <output>.mp3` (drops video, encodes audio to MP3).

Progress is read from ffmpeg's `-progress pipe:1` output and, when the
source duration can be probed via `ffprobe`, shown as a determinate
progress bar; otherwise the UI falls back to an indeterminate spinner
(e.g. for live streams with no known end time).

## Requirements

- macOS 13 Ventura or later.
- Xcode 15+ or the Swift 5.9+ command line tools.
- `ffmpeg` installed and on your `PATH` (recommended: `brew install ffmpeg`).

## Build & run

```sh
cd macos-app/StreamSnap
swift build
swift run
```

Or open the package folder directly in Xcode (`File > Open…` on
`Package.swift`) and run the `StreamSnap` scheme.

> This app was written and reviewed in a Linux sandbox with no
> Xcode/AppKit toolchain, so it has **not** been compiled or run yet.
> Please build it locally on macOS and file/fix any compile errors —
> the code follows standard SwiftUI/Foundation APIs throughout, but a
> first local build is the way to confirm it.

## Project layout

```
macos-app/StreamSnap/
├── Package.swift                          # SPM manifest (macOS 13+ executable target)
├── StreamSnap.entitlements                # Sandbox entitlements template (see note below)
├── README.md
└── Sources/StreamSnap/
    ├── StreamSnapApp.swift                # @main App entry point / window scene
    ├── ContentView.swift                  # Main (and only) window UI
    ├── DownloadViewModel.swift            # ObservableObject: state, actions
    ├── DownloadItem.swift                 # Completed-download record
    ├── OutputFormat.swift                 # mp4 / mp3 model + ffmpeg args
    ├── StreamURLValidator.swift           # Basic http(s) URL sanity check
    └── FFmpegRunner.swift                 # Process wrapper around ffmpeg/ffprobe
```

## UI / Apple HIG notes

- Single fixed-size window (~480pt wide), no sidebar/toolbar clutter — this
  is a single-purpose utility, not a document-based app.
- Native controls only: `TextField`, segmented `Picker`, bordered-prominent
  `Button`, `ProgressView` — no custom-drawn chrome.
- SF Symbols (`film`, `music.note`, `arrow.down.circle.fill`,
  `checkmark.circle.fill`) for iconography, consistent with system apps.
- Follows system Light/Dark appearance automatically (no custom colors).
- Standard `NSOpenPanel` for choosing the destination folder, defaulting to
  `~/Downloads`.

## Sandbox note

`StreamSnap.entitlements` is included as a starting point for later
distribution as a signed, sandboxed `.app` (e.g. via Xcode + notarization).
Note that the **App Sandbox restricts launching external executables**
outside the app bundle, so a sandboxed build cannot shell out to a
Homebrew-installed `ffmpeg` as-is. Shipping a sandboxed version would
require either bundling a signed `ffmpeg` binary inside the app (and
adding it as a bundled resource + adjusting `FFmpegRunner`'s search
path), or dropping App Sandbox for a direct/notarized-outside-the-App-Store
distribution. This is deferred — the current build runs unsandboxed via
`swift run`/Xcode, which is fine for local/personal use.

## MVP feature status

Implemented:
- URL input with basic validation.
- MP4 / MP3 output format picker.
- Destination folder picker (defaults to Downloads).
- Download with progress (determinate when duration is known, spinner otherwise).
- Error surfacing in the UI (e.g. missing `ffmpeg`, invalid stream).
- Recent-downloads list with "Show in Finder".

Deferred (not implemented, candidates for follow-up):
- Download queue (currently one download at a time).
- Cancel-in-progress button.
- Persisting recent downloads across app launches.
- Code signing / notarization / sandboxed distribution (see above).
- Automated tests (would need a macOS CI runner with Xcode).
