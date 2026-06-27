# C++ Desktop Launcher Plan

> For agentic workers: use `superpowers:executing-plans` step by step. Keep each step small and verify after each milestone.

## Goal

Build Windows-only C++ launcher from empty repo state. Start with CMake scaffold, then add shared helpers, launcher UI, update flow, and repeatable smoke tests. Keep dependencies to Windows SDK only.

## Design Notes

- Classic Win32 / MFC retro look.
- Grey surfaces with teal accents.
- System fonts over modern web fonts.
- 3D bevels, segmented progress bar, and tabbed navigation.
- Main tabs: `Thông báo` and `Cài đặt`.
- Launcher should feel nostalgic, technical, and lightweight.

## Checklist

- [ ] 1. Create root CMake scaffold
  - Add root `CMakeLists.txt`.
  - Add `common/` and `cpp/` module layout.
  - Add build output and temp file ignores.
  - Verify: clean configure and build succeed.

- [ ] 2. Add shared helper library
  - Add UTF-8/UTF-16 conversion helpers.
  - Add executable-path and directory helpers.
  - Keep JSON parsing small and explicit.
  - Verify: helper test driver passes.

- [ ] 3. Add HTTP layer
  - Add WinINet text fetch.
  - Add file download with optional progress callback.
  - Close handles on every path.
  - Verify: smoke test works against local test content.

- [ ] 4. Add launcher UI shell
  - Add Win32 window, status text, segmented progress bar, Play button, and top tabs.
  - Style controls with classic beveled 3D borders, grey surfaces, and teal accent areas.
  - Reserve space for news banner / event image and system info like node, ping, and online status.
  - Use message-based worker-to-UI updates.
  - Keep shutdown path clean.
  - Verify: app opens, updates UI, closes cleanly.

- [ ] 5. Add update flow
  - Check remote version on startup.
  - Compare against local version file.
  - Download files before self-update.
  - Use temp helper/script so running EXE is not overwritten in place.
  - Verify: offline, download, and self-update paths behave predictably.

## Test Matrix

- Build from clean tree.
- Run helper test driver.
- Run parser test driver on known config sample.
- Run HTTP smoke test against local file or loopback server.
- Confirm UI keeps retro Win32/MFC feel, not flat modern styling.
- Launch app manually and confirm startup, progress, and shutdown.

## Assumptions

- Target OS is Windows 10/11 only.
- No third-party libraries.
- Network test can use local loopback during manual verification.
- UI text and layout should follow DESIGN.md naming and tab structure.
