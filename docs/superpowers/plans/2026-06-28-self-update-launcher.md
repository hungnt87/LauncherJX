# Self-Update LauncherJX Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` or `superpowers:subagent-driven-development` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a Windows self-update path for `LauncherJX.exe` that checks update metadata on startup, verifies hashes, downloads `updater.exe` from the release asset when the local copy is missing or mismatched, replaces the running launcher safely, and keeps manual updates for non-exe files.

**Architecture:** `LauncherJX.exe` owns startup checks, manifest parsing, and the decision to enter self-update. `updater.exe` is a tiny helper process that waits for the launcher to exit, verifies the downloaded launcher binary hash, swaps the file into place, and relaunches the new launcher. Existing game-file update logic stays in `LauncherApp` and remains user-triggered.

**Tech Stack:** C++17, Win32, WinINet, SHA-256 hashing, CMake, Python 3, GitHub Releases.

## Global Constraints

- Khi có bản mới, `LauncherJX.exe` phải ưu tiên tự cập nhật chính nó ngay lúc khởi động, trước khi vào UI chính.
- Trong lúc tải file `exe` mới, launcher vẫn phải hiện màn hình chờ.
- Khi tới bước thay thế file đang chạy, launcher phải tự đóng và chuyển quyền cho `updater.exe`.
- `updater.exe` là công cụ riêng chịu trách nhiệm thay file và mở lại launcher mới.
- Nếu máy chưa có `updater.exe`, launcher phải tự tải từ release asset.
- `LauncherJX.exe` phải kiểm tra SHA-256 của `updater.exe` trước khi chạy nó.
- `updater.exe` phải kiểm tra SHA-256 của `LauncherJX.exe` mới trước khi thay thế.
- Các file game khác không tự cài đặt; người dùng vẫn bấm nút cập nhật như hiện tại.

---

### Task 1: Extend manifest schema and hash helpers

**Files:**
- Modify: `cpp/include/update.h`
- Modify: `cpp/src/update.cpp`
- Modify: `cpp/tests/update_test.cpp`
- Modify: `tools/generate_manifest.py`

**Interfaces:**
- Consumes: `launcher::update::ParseManifest(...)`, `launcher::update::ComputeSha256(...)`, `launcher::update::CompareSemanticVersion(...)`
- Produces:
  - `struct UpdaterAsset { std::string name; std::string hash; };`
  - `struct Manifest` with an optional updater block, for example `std::optional<UpdaterAsset> updater;`
  - `bool VerifyFileSha256(const std::wstring& file_path, const std::string& expected_hash);`
  - `bool ManifestHasLauncherBinary(const Manifest& manifest);`

- [ ] **Step 1: Write the failing test**

Add assertions to `cpp/tests/update_test.cpp` that fail until the updater block and hash verification exist:

```cpp
void TestManifestUpdaterAndHash() {
    using namespace launcher::update;

    const std::string json = R"({
      "version": "v1.2.3",
      "updater": {
        "name": "updater.exe",
        "hash": "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
      },
      "files": [
        { "name": "LauncherJX.exe", "hash": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "zip": "" }
      ]
    })";

    ManifestSource source;
    source.path = L"manifest.json";
    source.content = json;

    Manifest manifest;
    std::string error;
    assert(ParseManifest(source, &manifest, &error));
    assert(manifest.updater.has_value());
    assert(manifest.updater->name == "updater.exe");
    assert(ManifestHasLauncherBinary(manifest));
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```powershell
cmake --build build --target update_tests
.\build\bin\update_tests.exe
```

Expected: fail because `ParseManifest()` does not understand the updater block yet, and `ManifestHasLauncherBinary()` / `VerifyFileSha256()` are not implemented.

- [ ] **Step 3: Write minimal implementation**

Implement the smallest change set that makes the test pass:

```cpp
struct UpdaterAsset {
    std::string name;
    std::string hash;
};

struct Manifest {
    std::string version;
    std::optional<UpdaterAsset> updater;
    std::vector<FileEntry> files;
};

bool VerifyFileSha256(const std::wstring& file_path, const std::string& expected_hash);
bool ManifestHasLauncherBinary(const Manifest& manifest);
```

Update `tools/generate_manifest.py` so it can emit:

```json
{
  "version": "v1.2.3",
  "updater": {
    "name": "updater.exe",
    "hash": "<sha256>"
  },
  "files": [...]
}
```

Keep the existing `files` layout unchanged.

- [ ] **Step 4: Run test to verify it passes**

Run:

```powershell
cmake --build build --target update_tests
.\build\bin\update_tests.exe
```

Expected: all assertions pass, including the new manifest/updater assertions.

- [ ] **Step 5: Commit**

```powershell
git add cpp/include/update.h cpp/src/update.cpp cpp/tests/update_test.cpp tools/generate_manifest.py
git commit -m "feat: add updater metadata and hash helpers"
```

---

### Task 2: Add launcher self-update orchestration

**Files:**
- Modify: `cpp/include/launcher_app.h`
- Modify: `cpp/src/launcher_app.cpp`
- Modify: `cpp/src/ui.cpp`

**Interfaces:**
- Consumes:
  - `launcher::update::Manifest`
  - `launcher::update::FileEntry`
  - `launcher::update::VerifyFileSha256(...)`
- Produces:
  - `void RunSelfUpdateWorker();`
  - `bool ShouldSelfUpdate(const launcher::update::Manifest& manifest) const;`
  - `bool EnsureUpdaterBinary(const launcher::update::Manifest& manifest, std::wstring* updater_path, std::string* error);`
  - `bool LaunchUpdaterAndExit(const std::wstring& updater_path, const std::wstring& launcher_new_path, const std::string& expected_hash);`

- [ ] **Step 1: Write the failing test**

Extend `cpp/tests/update_test.cpp` with one new assertion block focused on manifest classification:

```cpp
void TestLauncherSelfUpdateSelection() {
    using namespace launcher::update;

    Manifest manifest;
    manifest.version = "v2.0.0";
    manifest.updater = UpdaterAsset{"updater.exe", "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"};
    manifest.files.push_back(FileEntry{"LauncherJX.exe", "cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc", ""});
    manifest.files.push_back(FileEntry{"data.pak", "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd", "patch.zip"});

    // Expected behavior: launcher binary is treated as self-update, not as a manual file update.
    assert(ManifestHasLauncherBinary(manifest));
}
```

Add a UI expectation: when the snapshot enters self-update, the button area must not offer the normal manual update action.

- [ ] **Step 2: Run test to verify it fails**

Run:

```powershell
cmake --build build --target LauncherJX
cmake --build build --target update_tests
.\build\bin\update_tests.exe
```

Expected: the new launcher-selection behavior is not implemented yet, so the self-update scenario does not classify launcher files separately.

- [ ] **Step 3: Write minimal implementation**

Implement startup self-update flow in `LauncherApp`:

```cpp
class LauncherApp {
private:
    void RunCheckWorker();
    void RunUpdateWorker();
    void RunSelfUpdateWorker();
    bool ShouldSelfUpdate(const launcher::update::Manifest& manifest) const;
    bool EnsureUpdaterBinary(const launcher::update::Manifest& manifest, std::wstring* updater_path, std::string* error);
    bool LaunchUpdaterAndExit(const std::wstring& updater_path, const std::wstring& launcher_new_path, const std::string& expected_hash);
};
```

Implement the startup decision:

1. `Initialize()` kicks off the check thread immediately.
2. `RunCheckWorker()` downloads `version.json`.
3. If the manifest includes a newer `LauncherJX.exe`, set a self-update snapshot message and run `RunSelfUpdateWorker()`.
4. If only non-exe files differ, keep the existing manual update path.

Use this command-line contract when launching the helper:

```text
updater.exe --launcher-pid <pid> --current "<path to LauncherJX.exe>" --new "<path to LauncherJX.exe.new>" --expected-hash <sha256> --launch "<path to LauncherJX.exe>"
```

Update `ui.cpp` so the status area can show a dedicated self-update message and disables the normal update button while self-update is active.

- [ ] **Step 4: Run test to verify it passes**

Run:

```powershell
cmake --build build --target LauncherJX
cmake --build build --target update_tests
.\build\bin\update_tests.exe
```

Expected: launcher self-update selection is reflected in the test harness, and the launcher still preserves the manual update path for non-exe files.

- [ ] **Step 5: Commit**

```powershell
git add cpp/include/launcher_app.h cpp/src/launcher_app.cpp cpp/src/ui.cpp
git commit -m "feat: add launcher self-update orchestration"
```

---

### Task 3: Create the standalone `updater.exe`

**Files:**
- Create: `updater/CMakeLists.txt`
- Create: `updater/include/updater.h`
- Create: `updater/src/main.cpp`
- Create: `updater/src/updater.cpp`
- Create: `updater/tests/updater_test.cpp`
- Modify: `CMakeLists.txt`

**Interfaces:**
- Consumes:
  - command-line arguments from `LauncherApp::LaunchUpdaterAndExit(...)`
  - `SHA-256` values stored in manifest
- Produces:
  - `struct UpdaterArgs { DWORD launcher_pid; std::wstring current_path; std::wstring new_path; std::wstring backup_path; std::wstring launch_path; std::string expected_hash; };`
  - `bool ParseUpdaterArgs(int argc, wchar_t** argv, UpdaterArgs* out, std::wstring* error);`
  - `bool WaitForLauncherExit(DWORD pid, std::wstring* error);`
  - `bool VerifyFileSha256(const std::wstring& path, const std::string& expected_hash, std::wstring* error);`
  - `bool ReplaceExecutable(const std::wstring& current_path, const std::wstring& new_path, const std::wstring& backup_path, std::wstring* error);`
  - `bool RelaunchLauncher(const std::wstring& launch_path, std::wstring* error);`

- [ ] **Step 1: Write the failing test**

Add `updater/tests/updater_test.cpp` with asserts for parsing, hash verification, and replace behavior:

```cpp
int main() {
    UpdaterArgs args{};
    std::wstring error;

    const wchar_t* argv[] = {
        L"updater.exe",
        L"--launcher-pid", L"1234",
        L"--current", L"C:\\LauncherJX\\LauncherJX.exe",
        L"--new", L"C:\\LauncherJX\\tmp\\LauncherJX.exe.new",
        L"--expected-hash", L"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        L"--launch", L"C:\\LauncherJX\\LauncherJX.exe"
    };

    assert(ParseUpdaterArgs(13, const_cast<wchar_t**>(argv), &args, &error));
    assert(args.launcher_pid == 1234);
    assert(args.launch_path == L"C:\\LauncherJX\\LauncherJX.exe");
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```powershell
cmake --build build --target updater_tests
.\build\bin\updater_tests.exe
```

Expected: fail because `updater` target and argument parsing are not implemented yet.

- [ ] **Step 3: Write minimal implementation**

Implement `updater.exe` as a tiny GUI-subsystem helper that does not flash a console window. Keep the workflow simple:

1. Parse args.
2. Wait for the launcher PID to exit.
3. Recalculate SHA-256 for the downloaded launcher binary.
4. Copy `LauncherJX.exe` to a `.bak` path if backup is enabled.
5. Replace the launcher file with the new binary.
6. Relaunch `LauncherJX.exe`.

Recommended command-line contract:

```text
updater.exe --launcher-pid <pid> --current "<path>" --new "<path>" --expected-hash <sha256> --launch "<path>" --backup "<path>"
```

Add `updater/CMakeLists.txt` and wire it from the root `CMakeLists.txt` so the build produces `updater.exe` and `updater_tests.exe`.

- [ ] **Step 4: Run test to verify it passes**

Run:

```powershell
cmake --build build --target updater_tests
.\build\bin\updater_tests.exe
```

Expected: updater argument parsing and file replacement helpers pass their asserts.

- [ ] **Step 5: Commit**

```powershell
git add CMakeLists.txt updater
git commit -m "feat: add standalone updater executable"
```

---

### Task 4: Wire manifest generation and release assets

**Files:**
- Modify: `tools/generate_manifest.py`
- Modify: `.releaserc.yml`
- Modify: `patch/version.json` after regeneration

**Interfaces:**
- Consumes:
  - built `updater.exe` path from the release/build pipeline
  - release version tag passed by the existing hook
- Produces:
  - `version.json` with updater asset name + SHA-256
  - release hook that keeps `patch/version.json` in sync and publishes `updater.exe` as a release asset

- [ ] **Step 1: Write the failing test**

Add a reproducible manifest-generation check by running the script against a local built updater binary and validating the output JSON contains the updater block:

```powershell
python tools\generate_manifest.py v1.2.3 --updater-path .\build\bin\updater.exe --updater-name updater.exe
```

Then inspect `patch\version.json` and confirm it contains:

```json
{
  "updater": {
    "name": "updater.exe",
    "hash": "<sha256>"
  }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```powershell
python tools\generate_manifest.py v1.2.3 --updater-path .\build\bin\updater.exe --updater-name updater.exe
Get-Content patch\version.json
```

Expected: the script still only writes the old schema until the updater block is added.

- [ ] **Step 3: Write minimal implementation**

Extend `tools/generate_manifest.py` with `argparse`:

```python
parser.add_argument("version")
parser.add_argument("--updater-path")
parser.add_argument("--updater-name", default="updater.exe")
```

When `--updater-path` is present, compute its SHA-256 and write the `updater` object into `version.json`.

Update `.releaserc.yml` so the release hook still runs `generate_manifest.py` and the release pipeline includes `updater.exe` as an asset alongside the launcher binary.

- [ ] **Step 4: Run test to verify it passes**

Run:

```powershell
python tools\generate_manifest.py v1.2.3 --updater-path .\build\bin\updater.exe --updater-name updater.exe
cmake --build build --target LauncherJX updater_tests update_tests
```

Expected: the generated manifest contains the updater block, the build still succeeds, and both binaries are produced by the build tree.

- [ ] **Step 5: Commit**

```powershell
git add tools/generate_manifest.py .releaserc.yml patch/version.json
git commit -m "feat: publish updater asset metadata in release manifest"
```

---

## Test Matrix

- Build `LauncherJX`, `update_tests`, and `updater_tests` from a clean tree.
- Verify `update_tests` passes after manifest schema changes.
- Verify `updater_tests` passes after the standalone updater helper lands.
- Run the launcher with a newer `version.json` and confirm it enters self-update before showing the main UI.
- Run the launcher with missing `updater.exe` and confirm it downloads the helper from release asset.
- Confirm the launcher still shows the manual update button for non-exe files.
- Confirm a SHA-256 mismatch on `updater.exe` blocks execution and triggers a re-download.
- Confirm a SHA-256 mismatch on the downloaded launcher binary blocks replacement.
- Confirm the launcher closes and relaunches after the updater swaps the executable.

## Assumptions

- The release pipeline will ship `updater.exe` as a GitHub Release asset for each launcher release.
- The launcher binary name stays `LauncherJX.exe`.
- The updater binary name stays `updater.exe`.
- A small backup file such as `LauncherJX.exe.bak` is acceptable if the implementation wants rollback support.
