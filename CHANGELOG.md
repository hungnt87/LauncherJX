# Changelog

## v1.1.1 - 2026-06-28

### Fixes
- Fix self-update process by adding LauncherJX.exe to manifest files list
- Point manifest URL to raw GitHub patch/version.json with cache buster query parameter
- Update release configuration to include all patch zip files in GitHub Release assets

## v1.1.0 - 2026-06-28


### Features
- Implement a Windows self-update path for LauncherJX that downloads `updater.exe` and replaces the launcher safely
- Implement launcher UI with configuration and JX1 mod management tabs using Dear ImGui
- Implement core launcher application logic and update coordination system
- Add JX1Mod tab with 16 toggles reading/writing JX1Mod.ini keys
- Add Settings tab with resolution selector (800x600/1024x768) and FullScreen radio buttons writing to config.ini and package.ini
- Embed PNG images directly into EXE resources and load them from memory using GDI+
- Support publishing updater asset metadata in release manifest

### Fixes
- Only ignore config.ini, jx1mod.ini, and package.ini in manifest generation and client updates instead of all ini files

### Refactor
- Localize launcher UI, buttons, updates and error messages to Vietnamese
- Convert app_icon.png to launcher.ico and update exe resource icon
- Replace copy buttons and selectable list with single read-only multiline input box for changelog text selection

### Documentation
- Add self-update launcher design spec

## v1.0.11 - 2026-06-27


### Features
- Integrate professional game icon into LauncherJX.exe using Windows resource files
- Implement single-instance prevention using Win32 Named Mutex to block opening multiple Launcher windows

## v1.0.10 - 2026-06-27

### Fixes
- Add query timestamp (cache-buster) to remote CHANGELOG.md URL to bypass GitHub Raw CDN caching and show the latest changes immediately

## v1.0.9 - 2026-06-27

### Features
- Implement remote CHANGELOG.md downloading directly to memory via background thread (no local copy needed)

## v1.0.8 - 2026-06-27

### Fixes
- Skip hash integrity check for local .ini settings files (e.g. package.ini, config.ini) to keep player settings and prevent infinite update loops

## v1.0.7 - 2026-06-27

### Fixes
- Copy and package CHANGELOG.md into the patch folder so that it is downloaded by the launcher for the notification tab

## v1.0.6 - 2026-06-27

### Features
- Add "Copy" button in notification tab to copy changelog text directly to clipboard
- Show examples of failing files (integrity check mismatch) in status log to ease debugging

## v1.0.5 - 2026-06-27

### Features
- Implement automatic game file integrity check and repair logic (Auto-Repair) when local files are missing or modified

## v1.0.4 - 2026-06-27

### Fixes
- Preserve LastError in DownloadFile to avoid hiding real Windows API errors with Error: 0

## v1.0.3 - 2026-06-27

### Fixes
- Add missing game executables (config.exe, game.exe) in patch folder by correcting gitignore rules

## v1.0.2 - 2026-06-27

### Features
- Implement subfolder zip update logic with direct root file downloading and native background powershell extraction
- Move zip files destination to external 'zips' folder and update launcher download url path

### Fixes
- Make UrlEncode function locale-independent to ensure non-ASCII characters in file paths are always percent-encoded correctly
- Url-encode file paths during update downloading to support files with non-ASCII characters

### Performance
- Implement 4-thread parallel downloading with HTTP Keep-Alive for 3-5x faster game updates

### Style
- Convert status text to read-only multiline input box for easy error copying

## v1.0.1 - 2026-06-27

### Features
- Integrate automatic updates with GitHub Release and configure release hooks
