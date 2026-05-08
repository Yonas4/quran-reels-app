# Research: Quran Reel Generator

**Feature**: 001-quran-reel-generator
**Date**: 2026-05-07

## R1: On-Device Video Generation Library

**Decision**: ffmpeg_kit_flutter

**Rationale**: It is the only viable Flutter library for **on-device video creation** (encoding, compositing, muxing). Alternatives like media_kit are playback-only and have no video generation API. ffmpeg_kit_flutter provides the full FFmpeg CLI, enabling text overlay via drawtext/overlay filters, audio-video muxing, and MP4 export — all requirements for this feature.

**Alternatives considered**:
- **media_kit**: Playback-only library, no video creation capabilities. Not applicable.
- **Native platform channels (Android MediaMuxer / iOS AVAssetWriter)**: Would avoid FFmpeg binary size (~15-30MB) but requires separate per-platform implementations, increasing complexity and violating simplicity principle.
- **Server-side rendering**: Offloads processing but requires backend, violating the offline-first and no-backend constitution principles.

**Key commands**:

Text overlay on background + audio mux:
```bash
ffmpeg -loop 1 -framerate 30 -i background.png -i overlay.png -i audio.mp3 \
  -filter_complex "[0:v][1:v]overlay=0:0:format=auto" \
  -c:v libx264 -preset medium -crf 18 \
  -x264-params "force-cfr=1" \
  -c:a aac -b:a 192k -ac 2 -ar 44100 \
  -pix_fmt yuv420p -shortest -movflags +faststart output.mp4
```

**Caveats**:
- ffmpeg_kit_flutter v6.0.3 is marked discontinued on pub.dev. Still functional but no future updates guaranteed.
- Use `https` or `full_gpl` variant for H.264 encoding support.
- Bundle size is ~15-30MB for the FFmpeg binary.
- Large app size; use `--split-per-abi` or app bundles to reduce per-APK size.

## R2: Arabic/Quran Text Rendering on Video

**Decision**: Pre-render Arabic text to PNG via Flutter Canvas, then composite with FFmpeg overlay

**Rationale**: FFmpeg's `drawtext` filter has limited RTL and diacritics support, making it unreliable for Quranic Arabic with full tashkeel. Flutter's `Canvas.drawParagraph` with `TextDirection.rtl` and a dedicated Quranic font (Scheherazade New or KFGQPC Uthmanic Script HAFS) correctly handles BiDi, diacritics, and ligatures. Pre-rendering to a transparent PNG and overlaying via FFmpeg's `overlay` filter is the most reliable approach.

**Alternatives considered**:
- **FFmpeg drawtext**: Poor Arabic/RTL support, unreliable diacritics rendering. Risk of text distortion, violating the Reverence First principle.
- **FFmpeg libass subtitles**: Better RTL than drawtext but still less reliable than Flutter Canvas for Quranic text. Complex setup.

**Font recommendation**: Scheherazade New (SIL International) — open source, specifically designed for Quranic Arabic with full diacritics. KFGQPC Uthmanic Script HAFS as alternative for Uthmani style.

**Caveats**:
- Must use `TextDirection.rtl` in ParagraphBuilder for correct Arabic rendering.
- Test with full tashkeel strings to verify glyph positioning.
- Generate text overlay images at the target video resolution (1080x1920 for 9:16).

## R3: Audio Streaming

**Decision**: just_audio for audio preview; download to local file for FFmpeg muxing

**Rationale**: just_audio (v0.10.5) is the most mature Flutter audio package for URL streaming with seeking, duration retrieval, and position streams. For video composition, the audio must be downloaded to a local file before passing to FFmpeg — just_audio cannot provide raw audio bytes. Use `LockCachingAudioSource` to cache streamed audio, then reuse the cached file path for FFmpeg input.

**Alternatives considered**:
- **audioplayers**: Less mature streaming API, no gapless playlists, not a Flutter Favorite package.
- **Native ExoPlayer/AVPlayer**: More control but significant per-platform implementation cost.

**Caveats**:
- Android requires `android:usesCleartextTraffic="true"` or network security config for HTTP audio URLs.
- Audio file must be fully cached before FFmpeg can use it as input.
- Duration retrieval via `setUrl()` return value for determining video length.

## R4: State Management

**Decision**: Riverpod (flutter_riverpod) with Notifier pattern

**Rationale**: For a step-by-step wizard with back-navigation and state preservation, Riverpod's `Notifier` pattern provides the cleanest approach. A single `WizardNotifier` holds all selection state (Surah, Ayah, Reciter, Template) across steps, naturally preserving state when navigating back. Less boilerplate than BLoC for this pattern.

**Alternatives considered**:
- **BLoC/Cubit**: Requires Event/State class hierarchies per step, adding significant boilerplate for a linear wizard. Better suited for complex event-driven flows.
- **Provider**: Legacy, less type-safe, no built-in async support comparable to Riverpod's AsyncNotifier.

**Wizard state pattern**:
```dart
@riverpod
class WizardNotifier extends _$WizardNotifier {
  @override
  WizardState build() => WizardState(currentStep: 0);

  void next() => state = state.copyWith(currentStep: state.currentStep + 1);
  void back() => state = state.copyWith(currentStep: state.currentStep - 1);
  void selectSurah(Surah surah) => state = state.copyWith(selectedSurah: surah);
  // ...
}
```

## R5: Local Quran Data Source

**Decision**: Bundle Alquran Cloud JSON (Uthmani edition) as local asset

**Rationale**: The Alquran Cloud API provides the complete Quran in Uthmani script with full diacritics as structured JSON (~1.3MB). This can be downloaded once and bundled in `assets/data/quran_uthmani.json`. No API dependency at runtime, satisfying the offline-first principle for browsing data.

**Alternatives considered**:
- **Tanzil.net text files**: Verified Uthmani text but requires parsing from TSV/text format to app-usable JSON. More work, same result.
- **Quran.com API**: API-only, requires internet. Violates offline-first principle.
- **Custom JSON**: Re-inventing the wheel; Alquran Cloud provides authoritative, verified data.

**Data format**: Each Surah as an object with nested Ayahs, including Uthmani Arabic text with full diacritics.

**Caveats**:
- Must verify Uthmani text accuracy — diacritics placement must be exact for Quranic content.
- Separate JSON needed for Surah metadata (names in Arabic/transliteration, Ayah counts, revelation type).
- Reciter audio URLs are stored as references (not bundled).

## R6: Deterministic Video Output

**Decision**: Fixed FFmpeg encoding parameters to ensure reproducible output

**Rationale**: The constitution's Deterministic Output principle requires same inputs → same output. While byte-for-byte identical output across different devices is extremely difficult (floating-point differences in encoders), using fixed CRF, preset, framerate, audio codec, and `-map_metadata -1` ensures visually/audibly identical output. True byte-level determinism requires `-threads 1` (very slow) and is generally unnecessary for this use case.

**Key FFmpeg flags for reproducibility**:
- `-preset medium` — fixed encoding speed
- `-crf 18` — fixed quality, no bitrate variance
- `-x264-params force-cfr=1` — constant frame rate
- `-framerate 30` — fixed frame rate
- `-ac 2 -ar 44100` — fixed audio channels and sample rate
- `-map_metadata -1` — strip timestamps/encoder info
- `-movflags +faststart` — consistent MP4 structure for sharing
- `-pix_fmt yuv420p` — compatibility with social platforms

**Caveats**:
- Different ARM architectures may produce slightly different DCT coefficients. Use `-threads 1` if byte-identical match across devices is required.
- For this app, visual/audio equivalence (not byte-identical) satisfies the Deterministic Output principle.