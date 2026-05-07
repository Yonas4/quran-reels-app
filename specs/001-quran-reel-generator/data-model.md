# Data Model: Quran Reel Generator

**Feature**: 001-quran-reel-generator
**Date**: 2026-05-07

## Entities

### Surah

Represents a chapter of the Quran (114 total).

| Field | Type | Description |
|-------|------|-------------|
| id | int | Surah number (1-114), unique identifier |
| nameArabic | String | Arabic name (e.g., "الفاتحة") |
| nameTransliteration | String | Transliterated name (e.g., "Al-Fatiha") |
| nameTranslation | String | English translation of name (e.g., "The Opening") |
| ayahCount | int | Number of Ayahs in this Surah |
| revelationType | String | "Meccan" or "Medinan" |
| revelationOrder | int | Chronological order of revelation |

**Validation rules**:
- id MUST be between 1 and 114 inclusive
- nameArabic MUST NOT be empty
- ayahCount MUST be > 0

**Relationships**: A Surah has many Ayahs (1:N).

### Ayah

Represents a single verse within a Surah.

| Field | Type | Description |
|-------|------|-------------|
| id | int | Global unique Ayah number (1-6236) |
| surahId | int | Foreign key to Surah.id |
| numberInSurah | int | Ayah number within its Surah |
| textUthmani | String | Arabic text in Uthmani script with full diacritics (display text for video overlay — no translation in MVP) |
| juz | int | Juz number (1-30) |
| page | int | Mushaf page number |

**Validation rules**:
- id MUST be between 1 and 6236 inclusive
- surahId MUST reference an existing Surah
- textUthmani MUST NOT be empty (Reverence First principle — no empty verse text)
- textUthmani MUST NOT be altered from authoritative source

**Relationships**: An Ayah belongs to one Surah (N:1).

### Reciter

Represents an audio recitation source (2-3 available in MVP).

| Field | Type | Description |
|-------|------|-------------|
| id | String | Unique identifier (e.g., "mishary-alafasi") |
| name | String | Display name (e.g., "Mishary Alafasi") |
| audioBaseUrl | String | URL prefix for audio files (e.g., "https://cdn.example.com/mishary-alafasi/") |
| style | String | Recitation style description (e.g., "Murattal") |

**Validation rules**:
- id MUST be unique
- audioBaseUrl MUST be a valid HTTPS URL
- name MUST NOT be empty

**Relationships**: A Reciter has audio for many Ayahs. Audio URL format: `{audioBaseUrl}{surahId}/{ayahId}.mp3`

### Template

Represents a visual background template for reel composition.

| Field | Type | Description |
|-------|------|-------------|
| id | String | Unique identifier (e.g., "mosque") |
| name | String | Display name (e.g., "Mosque") |
| backgroundAssetPath | String | Local asset path to background image (e.g., "assets/images/templates/mosque.png") |
| textPosition | TextOverlayConfig | Position and styling configuration for Ayah text overlay |
| description | String | Short description for accessibility |

**Validation rules**:
- id MUST be unique
- backgroundAssetPath MUST reference an existing bundled asset
- textPosition MUST define valid positioning within 1080x1920 canvas

**TextOverlayConfig** (value object):

| Field | Type | Description |
|-------|------|-------------|
| x | double | Horizontal position (0-1, relative to canvas width) |
| y | double | Vertical position (0-1, relative to canvas height) |
| maxWidth | double | Maximum text width (0-1, relative to canvas width) |
| fontSize | double | Font size in pixels |
| fontColor | String | Color hex code (e.g., "#FFFFFF") |
| fontFamily | String | Font family name (e.g., "ScheherazadeNew") |
| textAlign | String | "center", "left", or "right" (Arabic uses "right" or "center") |

**Relationships**: None — Template is a standalone selection entity.

### ReelConfig

Represents the user's current composition configuration (the wizard state that leads to video generation).

| Field | Type | Description |
|-------|------|-------------|
| surah | Surah? | Selected Surah |
| ayah | Ayah? | Selected Ayah |
| reciter | Reciter? | Selected Reciter |
| template | Template? | Selected Template |
| currentStep | int | Current wizard step (0-6) |

**State transitions**:
- `EMPTY` → Surah selected → `SURAH_SELECTED`
- `SURAH_SELECTED` → Ayah selected → `AYAH_SELECTED`
- `AYAH_SELECTED` → Reciter selected → `RECITER_SELECTED`
- `RECITER_SELECTED` → Template selected → `TEMPLATE_SELECTED`
- `TEMPLATE_SELECTED` → Preview triggered → `PREVIEWING`
- `PREVIEWING` → Generate triggered → `GENERATING`
- `GENERATING` → Video produced → `COMPLETED`
- `COMPLETED` → Export → `EXPORTED`
- Any step → Back → Previous step (selections preserved)

**Validation rules**:
- Video generation MUST NOT proceed unless surah, ayah, reciter, and template are all non-null
- Back navigation MUST preserve all previously made selections

### GeneratedReel

Represents a produced video output.

| Field | Type | Description |
|-------|------|-------------|
| id | String | Unique identifier (UUID) |
| config | ReelConfig | The configuration used to generate this reel |
| videoFilePath | String | Local file path to generated MP4 |
| createdAt | DateTime | Timestamp of generation |
| fileSizeBytes | int | Size of generated video file |

**Validation rules**:
- videoFilePath MUST point to an existing MP4 file
- Same ReelConfig MUST produce identical video content (deterministic output)

## Entity Relationship Diagram

```
Surah (1) ────< (N) Ayah
                     |
Reciter ────────────| (audio URL per Ayah)
                     |
Template ────────────|
                     ↓
              ReelConfig ──→ GeneratedReel
```

## Local Data Files

| File | Format | Size Estimate | Source |
|------|--------|--------------|--------|
| quran_uthmani.json | JSON | ~1.3 MB | Alquran Cloud (bundled) |
| surah_metadata.json | JSON | ~30 KB | Derived from Alquran Cloud (bundled) |
| reciter_config.json | JSON | ~2 KB | Hand-curated (2-3 entries) |
| template_config.json | JSON | ~1 KB | Hand-curated (3+ entries) |
| Background images | PNG | ~500 KB each | Bundled in assets/images/templates/ |
| Quranic font | OTF/TTF | ~200 KB | Scheherazade New (bundled) |

Total bundled assets estimate: ~5-6 MB (excluding reciter audio, which is streamed).