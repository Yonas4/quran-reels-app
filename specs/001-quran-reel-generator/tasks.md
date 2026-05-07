---

description: "Task list for Quran Reel Generator MVP"
---

# Tasks: Quran Reel Generator

**Input**: Design documents from `/specs/001-quran-reel-generator/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Not explicitly requested in the feature specification; test tasks are NOT included.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Mobile app**: `lib/` at repository root
- Feature-based structure per plan.md

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create Flutter project with pubspec.yaml and configure dependencies (flutter_riverpod, ffmpeg_kit_flutter, just_audio, share_plus, path_provider, http, json_annotation) in pubspec.yaml
- [ ] T002 Create project directory structure per implementation plan: lib/core/, lib/features/surah/, lib/features/reciter/, lib/features/template/, lib/features/reel/, lib/shared/, lib/assets/ in lib/
- [ ] T003 [P] Configure app theme with minimal calm UI, Quran-optimized typography, and 9:16 preview dimensions in lib/core/theme/app_theme.dart
- [ ] T004 [P] Define app constants (video resolution 1080x1920, FPS 30, CRF 18, codec settings) in lib/core/constants/app_constants.dart
- [ ] T005 [P] Configure Flutter assets (fonts, JSON data files, template images) and register Scheherazade New font in pubspec.yaml
- [ ] T006 Create app entry point with Riverpod provider scope and home screen shell in lib/main.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core domain entities, data files, repositories, and wizard state that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T007 [P] Create Surah domain entity with id, nameArabic, nameTransliteration, nameTranslation, ayahCount, revelationType, revelationOrder in lib/features/surah/domain/entities/surah.dart
- [ ] T008 [P] Create Ayah domain entity with id, surahId, numberInSurah, textUthmani, juz, page in lib/features/surah/domain/entities/ayah.dart
- [ ] T009 [P] Create SurahModel data model with fromJson/toJson in lib/features/surah/data/models/surah_model.dart
- [ ] T010 [P] Create AyahModel data model with fromJson/toJson in lib/features/surah/data/models/ayah_model.dart
- [ ] T011 [P] Create Reciter domain entity with id, name, audioBaseUrl, style in lib/features/reciter/domain/entities/reciter.dart
- [ ] T012 [P] Create ReciterModel data model with fromJson/toJson in lib/features/reciter/data/models/reciter_model.dart
- [ ] T013 [P] Create Template domain entity with id, name, backgroundAssetPath, textPosition (TextOverlayConfig), description in lib/features/template/domain/entities/template.dart
- [ ] T014 [P] Create TemplateModel data model with fromJson/toJson in lib/features/template/data/models/template_model.dart
- [ ] T015 [P] Create ReelConfig domain entity holding current wizard state (selectedSurah, selectedAyah, selectedReciter, selectedTemplate, currentStep, generatedVideoPath, isGenerating, generationProgress) in lib/features/reel/domain/entities/reel_config.dart
- [ ] T016 [P] Create GeneratedReel domain entity with id, config, videoFilePath, createdAt, fileSizeBytes in lib/features/reel/domain/entities/generated_reel.dart
- [ ] T017 [P] Create TextOverlayConfig value object with x, y, maxWidth, fontSize, fontColor, fontFamily, textAlign in lib/core/utils/text_overlay_config.dart
- [ ] T018 Create bundled Quran data file: download and format Alquran Cloud Uthmani JSON as assets/data/quran_uthmani.json with Surah and Ayah structure
- [ ] T019 [P] Create bundled Surah metadata file assets/data/surah_metadata.json with all 114 Surahs (Arabic names, transliteration, Ayah counts, revelation type)
- [ ] T020 [P] Create reciter config file assets/data/reciter_config.json with 2-3 reciter entries (id, name, audioBaseUrl, style)
- [ ] T021 [P] Create template config file assets/data/template_config.json with 3+ templates (id, name, backgroundAssetPath, textPosition config, description)
- [ ] T022 [P] Add 3+ background template images (mosque, kaaba, nature) to assets/images/templates/
- [ ] T023 Implement SurahRepository with getAllSurahs() and getSurahById() loading from bundled JSON in lib/features/surah/data/repositories/surah_repository.dart
- [ ] T024 Implement AyahRepository with getAyahsBySurah() and getAyahById() loading from bundled JSON in lib/features/surah/data/repositories/surah_repository.dart (or separate ayah_repository.dart)
- [ ] T025 [P] Implement ReciterRepository with getAllReciters() and getAudioUrl() loading from bundled JSON in lib/features/reciter/data/repositories/reciter_repository.dart
- [ ] T026 [P] Implement TemplateRepository with getAllTemplates() and getTemplateById() loading from bundled JSON in lib/features/template/data/repositories/template_repository.dart
- [ ] T027 Implement wizard state management with Riverpod Notifier (WizardNotifier with next/back/selectSurah/selectAyah/selectReciter/selectTemplate/canProceed methods) in lib/shared/providers/wizard_provider.dart
- [ ] T028 [P] Create custom exception types (NetworkException, StorageException, CompositionException, ShareException, StateException) in lib/core/constants/app_exceptions.dart

**Checkpoint**: Foundation ready — domain entities, data models, repositories, wizard state all functional. User story implementation can now begin in parallel.

---

## Phase 3: User Story 1 - Create a Quran Reel from Scratch (Priority: P1) 🎯 MVP

**Goal**: Complete end-to-end creation flow — user selects Surah → Ayah → Reciter → Template → Preview → Generate → Export MP4

**Independent Test**: Step through the entire wizard flow and verify MP4 output video matches selected inputs

### Implementation for User Story 1

- [ ] T029 [P] [US1] Create Surah selection screen with scrollable list of 114 Surahs, search, and selection callback in lib/features/surah/presentation/screens/surah_selection_screen.dart
- [ ] T030 [P] [US1] Create Ayah selection screen displaying Ayahs of selected Surah with Arabic text and selection in lib/features/surah/presentation/screens/ayah_selection_screen.dart
- [ ] T031 [P] [US1] Create Reciter selection screen with list of 2-3 reciters and audio preview button (streamed via just_audio) in lib/features/reciter/presentation/screens/reciter_selection_screen.dart
- [ ] T032 [P] [US1] Create Template selection screen with 3+ visual templates and selection preview in lib/features/template/presentation/screens/template_selection_screen.dart
- [ ] T033 [US1] Implement wizard navigation flow connecting all 4 selection screens with back-navigation preserving state, using WizardProvider in lib/shared/providers/wizard_provider.dart
- [ ] T034 [US1] Implement TextRenderer for Quranic Arabic text — render Uthmani text to transparent PNG using Flutter Canvas, Scheherazade New font, TextDirection.rtl, with TextOverlayConfig in lib/core/utils/quran_text_renderer.dart
- [ ] T035 [US1] Implement VideoComposer using ffmpeg_kit_flutter — compose background image + text overlay PNG + reciter audio into 1080x1920 MP4 with deterministic encoding params in lib/core/utils/video_composer.dart
- [ ] T036 [US1] Implement audio download/cache service for reciter audio — download audio file from URL to local path for FFmpeg input, with error handling for network failures in lib/features/reciter/data/repositories/audio_download_service.dart (or lib/core/utils/)
- [ ] T037 [US1] Create Preview screen combining Ayah text overlay, template background, and streamed audio playback in lib/features/reel/presentation/screens/preview_screen.dart
- [ ] T038 [US1] Create Generation screen with progress indicator showing video composition status, error handling, and retry capability in lib/features/reel/presentation/screens/generation_screen.dart
- [ ] T039 [US1] Implement ExportService with saveToLocal() and shareVideo() using path_provider and share_plus in lib/features/reel/data/repositories/export_repository.dart (or lib/core/utils/export_service.dart)
- [ ] T040 [US1] Create Export screen with save and share buttons, error handling for storage failures and permission denied in lib/features/reel/presentation/screens/export_screen.dart
- [ ] T041 [US1] Wire complete end-to-end wizard flow in main.dart — home screen with "Create New Reel" button launches wizard, each step validates canProceed(), blocks generation if inputs missing

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently — complete creation flow from Surah selection to MP4 export.

---

## Phase 4: User Story 2 - Preview Before Generating (Priority: P2)

**Goal**: User can see and hear a combined preview of Ayah text + background + reciter audio before committing to video generation

**Independent Test**: Select inputs, trigger preview, verify Ayah text renders over background with audio playing — without generating a video file

### Implementation for User Story 2

- [ ] T042 [US2] Implement AudioPreviewService with just_audio — play/pause/stop streaming audio from URL, stream position and duration, handle network errors gracefully in lib/features/reciter/data/services/audio_preview_service.dart
- [ ] T043 [US2] Enhance Preview screen to render live preview composition: display background template image, overlay rendered Ayah text, stream reciter audio, show playback progress, handle audio completion in lib/features/reel/presentation/screens/preview_screen.dart
- [ ] T044 [US2] Add back navigation from Preview to Template Selection while preserving all wizard selections in lib/features/reel/presentation/screens/preview_screen.dart and lib/shared/providers/wizard_provider.dart
- [ ] T045 [US2] Add network connectivity error handling in Preview screen — display clear user-facing message when audio streaming fails, allow retry without losing selections

**Checkpoint**: User Stories 1 AND 2 should both work independently — full flow plus live preview before generation.

---

## Phase 5: User Story 3 - Export and Share Video (Priority: P3)

**Goal**: User can save the generated MP4 locally or share it to external apps via system share sheet

**Independent Test**: Generate a video, then verify both save-to-device and share-to-external-app flows work; verify retry on failure

### Implementation for User Story 3

- [ ] T046 [US3] Implement local save functionality — copy generated MP4 to public storage directory using path_provider, handle write errors (disk full, permission denied) in lib/features/reel/data/repositories/export_repository.dart
- [ ] T047 [US3] Implement share functionality using share_plus — trigger system share sheet with MP4 file attached in lib/features/reel/data/repositories/export_repository.dart
- [ ] T048 [US3] Create polished Export screen UI with save button, share button, success/error feedback, and retry on failure without losing generated video in lib/features/reel/presentation/screens/export_screen.dart

**Checkpoint**: All user stories should now be independently functional — creation flow, preview, and export.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T049 [P] Validate Quran text rendering accuracy — test Ayah text overlay with full tashkeel strings across all 114 Surahs to ensure no distortion, correct RTL rendering, and proper font sizing in lib/core/utils/quran_text_renderer.dart
- [ ] T050 [P] Validate deterministic video output — generate video twice with same inputs and verify visual/audio equivalence (not byte-level) in lib/core/utils/video_composer.dart
- [ ] T051 Add network connectivity awareness — detect offline state, disable preview/generate actions gracefully, show user-friendly error messages per FR-020 across relevant screens
- [ ] T052 [P] Add input validation guards — block video generation (FR-017) if any selection is missing, show clear messages guiding user to complete the wizard step in lib/shared/providers/wizard_provider.dart
- [ ] T053 Performance optimization — profile video generation time on mid-range device, optimize text rendering and FFmpeg command parameters if >60 seconds in lib/core/utils/video_composer.dart
- [ ] T054 [P] Add app icon and launch screen per minimal/calm UI design constraint in lib/core/theme/
- [ ] T055 Run full acceptance scenario validation against spec.md User Story 1 acceptance scenarios 1-7

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational completion
- **User Story 2 (Phase 4)**: Depends on Foundational (can start in parallel with US1 for service layer, but Preview screen depends on US1 screens existing)
- **User Story 3 (Phase 5)**: Depends on US1 (needs generated video to export)
- **Polish (Phase 6)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) — no dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational, but Preview screen enhancement (T043-T045) depends on US1 Preview screen (T037)
- **User Story 3 (P3)**: Can start after Foundational, but Export depends on US1 Generation (T035/T038) producing a video file

### Within Each User Story

- Models before services
- Services before screens
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational domain entities (T007-T017) can run in parallel
- All data config files (T019-T022) can run in parallel
- All repository implementations (T023-T026) can run in parallel after entities and data files
- Within US1: Selection screens (T029-T032) can run in parallel
- Within US2: AudioPreviewService (T042) can start in parallel with US1 work
- Within Polish: T049, T050, T052, T054 can all run in parallel

---

## Parallel Example: User Story 1

```bash
# Launch all selection screens for User Story 1 together:
Task: "Create Surah selection screen in lib/features/surah/presentation/screens/surah_selection_screen.dart"
Task: "Create Ayah selection screen in lib/features/surah/presentation/screens/ayah_selection_screen.dart"
Task: "Create Reciter selection screen in lib/features/reciter/presentation/screens/reciter_selection_screen.dart"
Task: "Create Template selection screen in lib/features/template/presentation/screens/template_selection_screen.dart"

# Then sequentially:
Task: "Wire wizard navigation flow"
Task: "Implement TextRenderer"
Task: "Implement VideoComposer"
Task: "Create Preview screen"
Task: "Create Generation screen"
Task: "Create Export screen"
Task: "Wire end-to-end flow in main.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL — blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (full creation flow)
   - Developer B: AudioPreviewService (T042) for User Story 2
   - Developer C: ExportService foundation (T046-T047) for User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence