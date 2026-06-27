# Changelog

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
