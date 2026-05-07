# Implementation Plan: Quran Reel Generator

**Branch**: `001-quran-reel-generator` | **Date**: 2026-05-07 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-quran-reel-generator/spec.md`

## Summary

Build the Quran Reels App MVP — a Flutter mobile application enabling users to create short-form Quran video reels through a step-by-step wizard: select Surah, select Ayah, select Reciter, select Template, preview, generate, and export. Video generation uses on-device FFmpeg composition with streamed reciter audio and bundled Uthmani Arabic text data.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x
**Primary Dependencies**: flutter_riverpod (state), ffmpeg_kit_flutter (video generation), just_audio (audio streaming/preview), path_provider (file system), share_plus (export)
**Storage**: Local JSON assets (Quran text), local image/video assets (templates), streamed audio URLs (reciters), device local storage (generated MP4)
**Testing**: flutter_test (unit/widget), integration_test (integration)
**Target Platform**: Android 6.0+ (API 23+), iOS 15+
**Project Type**: Mobile app
**Performance Goals**: Video generation < 60 seconds per single-Ayah reel on mid-range device, full creation flow < 2 minutes
**Constraints**: Offline-capable for browsing (Surah/Ayah data bundled), internet required for reciter audio streaming, deterministic video output for same inputs, on-device rendering only (no backend), vertical 9:16 MP4 output
**Scale/Scope**: 114 Surahs, 6236 Ayahs, 2-3 Reciters, 3+ templates, single-user local app (no concurrent users)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Reverence First | ✅ PASS | Arabic-only text overlay, no Quran distortion, no unrelated audio mixing |
| II. Simplicity Over Complexity | ✅ PASS | Step-by-step wizard with minimal screens, single selection per item |
| III. Creation Tool, Not Social Network | ✅ PASS | No feeds, comments, likes; creation and export only |
| IV. Offline-first MVP Mindset | ⚠️ CONDITIONAL | Surah/Ayah data bundled locally; reciter audio requires internet (streaming). Core browsing works offline; audio preview and video generation require connectivity. Justified: bundling all reciter audio is impractical (tens of MB per reciter per Ayah). |
| V. Deterministic Output | ✅ PASS | FFmpeg with fixed encoding params produces reproducible output; same inputs yield same video |
| VI. Performance Awareness | ✅ PASS | On-device FFmpeg with lightweight composition; pre-rendered text overlay avoids runtime rendering overhead |

**Re-check after Phase 1**: See post-design review below.

## Project Structure

### Documentation (this feature)

```text
specs/001-quran-reel-generator/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   └── reel-generation.md
└── checklists/
    └── requirements.md
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── constants/
│   │   └── app_constants.dart
│   └── utils/
│       ├── quran_text_renderer.dart
│       └── video_composer.dart
├── features/
│   ├── surah/
│   │   ├── data/
│   │   │   ├── models/surah_model.dart
│   │   │   ├── models/ayah_model.dart
│   │   │   └── repositories/surah_repository.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       ├── surah.dart
│   │   │       └── ayah.dart
│   │   └── presentation/
│   │       ├── screens/surah_selection_screen.dart
│   │       └── screens/ayah_selection_screen.dart
│   ├── reciter/
│   │   ├── data/
│   │   │   ├── models/reciter_model.dart
│   │   │   └── repositories/reciter_repository.dart
│   │   ├── domain/
│   │   │   └── entities/reciter.dart
│   │   └── presentation/
│   │       └── screens/reciter_selection_screen.dart
│   ├── template/
│   │   ├── data/
│   │   │   ├── models/template_model.dart
│   │   │   └── repositories/template_repository.dart
│   │   ├── domain/
│   │   │   └── entities/template.dart
│   │   └── presentation/
│   │       └── screens/template_selection_screen.dart
│   └── reel/
│       ├── data/
│       │   └── repositories/reel_repository.dart
│       ├── domain/
│       │   └── entities/reel.dart
│       └── presentation/
│           ├── screens/preview_screen.dart
│           ├── screens/generation_screen.dart
│           └── screens/export_screen.dart
├── shared/
│   ├── widgets/
│   └── providers/
│       └── wizard_provider.dart
├── assets/
│   ├── data/
│   │   └── quran_uthmani.json
│   ├── fonts/
│   │   └── (Quranic Arabic fonts)
│   └── images/
│       └── templates/
│           ├── template_mosque.png
│           ├── template_kaaba.png
│           └── template_nature.png
├── pubspec.yaml
└── main.dart

test/
├── unit/
│   ├── features/surah/
│   ├── features/reciter/
│   ├── features/template/
│   └── features/reel/
├── widget/
│   └── features/
└── integration/
    └── app_test.dart
```

**Structure Decision**: Mobile app with feature-based modular structure following Clean Architecture. Each feature has data/domain/presentation layers. This aligns with the constitution's architectural constraint of feature-based modular structure with domain logic independent of UI.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Internet required for reciter audio (violates strict offline-first) | Streaming 2-3 reciters' full audio per-Ayah would require ~30MB+ bundled per reciter | Bundling audio per reciter impractical for download size; Quran text data (1.3MB JSON) remains offline |

## Post-Design Constitution Review

*Re-checked after Phase 1 design completion.*

| Principle | Status | Design Assessment |
|-----------|--------|-------------------|
| I. Reverence First | ✅ PASS | Arabic-only text rendering via Scheherazade New font with full tashkeel support; TextRenderer contract enforces no text alteration; no unrelated audio mixing in FFmpeg pipeline |
| II. Simplicity Over Complexity | ✅ PASS | Linear wizard flow (7 steps max); single Riverpod Notifier for state; no unnecessary user flows |
| III. Creation Tool, Not Social Network | ✅ PASS | Data model has no social entities; contracts cover creation and export only; ExportService provides save + share via system sheet only |
| IV. Offline-first MVP Mindset | ⚠️ CONDITIONAL (justified) | Quran text + Surah metadata + templates all bundled locally (~5-6MB); only reciter audio requires internet. Complexity Tracking entry justifies this tradeoff. |
| V. Deterministic Output | ✅ PASS | VideoComposer contract specifies fixed FFmpeg params (CRF 18, preset medium, force-cfr=1, no metadata); same ReelConfig produces identical output |
| VI. Performance Awareness | ✅ PASS | 1080x1920 composition target; pre-rendered text PNG avoids runtime font rendering; progress callback during generation; estimated <60s generation time |

**Post-design verdict**: All principles pass. Principle IV conditional status is justified and tracked in Complexity Tracking. No changes required.