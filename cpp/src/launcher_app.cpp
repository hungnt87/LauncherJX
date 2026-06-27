#include "launcher_app.h"

#include <chrono>
#include <fstream>
#include <iterator>

LauncherApp::LauncherApp() = default;

LauncherApp::~LauncherApp() {
    Shutdown();
}

void LauncherApp::Initialize(const std::wstring& exe_dir) {
    exe_dir_ = exe_dir;
    version_string_.clear();
    running_ = true;

    const std::wstring version_path = exe_dir_ + L"\\launcher_res\\version.json";
    const std::string json_content = [&] {
        std::ifstream file(version_path, std::ios::binary);
        if (!file.is_open()) {
            return std::string{};
        }

        return std::string(std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>());
    }();

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
    const std::string json_content = [&] {
        std::ifstream file(version_path, std::ios::binary);
        if (!file.is_open()) {
            return std::string{};
        }

        return std::string(std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>());
    }();

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
            launcher::update::UpdateSnapshot progress_snapshot;
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
