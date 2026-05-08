<!--
Sync Impact Report
==================
Version change: (new) → 1.0.0
Modified principles: N/A (initial ratification)
Added sections:
  - Core Principles (6 principles)
  - Non-Goals and Scope Boundaries
  - Design Constraints
  - Governance
Removed sections: N/A (initial ratification)
Templates requiring updates:
  - .specify/templates/plan-template.md: ✅ compatible (generic Constitution Check)
  - .specify/templates/spec-template.md: ✅ compatible (generic requirements)
  - .specify/templates/tasks-template.md: ✅ compatible (generic task structure)
  - .specify/templates/checklist-template.md: ✅ compatible (generic checklist)
Follow-up TODOs: None
-->

# Quran Reels App Constitution

## Core Principles

### I. Reverence First

All features MUST respect the sanctity of the Quran. No distortion of
Quranic text is permitted. No inappropriate visual or audio mixing is
allowed. No entertainment-first design decisions shall be made. Every
UI interaction, visual treatment, and audio pairing MUST honor the
sacred nature of the content.

### II. Simplicity Over Complexity

The product MUST remain simple by design. Minimal steps to create a
reel. No unnecessary user flows. Feature bloat MUST be avoided. Every
addition MUST justify its necessity against a simpler alternative.

### III. Creation Tool, Not Social Network

The system is NOT a social platform in the MVP. No feeds, no comments,
no likes, and no engagement loops. Focus MUST be on creation and export
only. Social features remain explicitly out of scope until a future
phase.

### IV. Offline-first MVP Mindset

The initial version MUST work without backend dependency where possible.
Local data is preferred over remote data. Local video generation is
preferred over cloud processing. Network unavailability MUST NOT block
core creation workflows.

### V. Deterministic Output

Given the same inputs (Ayah, Reciter, Template), output MUST be
predictable and reproducible. No AI randomness in the MVP. No dynamic
generation variations. Users MUST be able to reproduce the same reel
from the same configuration.

### VI. Performance Awareness

Video generation MUST be optimized for mobile devices. Heavy rendering
pipelines MUST be avoided. Lightweight composition strategies MUST be
preferred. The app MUST remain responsive during video generation
operations.

## Non-Goals and Scope Boundaries

### Explicitly Out of Scope (MVP)

The following are NOT part of the initial system design:

- Social feed or community features
- AI-based ayah suggestion
- Cloud rendering or backend video processing
- User authentication systems
- Monetization systems
- Commenting, likes, or sharing inside the app

### In Scope (Phase 1 MVP)

- Surah and Ayah selection
- Reciter selection
- Template selection
- Video generation (local)
- Export MP4

### Out of Scope (All Phases Until Explicitly Added)

- Any system requiring real-time server sync
- User-generated content platforms

## Design Constraints

### UI Constraints

- Minimal and calm UI
- No distracting animations
- Typography MUST prioritize readability of Quran text

### Data Constraints

- Initial data MAY be local JSON or bundled assets
- No dependency on external APIs in MVP

### Video Constraints

- Output format: MP4 only
- Resolution optimized for mobile sharing (Reels format)

### Architectural Constraints

- Feature-based modular structure
- Clean separation of concerns
- Domain logic MUST be independent of UI and framework

## Governance

This constitution is the supreme governing document for the Quran
Reels App project. All specifications, plans, and implementation
decisions MUST comply with the principles stated herein.

**Amendment Procedure**: Amendments require documentation of the
proposed change, rationale, and migration plan. Amendments MUST NOT
contradict Core Principles without explicit ratification.

**Versioning Policy**: Constitution versions follow semantic
versioning. MAJOR for backward-incompatible principle removals or
redefinitions. MINOR for new principles or materially expanded
guidance. PATCH for clarifications, wording fixes, or non-semantic
refinements.

**Compliance Review**: All PRs and reviews MUST verify compliance with
this constitution. Any complexity that contradicts a principle MUST be
justified in the Complexity Tracking section of the implementation
plan.

**Evolution Strategy**: The system is expected to evolve in phases:
1. MVP: Video creation tool only
2. Enhancement: Templates + customization
3. Intelligence: Optional AI assistance
4. Platform: Optional community layer (future only, requires separate
   governance amendment)

**Version**: 1.0.0 | **Ratified**: 2026-05-07 | **Last Amended**: 2026-05-07