# PlayKit Demo

Lightweight showcase of PlayKit capabilities inside a minimal SwiftUI app—meant for quick exploration, not a production implementation guide. This sample mirrors the language and flow of the PlayKit README so it is easy to jump between the SDK docs and this example. For SDK details, see the PlayKit repo: [PlayKit SDK](https://github.com/TelemTobi/PlayKit-Demo.git).

## What this demo shows
- Two tabs, one per `PlaylistType`:
  - Stories: `PlaylistView(type: .tapThrough)` with three playlists you can page through horizontally. Injects a custom item and a forced error item to demo state handling, plus basic controls (play/pause, seek, jump ±2, rate change on long-press) and a scrubber overlay.
  - Reels: `PlaylistView(type: .verticalFeed)` with a stacked feed and an overlay showing index, timecode, and a scrubber.
- `ContentView` loads media from `Utility/VideoUrls.json`, converts them to `PlaylistItem` (.video for m3u8/mp4, .image otherwise), and passes them to each controller.
- Simple utilities: `SliderView` for scrubbing, `onFirstAppear` helper, safe subscripts and clamping, and an `EnvironmentValue` for focus so playback pauses when a tab loses focus.

## Running it
- Open `PlayKit-Demo.xcodeproj` in Xcode and run on iOS simulator or device.
- Ensure PlayKit is available to the project (via Swift Package Manager as in the project settings).
- Press play: switch between the Stories and Reels tabs to see the different playlist behaviors.

## Things to try
- Tap left/right to move through stories, or long-press to change rate.
- Drag the scrubber to seek; observe loading/error states on the injected items.
- Switch tabs to see focus handoff pause/resume playback automatically.

