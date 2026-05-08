# Contract: Reel Generation Pipeline

**Feature**: 001-quran-reel-generator
**Date**: 2026-05-07

## Overview

This contract defines the interface between the Flutter presentation layer and the domain/data layers for the Quran Reel Generator. It covers data access, audio streaming, video composition, and the wizard state machine.

---

## Data Access Contracts

### SurahRepository

```dart
abstract class SurahRepository {
  /// Returns all 114 Surahs with metadata.
  /// Data source: bundled quran_uthmani.json + surah_metadata.json
  Future<List<Surah>> getAllSurahs();

  /// Returns a single Surah by its ID (1-114).
  /// Throws: StateError if surahId is out of range.
  Future<Surah> getSurahById(int surahId);
}
```

### AyahRepository

```dart
abstract class AyahRepository {
  /// Returns all Ayahs for the given Surah.
  /// Data source: bundled quran_uthmani.json
  /// Throws: StateError if surahId is invalid.
  Future<List<Ayah>> getAyahsBySurah(int surahId);

  /// Returns a single Ayah by its global ID (1-6236).
  /// Throws: StateError if ayahId is out of range.
  Future<Ayah> getAyahById(int ayahId);
}
```

### ReciterRepository

```dart
abstract class ReciterRepository {
  /// Returns all available Reciters (2-3 in MVP).
  /// Data source: bundled reciter_config.json
  Future<List<Reciter>> getAllReciters();

  /// Returns the audio URL for a specific Ayah by a specific Reciter.
  /// Returns: HTTPS URL string
  /// Format: {reciter.audioBaseUrl}{surahId}/{numberInSurah}.mp3
  String getAudioUrl(Reciter reciter, Ayah ayah);
}
```

### TemplateRepository

```dart
abstract class TemplateRepository {
  /// Returns all available Templates (3+ in MVP).
  /// Data source: bundled template_config.json
  Future<List<Template>> getAllTemplates();

  /// Returns a single Template by its ID.
  /// Throws: StateError if templateId is not found.
  Future<Template> getTemplateById(String templateId);
}
```

---

## Audio Contracts

### AudioPreviewService

```dart
abstract class AudioPreviewService {
  /// Starts streaming audio preview for the given URL.
  /// Requires internet connectivity.
  /// Throws: NetworkException if offline.
  /// Returns: Stream position and duration info.
  Future<void> playPreview(String audioUrl);

  /// Pauses current preview playback.
  Future<void> pausePreview();

  /// Stops preview and releases resources.
  Future<void> stopPreview();

  /// Current playback position as a stream.
  Stream<Duration> get positionStream;

  /// Total audio duration once loaded.
  Future<Duration?> get duration;
}
```

---

## Video Generation Contract

### VideoComposer

```dart
abstract class VideoComposer {
  /// Generates an MP4 video from the provided configuration.
  ///
  /// Pipeline steps:
  /// 1. Download/cache reciter audio to local file
  /// 2. Render Ayah text to transparent PNG using Quranic font
  /// 3. Compose: background image + text overlay + audio
  /// 4. Encode to MP4 (H.264/AAC, 1080x1920, 30fps)
  /// 5. Write to local file
  ///
  /// Parameters:
  ///   - config: Complete ReelConfig with all selections
  ///   - onProgress: Callback with progress percentage (0.0-1.0)
  ///   - outputPath: Directory for output file
  ///
  /// Returns: Absolute path to generated MP4 file
  ///
  /// Throws:
  ///   - NetworkException: if audio download fails (offline)
  ///   - CompositionException: if FFmpeg command fails
  ///   - StorageException: if disk full or write permission denied
  ///
  /// Constraints:
  ///   - config MUST have all 4 selections (surah, ayah, reciter, template)
  ///   - Output format: MP4, H.264 video, AAC audio
  ///   - Resolution: 1080x1920 (9:16 vertical)
  ///   - Same inputs MUST produce visually identical output
  Future<String> generateVideo(
    ReelConfig config, {
    required void Function(double progress) onProgress,
    required String outputPath,
  });
}
```

### TextRenderer

```dart
abstract class TextRenderer {
  /// Renders Quranic Arabic text to a transparent PNG image.
  ///
  /// Uses Flutter Canvas with TextDirection.rtl and a dedicated
  /// Quranic font (Scheherazade New) for proper rendering of
  /// Arabic text with diacritics (tashkeel).
  ///
  /// Parameters:
  ///   - text: Uthmani Arabic text (MUST NOT be altered)
  ///   - config: TextOverlayConfig specifying position, size, color
  ///   - canvasWidth: Target width in pixels (1080)
  ///   - canvasHeight: Target height in pixels (1920)
  ///
  /// Returns: Raw PNG bytes (Uint8List)
  ///
  /// Constraints:
  ///   - Text MUST NOT be modified from source
  ///   - Font MUST support Uthmani script with full tashkeel
  ///   - Must handle RTL text direction
  Future<Uint8List> renderQuranText(
    String text,
    TextOverlayConfig config, {
    required int canvasWidth,
    required int canvasHeight,
  });
}
```

---

## Export Contract

### ExportService

```dart
abstract class ExportService {
  /// Saves the generated video to the device's public storage.
  ///
  /// Returns: Absolute path where the file was saved
  /// Throws: StorageException if write fails
  Future<String> saveToLocal(String videoFilePath);

  /// Shares the video via the system share sheet.
  ///
  /// Uses the platform share intent (share_plus).
  /// Throws: ShareException if sharing fails
  Future<void> shareVideo(String videoFilePath);
}
```

---

## Wizard State Machine

### WizardState

```
Steps (0-indexed):
  0 → Surah Selection
  1 → Ayah Selection
  2 → Reciter Selection
  3 → Template Selection
  4 → Preview
  5 → Generating
  6 → Export

State:
  - currentStep: int (0-6)
  - selectedSurah: Surah?
  - selectedAyah: Ayah?
  - selectedReciter: Reciter?
  - selectedTemplate: Template?
  - generatedVideoPath: String?
  - isGenerating: bool
  - generationProgress: double (0.0-1.0)

Transitions:
  - next(): Advance to next step (only if current step selection is valid)
  - back(): Return to previous step (preserves all selections)
  - canProceed(): bool — true when current step has a valid selection

Invariants:
  - canProceed for steps 0-3 requires respective selection to be non-null
  - Step 4 (Preview) requires all 4 selections
  - Step 5 (Generate) triggers VideoComposer.generateVideo()
  - Generation is non-blocking with progress callbacks
  - Back navigation never loses selections
```

---

## Error Handling Contract

All service methods that perform I/O MUST throw typed exceptions:

| Exception | When |
|-----------|------|
| `NetworkException` | No internet connectivity for audio streaming |
| `StorageException` | Disk full, write permission denied |
| `CompositionException` | FFmpeg video generation fails |
| `ShareException` | System share sheet unavailable or fails |
| `StateException` | Wizard state violates invariants (e.g., generate with missing selections) |

Error messages presented to users MUST be:
- In the user's language (Arabic/English based on device locale)
- Non-technical (no stack traces or error codes)
- Actionable (indicate what the user should do, e.g., "Check your internet connection and try again")