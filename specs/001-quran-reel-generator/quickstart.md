# Quickstart: Quran Reel Generator

**Feature**: 001-quran-reel-generator
**Date**: 2026-05-07

## Prerequisites

- Flutter SDK 3.x (Dart 3.x)
- Android Studio / VS Code with Flutter extension
- Android SDK (API 23+) or iOS Simulator (iOS 15+)
- An emulator or physical device for testing

## Setup

```bash
# Clone and enter the project
git clone <repo-url> quran-reels && cd quran-reels

# Install dependencies
flutter pub get

# Generate Riverpod code (if using riverpod_generator)
dart run build_runner build --delete-conflicting-outputs

# Run on connected device/emulator
flutter run
```

## Project Structure

```text
lib/
├── core/                    # Theme, constants, utilities
├── features/
│   ├── surah/               # Surah/Ayah selection
│   │   ├── data/            # Models & repositories
│   │   ├── domain/          # Entities
│   │   └── presentation/    # Screens & widgets
│   ├── reciter/             # Reciter selection
│   ├── template/            # Template selection
│   └── reel/                # Preview, generation, export
├── shared/                  # Shared widgets & providers (wizard state)
├── assets/
│   ├── data/                # quran_uthmani.json, surah_metadata.json
│   ├── fonts/               # Quranic Arabic fonts
│   └── images/templates/    # Background template images
└── main.dart
```

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management (wizard flow) |
| `riverpod_annotation` | Riverpod code generation |
| `ffmpeg_kit_flutter` | On-device video generation |
| `just_audio` | Audio streaming preview |
| `share_plus` | System share sheet for video export |
| `path_provider` | Local file system paths |
| `http` | Download reciter audio for composition |
| `json_annotation` | JSON serialization |

## Running Tests

```bash
# Unit tests
flutter test

# Integration tests (requires device/emulator)
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

## Development Workflow

1. **Start wizard flow**: Home screen → Surah selection
2. **Step through**: Surah → Ayah → Reciter → Template
3. **Preview**: Combined text + audio + background preview
4. **Generate**: FFmpeg composes MP4 video
5. **Export**: Save locally or share via system sheet

## Common Development Tasks

### Adding a New Template

1. Add background image to `assets/images/templates/`
2. Add entry to `template_config.json` with positioning config
3. Run `flutter pub get` to register new asset

### Adding a New Reciter

1. Add entry to `reciter_config.json` with audio base URL
2. Ensure audio URLs follow the pattern: `{baseUrl}{surahId}/{numberInSurah}.mp3`
3. Test audio streaming with `just_audio` before committing

### Modifying Text Overlay Positioning

1. Edit `TextOverlayConfig` in `template_config.json`
2. Adjust `x`, `y`, `maxWidth`, `fontSize`, `textAlign` per template
3. Re-run video generation to verify overlay placement

## Building for Release

```bash
# Android (with split per ABI for smaller APK)
flutter build appbundle --split-per-abi

# iOS
flutter build ios
```

**Note**: ffmpeg_kit_flutter adds ~15-30MB to the app bundle. The `--split-per-abi` flag reduces per-device download size significantly.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Audio preview not working on Android | Check `android:usesCleartextTraffic="true"` in AndroidManifest or ensure HTTPS URLs |
| Video generation fails | Check FFmpeg logs; ensure audio file is fully cached before composition |
| Arabic text renders incorrectly | Verify font file supports Uthmani script with full tashkeel |
| App size too large | Use `--split-per-abi` and consider using `ffmpeg_kit_flutter_min` if full codecs not needed |
| Share sheet not appearing | Verify `share_plus` permissions in AndroidManifest/Info.plist |