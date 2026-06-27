#include "launcher_app.h"

#include <windows.h>
#include <chrono>
#include <filesystem>
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

    const std::wstring version_path = exe_dir_ + L"\\version.json";
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
    // 1. Tạo thư mục tạm và tải version.json từ Server
    launcher::update::UpdateSnapshot download_manifest_snapshot;
    download_manifest_snapshot.progress = 0.0f;
    download_manifest_snapshot.phase = launcher::update::UpdatePhase::Checking;
    download_manifest_snapshot.message = "Dang tai cau hinh cap nhat tu server...";
    SetSnapshot(download_manifest_snapshot);

    const std::wstring temp_version_path = exe_dir_ + L"\\tmp\\version.json";
    const std::wstring remote_version_url = launcher::update::kManifestUrl;

    if (!launcher::update::DownloadFile(remote_version_url, temp_version_path, running_, nullptr)) {
        launcher::update::UpdateSnapshot error_snapshot;
        error_snapshot.phase = launcher::update::UpdatePhase::Error;
        error_snapshot.message = "Khong the tai phien ban moi tu server. (Error: " + std::to_string(GetLastError()) + ")";
        SetSnapshot(error_snapshot);
        return;
    }

    // 2. Đọc và phân tích file version.json vừa tải
    const std::string json_content = [&] {
        std::ifstream file(temp_version_path, std::ios::binary);
        if (!file.is_open()) {
            return std::string{};
        }
        return std::string(std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>());
    }();

    if (json_content.empty()) {
        launcher::update::UpdateSnapshot error_snapshot;
        error_snapshot.phase = launcher::update::UpdatePhase::Error;
        error_snapshot.message = "Loi doc version.json tu server";
        SetSnapshot(error_snapshot);
        return;
    }

    launcher::update::ManifestSource source;
    source.path = temp_version_path;
    source.content = json_content;

    launcher::update::Manifest manifest;
    std::string error;
    if (!launcher::update::ParseManifest(source, &manifest, &error)) {
        launcher::update::UpdateSnapshot error_snapshot;
        error_snapshot.phase = launcher::update::UpdatePhase::Error;
        error_snapshot.message = "Loi phan tich manifest: " + error;
        SetSnapshot(error_snapshot);
        return;
    }

    // 3. Kiểm tra các file cần cập nhật
    launcher::update::UpdateSnapshot checking_snapshot;
    checking_snapshot.progress = 0.0f;
    checking_snapshot.phase = launcher::update::UpdatePhase::Checking;
    checking_snapshot.message = "Dang kiem tra cac file local...";
    SetSnapshot(checking_snapshot);

    const auto files_to_update = launcher::update::CollectFilesToUpdate(exe_dir_, manifest);
    if (files_to_update.empty()) {
        // Đồng bộ file version.json kể cả khi không cần tải file nào khác
        try {
            std::filesystem::path dest_ver = std::filesystem::path(exe_dir_) / L"version.json";
            std::filesystem::create_directories(dest_ver.parent_path());
            std::filesystem::copy_file(temp_version_path, dest_ver, std::filesystem::copy_options::overwrite_existing);
            std::filesystem::remove_all(std::filesystem::path(exe_dir_) / L"tmp");
        } catch (...) {}

        version_string_ = manifest.version;

        launcher::update::UpdateSnapshot done_snapshot;
        done_snapshot.progress = 1.0f;
        done_snapshot.phase = launcher::update::UpdatePhase::Done;
        done_snapshot.message = "Game da o phien ban moi nhat!";
        SetSnapshot(done_snapshot);
        return;
    }

    // 4. Tải các file cập nhật về tmp
    launcher::update::UpdateSnapshot downloading_snapshot;
    downloading_snapshot.progress = 0.0f;
    downloading_snapshot.phase = launcher::update::UpdatePhase::Downloading;
    downloading_snapshot.message = "Dang tai ban cap nhat...";
    SetSnapshot(downloading_snapshot);

    std::wstring wversion = launcher::update::Utf8ToWstring(manifest.version);
    for (size_t idx = 0; idx < files_to_update.size(); ++idx) {
        if (!running_) {
            break;
        }

        const auto& file = files_to_update[idx];
        std::wstring wname = launcher::update::Utf8ToWstring(file.name);
        std::wstring file_url = launcher::update::kServerRawPrefix + wversion + L"/patch/" + wname;
        std::wstring temp_file_path = (std::filesystem::path(exe_dir_) / L"tmp" / wname).wstring();

        // Callback cập nhật tiến trình tổng
        auto progress_callback = [&](float file_progress) {
            const float progress = (static_cast<float>(idx) + file_progress) / static_cast<float>(files_to_update.size());
            launcher::update::UpdateSnapshot progress_snapshot;
            progress_snapshot.progress = progress;
            progress_snapshot.phase = launcher::update::UpdatePhase::Downloading;
            progress_snapshot.message = "Dang tai " + file.name + "...";
            SetSnapshot(progress_snapshot);
        };

        if (!launcher::update::DownloadFile(file_url, temp_file_path, running_, progress_callback)) {
            if (running_) {
                launcher::update::UpdateSnapshot error_snapshot;
                error_snapshot.phase = launcher::update::UpdatePhase::Error;
                error_snapshot.message = "Loi tai file: " + file.name + " (Error: " + std::to_string(GetLastError()) + ")";
                SetSnapshot(error_snapshot);
            }
            return;
        }
    }

    // 5. Cài đặt các file cập nhật từ tmp sang cùng cấp với Launcher
    if (running_) {
        launcher::update::UpdateSnapshot copying_snapshot;
        copying_snapshot.progress = 0.95f;
        copying_snapshot.phase = launcher::update::UpdatePhase::Downloading;
        copying_snapshot.message = "Dang cai dat ban cap nhat...";
        SetSnapshot(copying_snapshot);

        try {
            // Copy các file game
            for (const auto& file : files_to_update) {
                std::wstring wname = launcher::update::Utf8ToWstring(file.name);
                std::filesystem::path temp_path = std::filesystem::path(exe_dir_) / L"tmp" / wname;
                std::filesystem::path dest_path = std::filesystem::path(exe_dir_) / wname;

                if (dest_path.has_parent_path()) {
                    std::filesystem::create_directories(dest_path.parent_path());
                }
                std::filesystem::copy_file(temp_path, dest_path, std::filesystem::copy_options::overwrite_existing);
            }

            // Copy file version.json chính thức để lưu version mới
            std::filesystem::path temp_ver = std::filesystem::path(exe_dir_) / L"tmp" / L"version.json";
            std::filesystem::path dest_ver = std::filesystem::path(exe_dir_) / L"version.json";
            std::filesystem::copy_file(temp_ver, dest_ver, std::filesystem::copy_options::overwrite_existing);

            // Xóa thư mục tạm
            std::filesystem::remove_all(std::filesystem::path(exe_dir_) / L"tmp");

            // Lưu version vào bộ nhớ
            version_string_ = manifest.version;

            launcher::update::UpdateSnapshot done_snapshot;
            done_snapshot.progress = 1.0f;
            done_snapshot.phase = launcher::update::UpdatePhase::Done;
            done_snapshot.message = "Cap nhat hoan tat! He thong da san sang.";
            SetSnapshot(done_snapshot);
        } catch (const std::filesystem::filesystem_error& ex) {
            launcher::update::UpdateSnapshot error_snapshot;
            error_snapshot.phase = launcher::update::UpdatePhase::Error;
            error_snapshot.message = std::string("Loi cai dat: ") + ex.what();
            SetSnapshot(error_snapshot);
        }
    }
}

void LauncherApp::SetSnapshot(const launcher::update::UpdateSnapshot& snapshot) {
    std::lock_guard<std::mutex> lock(snapshot_mutex_);
    snapshot_ = snapshot;
}
