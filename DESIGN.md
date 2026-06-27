# Project Brief: Aetheris Game Launcher (Classic Win32 Edition)

## 1. Overview

A desktop game launcher inspired by the classic Windows Win32/MFC aesthetic, designed for a Wuxia-themed MMORPG. The goal is to provide a functional, nostalgic, and lightweight interface that mimics the look of legacy C++ applications.

## 2. Design Vision

- **Theme:** Classic Windows Retro (Win32 / MFC / C++).
- **Core Aesthetic:** Beveled 3D borders, grey color palette, segmented progress bars, and standard property-sheet tabs.
- **Tone:** Technical, reliable, and nostalgic.

## 3. Visual Identity

- **Primary Palette:** Standard Windows Grey (#c0c0c0) for UI surfaces.
- **Accent Color:** Classic Desktop Teal (#008080) for backgrounds.
- **Typography:** System fonts (MS Sans Serif / Hanken Grotesk) to maintain the technical feel.
- **Component Style:** High-contrast 3D bevels (light top/left, dark bottom/right) for buttons and containers.

## 4. Key Features & Layout

- **Window Frame:** Standard title bar with gradient blue background and system window controls (Minimize, Maximize, Close).
- **Navigation:** Top-level property tabs for "Thông báo" (News) and "Cài đặt" (Settings), replacing a traditional sidebar or navbar.
- **News Section:** Content area for patch notes and event images, featuring a wuxia-themed landscape banner.
- **Update System:**
  - Segmented progress bar showing download status.
  - Status text (e.g., "Checking for updates...").
  - Action buttons: "UPDATE" (Primary) and "Cancel" (Secondary).
- **System Info:** Sidebar or status bar elements showing connection node, ping, and online status.

## 5. Assets Used

- **Hero Image:** Wuxia landscape with mountains and pagodas ({{DATA:IMAGE:IMAGE_6}}).
- **Iconography:** Neon cyan dragon/sword icon ({{DATA:IMAGE:IMAGE_5}}) used as the application logo.

## 6. Target Device

- **Platform:** Desktop (Windows).
- **Form Factor:** Fixed-size launcher window (smaller than full screen).
