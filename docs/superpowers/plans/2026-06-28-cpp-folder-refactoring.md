# C++ Folder Refactoring Implementation Plan

> **For agentic workers:** Use `superpowers:executing-plans` or the project planning workflow to carry this out step by step. Do not commit until the full refactor is green.

**Goal:** Move the C++ source tree under `src/`, rename `cpp/` to `src/launcher/`, and keep the behavior of `LauncherJX.exe`, `updater.exe`, and the tests unchanged.

**Architecture**
- Move `common/`, `cpp/`, and `updater/` under a new top-level `src/` directory.
- Rename `cpp/` to `src/launcher/`.
- Add a thin `src/CMakeLists.txt` that becomes the single entrypoint for the three C++ submodules.
- Update include paths that still point at the old root layout.

**Global constraints**
- CMake minimum version stays `3.20`.
- No behavior change in the launcher, updater, or test executables.
- Use one clean build tree for verification so stale cache entries do not hide path bugs.
- Do not make intermediate commits. Commit once, after build and test verification pass.

---

### Task 1: Preflight the current layout and confirm the blast radius

**Files**
- [CMakeLists.txt](file:///d:/1.DEV/2026/LauncherJX/CMakeLists.txt)
- [common/CMakeLists.txt](file:///d:/1.DEV/2026/LauncherJX/common/CMakeLists.txt)
- [cpp/CMakeLists.txt](file:///d:/1.DEV/2026/LauncherJX/cpp/CMakeLists.txt)
- [updater/CMakeLists.txt](file:///d:/1.DEV/2026/LauncherJX/updater/CMakeLists.txt)

1. Scan the repo for hardcoded `common/`, `cpp/`, and `updater/` paths outside the directories that are about to move.
2. Confirm which CMake files must be updated after the move.
3. Pick a fresh build directory for verification, for example `build-refactor`, instead of reusing `build`.

**Exit criteria**
- The refactor surface is known before any files move.
- No stale path assumptions remain unaccounted for.

---

### Task 2: Move the source tree in one transaction

**Files**
- Move `common/` -> `src/common/`
- Move `cpp/` -> `src/launcher/`
- Move `updater/` -> `src/updater/`

1. Move `common/` into `src/common/`.
2. Move and rename `cpp/` to `src/launcher/`.
3. Move `updater/` into `src/updater/`.
4. Verify git sees the changes as renames/moves and not accidental deletes.

**Exit criteria**
- The tree matches the new layout.
- All source files are still present in the expected places.

---

### Task 3: Rewire CMake to the new root layout

**Files**
- [CMakeLists.txt](file:///d:/1.DEV/2026/LauncherJX/CMakeLists.txt)
- [src/CMakeLists.txt](file:///d:/1.DEV/2026/LauncherJX/src/CMakeLists.txt)
- [src/updater/CMakeLists.txt](file:///d:/1.DEV/2026/LauncherJX/src/updater/CMakeLists.txt)

1. Change the root `CMakeLists.txt` to only `add_subdirectory(src)`.
2. Create `src/CMakeLists.txt` with `add_subdirectory(common)`, `add_subdirectory(launcher)`, and `add_subdirectory(updater)`.
3. Update `src/updater/CMakeLists.txt` so `common` include paths point to `${PROJECT_SOURCE_DIR}/src/common/include`.
4. Re-scan the CMake files for stale references to the old root folders.

**Exit criteria**
- Configure succeeds from the `src` entrypoint.
- No CMake file still assumes `common/`, `cpp/`, or `updater/` live at the repository root.

---

### Task 4: Build and test on a clean tree

**Steps**
1. Configure from scratch with a fresh build tree: `cmake -S . -B build-refactor`.
2. Build Release: `cmake --build build-refactor --config Release`.
3. Run the update-related tests: `build-refactor/bin/Release/update_tests.exe` and `build-refactor/bin/Release/updater_tests.exe`.
4. Run the launcher smoke check: `build-refactor/bin/Release/LauncherJX.exe`.
5. Verify `updater.exe` explicitly:
   - Confirm `build-refactor/bin/Release/updater.exe` is produced.
   - Launch it once with a disposable, valid argument set and a short-lived dummy launcher PID so the binary is exercised end to end.
   - If the executable shows an interactive error dialog in this environment, record the exact exit code and dialog text so the behavior is still verified, not guessed.

**Exit criteria**
- Configure, build, and both test executables pass.
- `LauncherJX.exe` starts normally.
- `updater.exe` is proven to start and handle its startup path without a crash.

---

### Task 5: Finalize and commit once

**Steps**
1. Review `git status` and confirm only the intended refactor files changed.
2. Run a final sanity scan for stale old-path references.
3. Commit the whole refactor in one message after verification passes.

**Exit criteria**
- The refactor lands as one coherent commit.
- No intermediate broken-state commits remain in the history for this task.
