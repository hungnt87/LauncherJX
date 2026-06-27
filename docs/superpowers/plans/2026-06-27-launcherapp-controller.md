# LauncherApp Controller Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Tách lifecycle, snapshot state, và update worker ra khỏi `cpp/src/ui.cpp` vào controller trung tâm `LauncherApp`, để UI chỉ render và gọi hành động.

**Architecture:** `LauncherApp` sở hữu running flag, snapshot mutex/state, version string, executable directory, và worker thread. `ui.cpp` chỉ giữ render, texture/font/style setup, và cleanup graphics-side. `main.cpp` tạo controller, khởi tạo UI/backend, chạy render loop, và shutdown theo thứ tự an toàn.

**Tech Stack:** C++17, Win32, DirectX 11, Dear ImGui, GDI+, `std::thread`, `std::mutex`, `std::atomic`, CMake 3.20+

## Global Constraints

- Them controller `LauncherApp` cho update lifecycle.
- Di chuyen running flag, snapshot state, va worker thread vao controller.
- Di chuyen parse `version.json` va khoi tao state ban dau vao controller.
- De `ui.cpp` chi render, doc snapshot, va phat tin hieu `UPDATE` / `PLAY`.
- De `main.cpp` tao controller, khoi tao UI, chay render loop, va shutdown sach.
- Cap nhat CMake de build them source moi neu can.
- Khong doi update algorithm.
- Khong doi giao dien, asset, hay layout UI.
- Khong doi build refactor da lam o pha truoc ngoai viec them source moi.

---

### Task 1: Add `LauncherApp` ownership for lifecycle and update state

**Files:**
- Create: `cpp/include/launcher_app.h`
- Create: `cpp/src/launcher_app.cpp`
- Modify: `cpp/CMakeLists.txt`

**Interfaces:**
- Consumes: `launcher::update::ManifestSource`, `launcher::update::Manifest`, `launcher::update::UpdateSnapshot`, `launcher::update::UpdatePhase`, `launcher::update::ParseManifest`, `launcher::update::CollectFilesToUpdate`.
- Produces: `LauncherApp` with `Initialize`, `StartUpdate`, `Shutdown`, `Snapshot`, `ExecutableDir`, and `VersionString`.

- [ ] **Step 1: Write the controller header**

Create `cpp/include/launcher_app.h` with this exact public surface:

```cpp
#pragma once

#include <atomic>
#include <mutex>
#include <string>
#include <thread>

#include "update.h"

class LauncherApp {
public:
    LauncherApp();
    ~LauncherApp();

    void Initialize(const std::wstring& exe_dir);
    void StartUpdate();
    void Shutdown() noexcept;

    launcher::update::UpdateSnapshot Snapshot() const;
    const std::wstring& ExecutableDir() const noexcept;
    const std::string& VersionString() const noexcept;

private:
    void RunUpdateWorker();
    void SetSnapshot(const launcher::update::UpdateSnapshot& snapshot);

    std::atomic<bool> running_{true};
    mutable std::mutex snapshot_mutex_;
    launcher::update::UpdateSnapshot snapshot_{};
    std::wstring exe_dir_;
    std::string version_string_;
    std::thread update_thread_;
};
```

- [ ] **Step 2: Write the controller implementation**

Create `cpp/src/launcher_app.cpp` by moving these responsibilities out of `ui.cpp`:

- executable path / version.json loading;
- manifest parsing;
- snapshot initialization and update;
- worker thread ownership;
- shutdown join logic;
- file update loop currently inside the `UPDATE` button handler.

Use this implementation shape:

```cpp
#include "launcher_app.h"

#include <chrono>
#include <fstream>
#include <iterator>

namespace {

std::string ReadFileText(const std::wstring& path);

}  // namespace

LauncherApp::LauncherApp() = default;

LauncherApp::~LauncherApp() {
    Shutdown();
}

void LauncherApp::Initialize(const std::wstring& exe_dir) {
    exe_dir_ = exe_dir;

    const std::wstring version_path = exe_dir_ + L"\\launcher_res\\version.json";
    const std::string json_content = ReadFileText(version_path);
    if (json_content.empty()) {
        launcher::update::UpdateSnapshot error_snapshot;
        error_snapshot.phase = launcher::update::UpdatePhase::Error;
        error_snapshot.message = "Khong mo duoc version.json";
        SetSnapshot(error_snapshot);
        return;
    }

    launcher::update::ManifestSource source;
    source.path = version_path;
    source.content = json_content;

    launcher::update::Manifest manifest;
    std::string error;
    if (!launcher::update::ParseManifest(source, &manifest, &error)) {
        launcher::update::UpdateSnapshot error_snapshot;
        error_snapshot.phase = launcher::update::UpdatePhase::Error;
        error_snapshot.message = error;
        SetSnapshot(error_snapshot);
        return;
    }

    version_string_ = manifest.version;

    launcher::update::UpdateSnapshot ready_snapshot;
    ready_snapshot.progress = 0.0f;
    ready_snapshot.phase = launcher::update::UpdatePhase::Idle;
    ready_snapshot.message = "He thong da san sang. Bam UPDATE de cap nhat game.";
    SetSnapshot(ready_snapshot);
}

void LauncherApp::StartUpdate() {
    if (update_thread_.joinable()) {
        update_thread_.join();
    }

    launcher::update::UpdateSnapshot start_snapshot;
    start_snapshot.progress = 0.0f;
    start_snapshot.phase = launcher::update::UpdatePhase::Checking;
    start_snapshot.message = "Dang kiem tra ban cap nhat...";
    SetSnapshot(start_snapshot);

    update_thread_ = std::thread(&LauncherApp::RunUpdateWorker, this);
}

void LauncherApp::Shutdown() noexcept {
    running_ = false;
    if (update_thread_.joinable()) {
        update_thread_.join();
    }
}

launcher::update::UpdateSnapshot LauncherApp::Snapshot() const {
    std::lock_guard<std::mutex> lock(snapshot_mutex_);
    return snapshot_;
}

const std::wstring& LauncherApp::ExecutableDir() const noexcept {
    return exe_dir_;
}

const std::string& LauncherApp::VersionString() const noexcept {
    return version_string_;
}

void LauncherApp::RunUpdateWorker() {
    const std::wstring version_path = exe_dir_ + L"\\launcher_res\\version.json";
    const std::string json_content = ReadFileText(version_path);
    if (json_content.empty()) {
        launcher::update::UpdateSnapshot error_snapshot;
        error_snapshot.phase = launcher::update::UpdatePhase::Error;
        error_snapshot.message = "Khong mo duoc version.json";
        SetSnapshot(error_snapshot);
        return;
    }

    launcher::update::ManifestSource source;
    source.path = version_path;
    source.content = json_content;

    launcher::update::Manifest manifest;
    std::string error;
    if (!launcher::update::ParseManifest(source, &manifest, &error)) {
        launcher::update::UpdateSnapshot error_snapshot;
        error_snapshot.phase = launcher::update::UpdatePhase::Error;
        error_snapshot.message = error;
        SetSnapshot(error_snapshot);
        return;
    }

    launcher::update::UpdateSnapshot checking_snapshot;
    checking_snapshot.progress = 0.0f;
    checking_snapshot.phase = launcher::update::UpdatePhase::Checking;
    checking_snapshot.message = "Dang kiem tra cac file...";
    SetSnapshot(checking_snapshot);

    const auto files_to_update = launcher::update::CollectFilesToUpdate(exe_dir_, manifest);
    if (files_to_update.empty()) {
        launcher::update::UpdateSnapshot done_snapshot;
        done_snapshot.progress = 1.0f;
        done_snapshot.phase = launcher::update::UpdatePhase::Done;
        done_snapshot.message = "Cap nhat hoan tat! He thong da san sang.";
        SetSnapshot(done_snapshot);
        return;
    }

    launcher::update::UpdateSnapshot downloading_snapshot;
    downloading_snapshot.progress = 0.0f;
    downloading_snapshot.phase = launcher::update::UpdatePhase::Downloading;
    downloading_snapshot.message = "Dang tai ban cap nhat...";
    SetSnapshot(downloading_snapshot);

    for (size_t idx = 0; idx < files_to_update.size(); ++idx) {
        if (!running_) {
            break;
        }

        for (int i = 0; i <= 100; ++i) {
            if (!running_) {
                break;
            }

            const float progress = (static_cast<float>(idx) + static_cast<float>(i) / 100.0f) /
                                   static_cast<float>(files_to_update.size());
            launcher::update::UpdateSnapshot progress_snapshot = Snapshot();
            progress_snapshot.progress = progress;
            progress_snapshot.phase = launcher::update::UpdatePhase::Downloading;
            progress_snapshot.message = "Dang tai ban cap nhat...";
            SetSnapshot(progress_snapshot);
            std::this_thread::sleep_for(std::chrono::milliseconds(20));
        }

        std::ofstream out_file(files_to_update[idx], std::ios::binary);
        if (out_file.is_open()) {
            out_file << "Phien ban moi nhat da duoc tai xuong.";
        }
    }

    if (running_) {
        launcher::update::UpdateSnapshot done_snapshot;
        done_snapshot.progress = 1.0f;
        done_snapshot.phase = launcher::update::UpdatePhase::Done;
        done_snapshot.message = "Cap nhat hoan tat! He thong da san sang.";
        SetSnapshot(done_snapshot);
    }
}

void LauncherApp::SetSnapshot(const launcher::update::UpdateSnapshot& snapshot) {
    std::lock_guard<std::mutex> lock(snapshot_mutex_);
    snapshot_ = snapshot;
}

namespace {

std::string ReadFileText(const std::wstring& path) {
    std::ifstream file(path, std::ios::binary);
    if (!file.is_open()) {
        return "";
    }

    return std::string(std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>());
}

}  // namespace
```

`cpp/CMakeLists.txt` must add `src/launcher_app.cpp` to the launcher executable target and include `launcher_app.h` from `cpp/include`.

- [ ] **Step 3: Build the launcher after the controller is introduced**

Run:

```powershell
cmake -S . -B build
cmake --build build --target LauncherJX
```

Expected:

- Configure succeeds.
- `LauncherJX` builds with the new controller source.
- No missing symbol errors for `LauncherApp`.

- [ ] **Step 4: Commit the controller core**

```powershell
git add cpp/include/launcher_app.h cpp/src/launcher_app.cpp cpp/CMakeLists.txt
git commit -m "feat: add launcher app controller"
```

### Task 2: Rewire `ui.cpp` to render only and call `LauncherApp`

**Files:**
- Modify: `cpp/include/ui.h`
- Modify: `cpp/src/ui.cpp`

**Interfaces:**
- Consumes: `LauncherApp` public API from `cpp/include/launcher_app.h`.
- Produces: `InitUI`, `RenderUI(LauncherApp& app)`, and `CleanupUI` with UI-only responsibilities.

- [ ] **Step 1: Update the UI header to accept the controller**

Change `cpp/include/ui.h` to this shape:

```cpp
#pragma once

#include <windows.h>
#include <d3d11.h>

class LauncherApp;

void InitUI(ID3D11Device* device, ID3D11DeviceContext* context, HWND hWnd);
void RenderUI(LauncherApp& app);
void CleanupUI();
```

- [ ] **Step 2: Remove controller-owned state from `ui.cpp`**

Delete these responsibilities from `cpp/src/ui.cpp`:

- `g_appRunning`
- `g_updateThread`
- `GetUpdateSnapshot`
- `SetUpdateSnapshot`
- `UpdateSnapshotProgress`
- `UpdateSnapshotPhase`
- `UpdateSnapshotMessage`
- `ReadFileText`
- the `UPDATE` button worker thread lambda
- manifest parsing and file selection

Keep these responsibilities in `ui.cpp`:

- DirectX / ImGui texture setup;
- GDI+ image loading;
- style/font initialization;
- render tree and visible UI strings;
- cleanup of textures.

- [ ] **Step 3: Make `RenderUI` read from the controller**

Use this public signature and call pattern:

```cpp
void RenderUI(LauncherApp& app) {
    const launcher::update::UpdateSnapshot snapshot = app.Snapshot();
    const std::string title_text = "LauncherJX - " + app.VersionString();

    if (snapshot.phase == launcher::update::UpdatePhase::Idle || snapshot.phase == launcher::update::UpdatePhase::Error) {
        if (ImGui::Button("UPDATE", ImVec2(120, 36))) {
            app.StartUpdate();
        }
    } else if (snapshot.phase == launcher::update::UpdatePhase::Done) {
        if (ImGui::Button("PLAY", ImVec2(120, 36))) {
            MessageBoxW(g_hWnd, L"Dang khoi chay game Vo Lam Truyen Ky! Chuc dai hiep choi game vui ve.", L"LauncherJX", MB_OK | MB_ICONINFORMATION);
            PostQuitMessage(0);
        }
    }
}
```

Keep the existing phase-to-text mapping and progress bar behavior.

- [ ] **Step 4: Ensure `ui.cpp` no longer owns update lifecycle**

After the rewrite, `ui.cpp` must not:

- join or detach a thread;
- mutate snapshot state directly;
- read `version.json`;
- compute file update lists.

- [ ] **Step 5: Rebuild and run the app**

Run:

```powershell
cmake --build build --target LauncherJX
.\build\bin\Debug\LauncherJX.exe
```

Expected:

- UI renders normally.
- `UPDATE` still triggers progress and status changes through `LauncherApp`.
- `PLAY` still appears when update reaches `Done`.
- Shutdown still exits cleanly.

- [ ] **Step 6: Commit the UI rewrite**

```powershell
git add cpp/include/ui.h cpp/src/ui.cpp
git commit -m "refactor: move update lifecycle out of ui"
```

### Task 3: Update `main.cpp` to bootstrap and shutdown `LauncherApp`

**Files:**
- Modify: `cpp/src/main.cpp`
- Modify: `cpp/CMakeLists.txt`

**Interfaces:**
- Consumes: `LauncherApp`, `InitUI`, `RenderUI(LauncherApp&)`, `CleanupUI`.
- Produces: a main loop that creates the controller, initializes it once, renders through it, and shuts it down in the correct order.

- [ ] **Step 1: Add the controller include and create an instance**

Change `cpp/src/main.cpp` so it includes the new controller header:

```cpp
#include "launcher_app.h"
#include "ui.h"
```

Add this local helper near the top of `main.cpp` so startup stays self-contained:

```cpp
namespace {

std::wstring GetExecutablePath() {
    wchar_t buffer[MAX_PATH];
    GetModuleFileNameW(nullptr, buffer, MAX_PATH);
    std::wstring path(buffer);
    const size_t pos = path.find_last_of(L"\\/");
    if (pos != std::wstring::npos) {
        return path.substr(0, pos);
    }
    return L".";
}

}  // namespace
```

Create the app before `InitUI`:

```cpp
LauncherApp app;
app.Initialize(GetExecutablePath());
```

- [ ] **Step 2: Pass the controller into the render loop**

Replace:

```cpp
RenderUI();
```

with:

```cpp
RenderUI(app);
```

Keep all Win32 / DX11 / ImGui bootstrap and teardown code unchanged except for lifecycle ordering.

- [ ] **Step 3: Shutdown the controller before graphics teardown**

Make the shutdown order explicit:

```cpp
app.Shutdown();
CleanupUI();
ImGui_ImplDX11_Shutdown();
ImGui_ImplWin32_Shutdown();
ImGui::DestroyContext();
```

This ensures the update thread is joined before graphics objects disappear.

- [ ] **Step 4: Add the new source to CMake if needed**

If the launcher target does not yet include `src/launcher_app.cpp`, add it beside the other launcher sources in `cpp/CMakeLists.txt`:

```cmake
target_sources(LauncherJX
    PRIVATE
        src/main.cpp
        src/ui.cpp
        src/update.cpp
        src/launcher_app.cpp
        resources/app.rc
        $<TARGET_OBJECTS:imgui_objects>
)
```

- [ ] **Step 5: Build and run the final launcher**

Run:

```powershell
cmake --build build --target LauncherJX
.\build\bin\Debug\LauncherJX.exe
```

Expected:

- Launcher opens normally.
- No runtime regression from the controller move.
- Thread shutdown is clean on exit.

- [ ] **Step 6: Commit the bootstrap update**

```powershell
git add cpp/src/main.cpp cpp/CMakeLists.txt
git commit -m "refactor: bootstrap launcher app in main"
```

## Validation Checklist

- `LauncherApp` owns update lifecycle and snapshot state.
- `ui.cpp` only renders and calls controller actions.
- `main.cpp` owns top-level bootstrap and teardown order.
- Build still succeeds with `cmake -S . -B build` and `cmake --build build --target LauncherJX`.
- Manual run still opens the launcher, supports `UPDATE`, and exits cleanly.
