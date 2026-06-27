# UI Update Module Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Tách update flow ra khỏi `cpp/src/ui.cpp` để UI chỉ render và poll state, còn manifest parsing, SHA-256, và danh sách file cần cập nhật đi vào một module sâu riêng.

**Architecture:** `cpp/src/ui.cpp` sẽ giữ vai trò UI host và worker thread, nhưng mọi xử lý manifest/hash/update quyết định file sẽ đi qua một update module mới. Module mới sẽ có interface nhỏ, nhận `version.json` dưới dạng path + nội dung, và trả ra dữ liệu đủ cho UI poll theo `progress`, `phase`, `message`.

**Tech Stack:** C++17, CMake 3.20+, Win32, DirectX 11, Dear ImGui, WinCrypt, `std::thread`, `std::filesystem`

## Global Constraints

- `Giữ cpp/src/ui.cpp làm module điều phối giao diện và worker thread.`
- `Tách logic update ra module riêng cho:`
  - `đọc version.json từ path + nội dung,`
  - `parse manifest,`
  - `so khớp file local bằng SHA-256,`
  - `quyết định danh sách file cần cập nhật,`
  - `cập nhật state để UI poll.`
- `Không đổi luồng Win32 / DirectX / ImGui trong lần này.`
- `Không thêm current file hay error vào state ban đầu.`
- `Chuẩn integrity check dùng SHA-256.`
- `Worker thread vẫn nằm ở ui.cpp theo quyết định đã chốt.`

---

### Task 1: Tạo update module sâu + smoke test

**Files:**
- Create: `cpp/include/update.h`
- Create: `cpp/src/update.cpp`
- Create: `cpp/tests/update_module_smoke.cpp`
- Modify: `cpp/CMakeLists.txt`

**Interfaces:**
- Consumes: raw manifest path + content from `ui.cpp` or the smoke test.
- Produces: `launcher::update::ManifestSource`, `launcher::update::Manifest`, `launcher::update::FileEntry`, `launcher::update::UpdatePhase`, `launcher::update::UpdateSnapshot`, `launcher::update::ParseManifest`, `launcher::update::ComputeSha256`, `launcher::update::CollectFilesToUpdate`.

- [ ] **Step 1: Write the failing smoke test**

```cpp
// cpp/tests/update_module_smoke.cpp
#include "update.h"

#include <filesystem>
#include <fstream>
#include <iostream>

int main() {
    namespace fs = std::filesystem;

    const fs::path temp_root = fs::temp_directory_path() / "launcherjx-update-smoke";
    fs::create_directories(temp_root);

    const fs::path payload_path = temp_root / "payload.bin";
    {
        std::ofstream out(payload_path, std::ios::binary);
        out << "abc";
    }

    launcher::update::ManifestSource source;
    source.path = temp_root / "version.json";
    source.content = R"json({
        "version": "v1.0.1",
        "files": [
            { "name": "payload.bin", "hash": "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad" }
        ]
    })json";

    launcher::update::Manifest manifest;
    std::string error;
    if (!launcher::update::ParseManifest(source, &manifest, &error)) {
        std::cerr << error << "\n";
        return 1;
    }

    if (manifest.version != "v1.0.1" || manifest.files.size() != 1) {
        std::cerr << "manifest parse mismatch\n";
        return 1;
    }

    if (launcher::update::ComputeSha256(payload_path.wstring()) !=
        "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad") {
        std::cerr << "sha256 mismatch\n";
        return 1;
    }

    const auto pending = launcher::update::CollectFilesToUpdate(temp_root.wstring(), manifest);
    if (!pending.empty()) {
        std::cerr << "expected no pending files\n";
        return 1;
    }

    return 0;
}
```

- [ ] **Step 2: Run the smoke target and confirm it fails before the module exists**

Run:

```powershell
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build --target update_module_smoke
```

Expected: compile failure because `cpp/include/update.h` and the symbols it declares do not exist yet.

- [ ] **Step 3: Implement the module with the smallest useful surface**

```cpp
// cpp/include/update.h
#pragma once

#include <string>
#include <vector>

namespace launcher::update {

struct ManifestSource {
    std::wstring path;
    std::string content;
};

struct FileEntry {
    std::string name;
    std::string hash;
};

struct Manifest {
    std::string version;
    std::vector<FileEntry> files;
};

enum class UpdatePhase {
    Idle,
    Checking,
    Downloading,
    Done,
    Error,
};

struct UpdateSnapshot {
    float progress = 0.0f;
    UpdatePhase phase = UpdatePhase::Idle;
    std::string message;
};

bool ParseManifest(const ManifestSource& source, Manifest* out_manifest, std::string* error);
std::string ComputeSha256(const std::wstring& file_path);
std::vector<std::wstring> CollectFilesToUpdate(const std::wstring& exe_dir, const Manifest& manifest);

}  // namespace launcher::update
```

Implementation rules for `cpp/src/update.cpp`:

- Parse JSON with the same plain, explicit style already in `ui.cpp`.
- Read `version` and `files` only.
- Keep `ParseManifest` tolerant of malformed JSON by returning `false` and filling `error`.
- Use `SHA-256` only.
- Keep filesystem path joining local and explicit with `std::filesystem` or direct Win32-style strings, but do not add extra abstractions.

`cpp/CMakeLists.txt` must add the new source files to both the launcher target and the smoke target, and link `advapi32` if `ComputeSha256` uses CryptoAPI.

- [ ] **Step 4: Run the smoke test until it passes**

Run:

```powershell
cmake --build build --target update_module_smoke
.\build\bin\update_module_smoke.exe
```

Expected: exit code `0`.

- [ ] **Step 5: Commit**

```powershell
git add cpp/include/update.h cpp/src/update.cpp cpp/tests/update_module_smoke.cpp cpp/CMakeLists.txt
git commit -m "feat: add deep update module"
```

### Task 2: Rewire `cpp/src/ui.cpp` to poll the update module

**Files:**
- Modify: `cpp/src/ui.cpp`

**Interfaces:**
- Consumes: `launcher::update::ManifestSource`, `launcher::update::Manifest`, `launcher::update::ParseManifest`, `launcher::update::ComputeSha256`, `launcher::update::CollectFilesToUpdate`.
- Produces: one UI-only worker thread path where `RenderUI` only reads `progress`, `phase`, `message`.

- [ ] **Step 1: Remove the local update helpers from `ui.cpp`**

Delete these local responsibilities from `cpp/src/ui.cpp`:

- `CalculateMD5`
- `ParseJsonValue`
- `ParseJsonFiles`
- `GameFileConfig`
- any direct update decision logic that scans the manifest inline

Keep these responsibilities in `ui.cpp`:

- `InitUI`
- `RenderUI`
- `CleanupUI`
- texture loading
- worker thread ownership
- state polling and UI rendering

- [ ] **Step 2: Replace the worker thread body with update-module calls**

```cpp
// inside the UPDATE button path in RenderUI
g_updateThread = std::thread([]() {
    const std::wstring exe_dir = GetExecutablePath();
    const std::wstring manifest_path = exe_dir + L"\\launcher_res\\version.json";

    std::ifstream manifest_file(manifest_path);
    if (!manifest_file.is_open()) {
        g_updateSnapshot.phase = launcher::update::UpdatePhase::Idle;
        g_updateSnapshot.message = "Khong mo duoc version.json";
        return;
    }

    const std::string manifest_content(
        std::istreambuf_iterator<char>(manifest_file),
        std::istreambuf_iterator<char>());

    launcher::update::ManifestSource source{manifest_path, manifest_content};
    launcher::update::Manifest manifest;
    std::string error;
    if (!launcher::update::ParseManifest(source, &manifest, &error)) {
        g_updateSnapshot.phase = launcher::update::UpdatePhase::Error;
        g_updateSnapshot.message = error;
        return;
    }

    g_updateSnapshot.phase = launcher::update::UpdatePhase::Checking;
    const auto files_to_update = launcher::update::CollectFilesToUpdate(exe_dir, manifest);
    // progress updates stay here; the module only decides what needs work
});
```

`launcher::update::UpdateSnapshot` stays the only state shape that `RenderUI` polls.

- [ ] **Step 3: Convert the UI labels to the new phase model**

Map the internal phase enum to the visible labels already used by the launcher:

- `Idle` -> ready text
- `Checking` -> checking text
- `Downloading` -> downloading text with `progress`
- `Done` -> complete text

Keep the UI copy short. Do not add `current file` or `error` fields to the visible state.

- [ ] **Step 4: Build the launcher and run it once**

Run:

```powershell
cmake --build build --target LauncherJX
.\build\bin\LauncherJX.exe
```

Expected:

- app opens normally;
- `RenderUI` no longer contains inline JSON parsing or hash calculation;
- clicking `UPDATE` still drives the progress bar and status text;
- shutdown still joins the worker thread cleanly.

- [ ] **Step 5: Commit**

```powershell
git add cpp/src/ui.cpp
git commit -m "feat: decouple ui update flow"
```

## Validation Checklist

- `update_module_smoke` passes with the embedded `abc` SHA-256 fixture.
- `LauncherJX` builds after `ui.cpp` stops owning manifest parsing and hashing.
- `RenderUI` only renders and polls state.
- `SHA-256` replaces every use of `MD5` in the update path.
- Worker thread still lives in `ui.cpp`.
