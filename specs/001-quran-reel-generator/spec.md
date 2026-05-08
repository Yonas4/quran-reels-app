# Feature Specification: Quran Reel Generator

**Feature Branch**: `001-quran-reel-generator`
**Created**: 2026-05-07
**Status**: Draft
**Input**: User description: "Quran Reels App - MVP Specification for creating short-form videos using Quranic verses, recitations, and visual templates"

## Clarifications

### Session 2026-05-07

- Q: How should Ayah text be displayed in the video? → A: Arabic text only — pure Quran text overlay, no translations in MVP
- Q: Navigation model for the creation flow? → A: Step-by-step wizard with back navigation (forward-only progression, can go back)
- Q: How many reciters in MVP, and audio source? → A: 2–3 reciters, audio streamed via URLs (not bundled locally)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Create a Quran Reel from Scratch (Priority: P1)

A user opens the app, selects a Surah, chooses an Ayah, picks a reciter, selects a template, previews the composition, generates the video, and exports it — completing the entire creation flow end-to-end.

**Why this priority**: This is the core MVP value proposition. Without this flow, no other feature matters. It delivers the primary user goal in a single, linear journey.

**Independent Test**: Can be fully tested by stepping through the entire creation flow from Surah selection to MP4 export and verifying the output video matches the selected inputs.

**Acceptance Scenarios**:

1. **Given** the user is on the home screen, **When** they tap "Create New Reel", **Then** the app navigates to Surah selection (Step 1 of wizard)
2. **Given** the user has selected a Surah, **When** they proceed, **Then** the app advances to Ayah selection (Step 2) and all Ayahs of that Surah are displayed; user CAN go back to Surah selection
3. **Given** the user has selected an Ayah, **When** they proceed, **Then** the app advances to reciter selection (Step 3); available reciters are listed; user CAN go back to Ayah selection
4. **Given** the user has selected a reciter, **When** they proceed, **Then** the app advances to template selection (Step 4); at least 3 templates are displayed; user CAN go back to reciter selection
5. **Given** all selections are complete (Surah, Ayah, Reciter, Template), **When** the user taps preview, **Then** a combined preview shows Ayah text overlay, selected background, and reciter audio synced; user CAN go back to change any selection
6. **Given** the user has previewed the reel, **When** they tap generate, **Then** the system produces an MP4 video and shows a progress indicator
7. **Given** the video is generated, **When** the user taps export, **Then** they can save locally or share externally

---

### User Story 2 - Preview Before Generating (Priority: P2)

A user who has selected their Ayah, reciter, and template wants to see and hear how the composition will look before committing to video generation, so they can confirm it meets their expectations.

**Why this priority**: Preview prevents wasted generation time and ensures user satisfaction with the output, but it depends on selections being made first (US1).

**Independent Test**: Can be tested by selecting inputs, triggering preview, and verifying that Ayah text, background, and audio are rendered together without generating a full video file.

**Acceptance Scenarios**:

1. **Given** all selections are made, **When** the user taps preview, **Then** the preview combines Ayah text, background template, and audio playback
2. **Given** the preview is playing, **When** audio finishes, **Then** the preview indicates completion
3. **Given** the user is in preview, **When** they tap back, **Then** they return to the previous wizard step (template selection) with all selections preserved

---

### User Story 3 - Export and Share Video (Priority: P3)

A user who has generated a video wants to save it to their device or share it via external apps (messaging, social platforms).

**Why this priority**: Export is essential for delivering value but follows generation. Without generation (US1), there is nothing to export.

**Independent Test**: Can be tested by generating a video and then verifying both save-to-device and share-to-external-app flows work correctly.

**Acceptance Scenarios**:

1. **Given** a video has been generated, **When** the user taps save, **Then** the MP4 file is stored on the device
2. **Given** a video has been generated, **When** the user taps share, **Then** the system share sheet opens with the MP4 file attached
3. **Given** an export fails (storage full, permission denied), **When** the user acknowledges the error, **Then** the generated video is still available for retry without losing progress

---

### Edge Cases

- What happens when the user attempts to generate a video without selecting an Ayah? The system MUST block video generation and prompt the user to complete all selections.
- What happens when the user attempts to generate a video without selecting a reciter? The system MUST prompt the user to select a reciter.
- What happens when video generation fails mid-process? The system MUST allow retry without losing the user's selections.
- What happens when export fails (e.g., storage full, permission denied)? The system MUST display an error message and allow retry without losing the generated video or selections.
- What happens if the user navigates back after partial selections? The system MUST preserve previous selections so the user can resume the flow.
- What happens when there is no internet connectivity during reciter audio preview or video generation? The system MUST display a clear error indicating internet is required and allow retry when connectivity is restored without losing selections.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a list of all 114 Surahs for user selection
- **FR-002**: System MUST display all Ayahs within the selected Surah for user selection
- **FR-003**: System MUST enforce a step-by-step wizard flow: Surah → Ayah → Reciter → Template → Preview → Generate → Export
- **FR-003b**: System MUST allow backward navigation within the wizard (user can go back to any previous step) while preserving all selections
- **FR-004**: System MUST allow selection of exactly one Ayah per reel
- **FR-005**: System MUST display a list of 2–3 available reciters for selection
- **FR-006**: System MUST allow optional audio preview of a reciter before selection (streamed via URL; requires internet)
- **FR-007**: System MUST allow selection of exactly one reciter per reel
- **FR-008**: System MUST display at least 3 background templates for selection
- **FR-009**: System MUST allow selection of exactly one template per reel
- **FR-010**: System MUST generate a preview combining the selected Ayah text, background template, and reciter audio
- **FR-011**: System MUST generate an MP4 video (vertical 9:16 format) from the selected inputs
- **FR-012**: System MUST display a progress indicator during video generation
- **FR-013**: System MUST allow saving the generated video locally to the device
- **FR-014**: System MUST allow sharing the generated video to external apps
- **FR-015**: System MUST display only original Arabic Quran text in the video overlay, without translation or transliteration
- **FR-015b**: System MUST preserve Quran Arabic text without alteration or distortion in rendering
- **FR-016**: System MUST NOT mix Quran audio with unrelated music or sound
- **FR-017**: System MUST block video generation if any required input (Ayah, Reciter, Template) is missing
- **FR-018**: System MUST produce identical output given identical inputs (Surah, Ayah, Reciter, Template)
- **FR-019**: System MUST allow retry on export failure without losing the generated video or selections
- **FR-020**: System MUST display a clear error and allow retry when internet connectivity is unavailable during reciter audio preview or video generation

### Key Entities

- **Surah**: Represents a chapter of the Quran. Key attributes: Surah ID, name (Arabic), name (transliteration), Ayah count, revelation order
- **Ayah**: Represents a verse within a Surah. Key attributes: Ayah ID, Surah ID, Arabic text (displayed in video overlay only — no translation in MVP), Ayah number within Surah
- **Reciter**: Represents an audio recitation source. Key attributes: Reciter ID, name, audio URL per Ayah (streamed, not bundled locally)
- **Template**: Represents a visual background template. Key attributes: Template ID, name, visual asset reference
- **Reel**: The composed output combining one Ayah, one Reciter's audio, and one Template. Key attributes: Surah ID, Ayah ID, Reciter ID, Template ID, generated video reference

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user can complete the full creation flow (from app launch to exported video) in under 2 minutes
- **SC-002**: The generated MP4 video plays correctly on standard mobile video players and social platforms
- **SC-003**: Same inputs (Surah, Ayah, Reciter, Template) always produce the same output video
- **SC-004**: The video is in vertical 9:16 format optimized for Reels/sharing
- **SC-005**: Surah/Ayah selection works without internet connectivity; reciter audio preview and video generation require internet for streaming
- **SC-006**: 90% of first-time users can complete the full flow without external guidance

## Assumptions

- Quran text data (Surah names, Ayah text) will be bundled locally in the app as structured data (e.g., JSON)
- Reciter audio is streamed via URLs (not bundled locally); internet required for audio preview and video generation audio track
- Background templates will be bundled as local assets (images or lightweight animations)
- The target platform is mobile (Flutter); video generation will be performed on-device
- No user authentication is required for the MVP
- The app will be used on devices with sufficient storage for video generation
- Video export uses the device's native share functionality
- "Reasonable time" for video generation means under 60 seconds for a single-Ayah reel on a mid-range device