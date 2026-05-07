# 📱 Quran Reels App

## Product Vision & Roadmap

---

# 🌟 Vision

The Quran Reels App is a lightweight creation tool that enables users to easily produce short, beautiful Quran-based videos (Reels) combining:

* Quranic verses
* Recitation audio
* Visual backgrounds
* Simple spiritual presentation

The goal is not to be a social network, but a **content creation tool focused on Quranic reminders and reflection.**

---

# 🎯 Core Concept

> “Create a Quran Reels in under 1 minute”

Users should be able to:

1. Select an Ayah
2. Select a Reciter
3. Choose a visual template
4. Export a short video

---

# 🚀 MVP (Phase 1 - Initial Release)

## 🎬 Quran Reels Generator (Core Feature)

### 1. 📖 Ayah Selection

* Browse Surahs
* Select specific Ayah
* Simple UI for navigation

### 2. 🎙️ Reciter Selection

* Limited set of reciters (2–5 max)
* Preloaded audio files or API-based audio

### 3. 🎨 Video Templates

* 3–5 static templates:

  * Mosque background
  * Kaaba background
  * Nature background
* Animated text overlay for Ayah

### 4. 📤 Export & Share

* Generate MP4 video
* Share to:

  * WhatsApp
  * TikTok
  * Instagram Reels

### 5. ⚙️ Simple Local Storage

* Save last created reels

---

# 🧱 Phase 2 (Enhancement Release)

## 🎨 Content Expansion

### 1. More Reciters

* Expand library of Quran reciters

### 2. More Templates

* Seasonal themes (Ramadan, Eid)
* Dark/light aesthetic modes

### 3. Save Projects

* Save drafts before export
* Re-edit previous reels

### 4. UI Improvements

* Smooth animations
* Better typography (Uthmani style)

---

# 🧠 Phase 3 (Intelligent Features)

## 🤖 Smart Quran Content Generation

### 1. AI Ayah Suggestion

* Suggest verses based on topic:

  * patience
  * rizq
  * sadness
  * gratitude

### 2. Auto Video Generation

* One-click “Generate Reel”

### 3. Smart Background Selection

* Background chosen based on meaning of Ayah

---

# 🌐 Phase 4 (Platform Expansion)

## 📲 Community & Platform Layer

### 1. Internal Feed (Optional)

* Users can browse shared reels
* Like/save system

### 2. Profiles

* Creator profiles
* Saved content

### 3. Trending Content

* Most shared Ayat reels

---

# 🏗️ Technical Strategy

## Flutter First Approach

### Core Stack

* Flutter (Mobile App)
* ffmpeg_kit_flutter (Video generation)
* Local JSON for MVP data

### Architecture

* Clean Architecture

  * Presentation Layer
  * Domain Layer
  * Data Layer

---

# ⚠️ Important Product Decisions

### ❌ Avoid in MVP

* Social network features
* Comments system
* AI features
* Cloud rendering

### ✅ Focus on

* Speed of creation
* Simplicity
* High quality output
* Emotional/spiritual UX

---

# 📈 Long-Term Vision

The app evolves from:

> Tool → Creator → Platform

But must always keep:

* Simplicity
* Focus on Quran content
* Fast creation experience

---

# 🧭 Next Step

After this document, the next phase is:

## 👉 Phase 1 Implementation Plan (Detailed)

This is the first real development stage where we build a working MVP prototype.

---

# 🧱 Phase 1 - Implementation Plan

## 🎯 Goal

Build a fully working Flutter prototype that can:

* Select Surah & Ayah
* Select Reciter
* Apply a video template
* Generate and export a short Quran Reel (MP4)

---

# 🏗️ 1. Project Architecture (Clean Architecture)

## 📦 Layers

### 1. Presentation Layer

* Screens (UI)
* State management (Riverpod)
* UI controllers

### 2. Domain Layer

* Entities
* Use cases
* Repository interfaces

### 3. Data Layer

* Local JSON data (MVP)
* Future API integration
* Repository implementations

---

# 📁 2. Folder Structure

lib/
├── core/
│    ├── theme/
│    ├── utils/
│    ├── constants/
│
├── features/
│    ├── quran/
│    │    ├── data/
│    │    ├── domain/
│    │    ├── presentation/
│    │
│    ├── reciter/
│    ├── video_generator/
│
├── shared/
│    ├── widgets/
│    ├── models/
│
└── main.dart

---

# 📱 3. Screens (User Flow)

## 1. Home Screen

* Button: “Create New Reel”
* Recent reels (optional later)

## 2. Surah Selection Screen

* List of Surahs
* Search bar

## 3. Ayah Selection Screen

* Show Ayahs of selected Surah
* Tap to select single Ayah

## 4. Reciter Selection Screen

* Grid/list of reciters
* Preview audio button

## 5. Template Selection Screen

* 3–5 video templates
* Preview background

## 6. Preview Screen

* Show final composition
* Play audio + overlay preview

## 7. Export Screen

* Generate video
* Progress indicator
* Share button

---

# 🧠 4. Data Models (Core MVP)

## Surah

* id
* name
* ayahCount

## Ayah

* id
* surahId
* text
* number

## Reciter

* id
* name
* audioBaseUrl

## Template

* id
* backgroundAsset
* styleConfig

## ReelProject

* ayah
* reciter
* template
* outputPath

---

# 🎬 5. Video Generation Pipeline (MVP)

## Approach: ffmpeg_kit_flutter

### Steps:

1. Load selected Ayah text
2. Load reciter audio file
3. Load background image/video
4. Overlay text on background
5. Combine audio + video
6. Export MP4 file

---

# ⚙️ 6. State Management

## Recommended: Riverpod

### Providers:

* surahProvider
* ayahProvider
* reciterProvider
* templateProvider
* reelGeneratorProvider

---

# 🧪 7. MVP Constraints (Important)

## ❌ Do NOT include:

* Social features
* AI suggestions
* Online feed
* Authentication

## ✅ Focus only on:

* Selection flow
* Video generation
* Export/share

---

# 🚀 8. Development Order

### Step 1

Setup Flutter project + architecture

### Step 2

Build Surah + Ayah selection (UI + data)

### Step 3

Add Reciter module

### Step 4

Add Templates

### Step 5

Build Preview screen

### Step 6

Implement ffmpeg video generation

### Step 7

Export + share

---

# 🕋 End Goal (Phase 1)

A working Flutter app that can generate a Quran Reel video from selected:

* Ayah
* Reciter
* Template

and export it as a shareable video file.

A tool that allows anyone to create meaningful Quran reminders in seconds, and share them with others in a beautiful, respectful format.
