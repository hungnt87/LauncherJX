# CMake Build Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Làm gọn và rõ build graph của `LauncherJX` trước khi tách kiến trúc C++, giữ nguyên runtime behavior và asset staging.

**Architecture:** Root CMake chỉ điều phối subdirectory. `common/` tiếp tục là helper library dùng chung. `cpp/` được tổ chức lại thành các target rõ trách nhiệm: ImGui object library, launcher executable, và resource staging tách thành một khối riêng để build graph dễ đọc hơn.

**Tech Stack:** CMake 3.20+, C++17, Win32, Dear ImGui, DirectX 11, GDI+, WinCrypt, `cmake --build`

## Global Constraints

- Giữ root `CMakeLists.txt` đơn giản, chỉ điều phối các subdirectory.
- Làm rõ vai trò của `common/` và `cpp/`.
- Tách target theo trách nhiệm để tránh một executable target ôm toàn bộ nguồn và dependency.
- Giữ asset copy sau build, nhưng gom vào một điểm dễ hiểu.
- Không thay đổi UI, update flow, hay logic runtime trong pha này.
- Không tách tiếp `ui.cpp` / `update.cpp` ở pha này ngoài những thay đổi bắt buộc để build graph sạch hơn.
- Build vẫn tạo ra đúng executable như hiện tại.
- Asset copy vẫn hoạt động.
- Không có thay đổi behavior người dùng có thể thấy.

---

### Task 1: Rewire `cpp/CMakeLists.txt` into clean target boundaries

**Files:**
- Modify: `cpp/CMakeLists.txt`

**Interfaces:**
- Consumes: existing `common_lib` target from `common/CMakeLists.txt`, current launcher sources in `cpp/src/*.cpp`, current resources in `cpp/resources/*`.
- Produces: a single launcher executable target with one clear source ownership path, one ImGui object library, one resource staging block, and no duplicated consumption of the ImGui object library.

- [ ] **Step 1: Inspect the current build graph and confirm the duplication point**

Run:

```powershell
cmake -S . -B build
cmake --build build --target LauncherJX
```

Expected:

- Configure succeeds.
- The existing target graph builds from the current `cpp/CMakeLists.txt`.
- This establishes the baseline before the refactor.

- [ ] **Step 2: Replace the current `cpp/CMakeLists.txt` layout with one responsibility per block**

Use this structure as the target end state:

```cmake
cmake_minimum_required(VERSION 3.20)

project(LauncherJX_cpp LANGUAGES CXX)

include(FetchContent)

FetchContent_Declare(
  imgui
  GIT_REPOSITORY https://github.com/ocornut/imgui.git
  GIT_TAG        v1.90.8
)

FetchContent_MakeAvailable(imgui)

set(IMGUI_DIR ${imgui_SOURCE_DIR})
set(IMGUI_BACKENDS_DIR ${IMGUI_DIR}/backends)

add_library(launcher_resources INTERFACE)
target_include_directories(launcher_resources INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/include)

add_library(imgui_objects OBJECT)
target_sources(imgui_objects
    PRIVATE
        ${IMGUI_DIR}/imgui.cpp
        ${IMGUI_DIR}/imgui_draw.cpp
        ${IMGUI_DIR}/imgui_widgets.cpp
        ${IMGUI_DIR}/imgui_tables.cpp
        ${IMGUI_BACKENDS_DIR}/imgui_impl_win32.cpp
        ${IMGUI_BACKENDS_DIR}/imgui_impl_dx11.cpp
)
target_include_directories(imgui_objects
    PUBLIC
        ${IMGUI_DIR}
        ${IMGUI_BACKENDS_DIR}
)

add_executable(LauncherJX WIN32)
target_sources(LauncherJX
    PRIVATE
        src/main.cpp
        src/ui.cpp
        src/update.cpp
        resources/app.rc
        $<TARGET_OBJECTS:imgui_objects>
)

target_link_libraries(LauncherJX
    PRIVATE
        launcher_resources
        common_lib
        comctl32
        user32
        gdi32
        gdiplus
        d3d11
        d3dcompiler
        advapi32
)

target_include_directories(LauncherJX
    PRIVATE
        ${IMGUI_DIR}
        ${IMGUI_BACKENDS_DIR}
)

target_link_options(LauncherJX PRIVATE "/MANIFEST:NO")
target_compile_options(LauncherJX PRIVATE "/utf-8")
target_compile_definitions(LauncherJX PRIVATE UNICODE _UNICODE)

set(LAUNCHER_RESOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/resources/wuxia_banner.png
    ${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon.png
    ${CMAKE_CURRENT_SOURCE_DIR}/resources/version.json
    ${CMAKE_CURRENT_SOURCE_DIR}/resources/data.txt
)

add_custom_command(TARGET LauncherJX POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_FILE_DIR:LauncherJX>/launcher_res
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${LAUNCHER_RESOURCES}
            $<TARGET_FILE_DIR:LauncherJX>/launcher_res
    VERBATIM
)
```

Implementation rules:

- Keep `imgui_objects` as the only owner of ImGui source compilation.
- Consume `imgui_objects` only through `$<TARGET_OBJECTS:imgui_objects>` in `LauncherJX`.
- Remove `imgui_objects` from `target_link_libraries(LauncherJX ...)` to avoid double-consumption and make ownership obvious.
- Keep `launcher_resources` as an interface target only for include paths.
- Keep the resource copy step at the end of the file so it stays close to the launcher executable definition.

- [ ] **Step 3: Reconfigure and rebuild the launcher**

Run:

```powershell
cmake -S . -B build
cmake --build build --target LauncherJX
```

Expected:

- Configure succeeds with the new target layout.
- `LauncherJX` links successfully.
- `imgui_objects` is compiled once and only once.
- Resource staging still copies `cpp/resources/*` to `build/bin/launcher_res`.

- [ ] **Step 4: Verify the built executable still starts**

Run:

```powershell
.\build\bin\LauncherJX.exe
```

Expected:

- The launcher opens normally.
- No runtime behavior changes are introduced by the CMake refactor.
- The assets in `launcher_res` still load the same way as before.

- [ ] **Step 5: Commit the build refactor**

```powershell
git add cpp/CMakeLists.txt
git commit -m "build(cpp): simplify launcher target layout"
```

### Task 2: Validate root and shared library boundaries stay untouched

**Files:**
- Review only: `CMakeLists.txt`
- Review only: `common/CMakeLists.txt`
- Review only: `common/include/common.h`
- Review only: `common/src/common.cpp`

**Interfaces:**
- Consumes: the existing root project layout and `common_lib` target.
- Produces: confirmation that the build refactor did not require any root-level or shared-library behavior change.

- [ ] **Step 1: Confirm the root CMake remains a simple dispatcher**

Run:

```powershell
Get-Content .\CMakeLists.txt
```

Expected:

- Root CMake still only defines the project, C++ standard, runtime output directory, and `add_subdirectory(common)` / `add_subdirectory(cpp)`.
- No launcher-specific build logic leaks into the root file.

- [ ] **Step 2: Confirm `common_lib` remains a small shared helper target**

Run:

```powershell
Get-Content .\common\CMakeLists.txt
Get-Content .\common\include\common.h
Get-Content .\common\src\common.cpp
```

Expected:

- `common_lib` stays a static helper library.
- No new launcher-specific responsibilities are moved into `common`.
- The UTF conversion helpers remain the only shared utilities in this phase.

- [ ] **Step 3: Record the boundary decision**

Document in the commit message or PR notes that the build refactor intentionally does not move any C++ runtime logic yet.

Expected:

- The next phase can safely focus on tách kiến trúc C++ mà không phải mở lại scope build.

## Validation Checklist

- `cmake -S . -B build` succeeds.
- `cmake --build build --target LauncherJX` succeeds.
- `LauncherJX.exe` starts after the refactor.
- `build/bin/launcher_res` still receives the same assets.
- `cpp/CMakeLists.txt` reads as clearly separated target blocks.
- Root CMake and `common/` remain unchanged in behavior.
