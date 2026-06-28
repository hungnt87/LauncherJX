#include "launcher_app.h"
#include "update.h"
#include "common.h"
#include "ui.h"

#include <windows.h>
#include <wininet.h>
#include <chrono>
#include <ctime>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <vector>

LauncherApp::LauncherApp() = default;

LauncherApp::~LauncherApp() {
    Shutdown();
}

void LauncherApp::Initialize(const std::wstring& exe_dir) {
    exe_dir_ = exe_dir;
    version_string_.clear();
    running_ = true;
    has_update_ = false;

    const std::wstring version_path = exe_dir_ + L"\\version.json";
    const std::string json_content = [&] {
        std::ifstream file(version_path, std::ios::binary);
        if (!file.is_open()) {
            return std::string{};
        }

        return std::string(std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>());
    }();

    if (json_content.empty()) {
        version_string_ = "v0.0.0";
    } else {
        launcher::update::ManifestSource source;
        source.path = version_path;
        source.content = json_content;

        launcher::update::Manifest manifest;
        std::string error;
        if (!launcher::update::ParseManifest(source, &manifest, &error)) {
            version_string_ = "v0.0.0";
        } else {
            version_string_ = manifest.version;
        }
    }

    launcher::update::UpdateSnapshot ready_snapshot;
    ready_snapshot.progress = 0.0f;
    ready_snapshot.phase = launcher::update::UpdatePhase::Checking;
    ready_snapshot.message = "Đang kiểm tra bản cập nhật từ máy chủ...";
    SetSnapshot(ready_snapshot);

    if (check_thread_.joinable()) {
        check_thread_.join();
    }
    changelog_content_ = "Đang tải thông tin cập nhật từ GitHub...";
    LoadResolutionSettings();
    LoadJx1ModSettings();
    check_thread_ = std::thread(&LauncherApp::RunCheckWorker, this);
}

void LauncherApp::StartUpdate() {
    if (!has_update_) {
        return;
    }
    if (update_thread_.joinable()) {
        update_thread_.join();
    }

    launcher::update::UpdateSnapshot start_snapshot;
    start_snapshot.progress = 0.0f;
    start_snapshot.phase = launcher::update::UpdatePhase::Checking;
    start_snapshot.message = "Đang kiểm tra các tệp cần cập nhật...";
    SetSnapshot(start_snapshot);

    update_thread_ = std::thread(&LauncherApp::RunUpdateWorker, this);
}

void LauncherApp::Shutdown() noexcept {
    running_ = false;
    if (check_thread_.joinable()) {
        check_thread_.join();
    }
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

const std::string& LauncherApp::ChangelogContent() const noexcept {
    return changelog_content_;
}

void LauncherApp::LoadChangelog() {
    const std::wstring temp_changelog_path = exe_dir_ + L"\\tmp\\CHANGELOG.md";
    // Thêm timestamp để phá cache CDN của GitHub Raw, đảm bảo tải thông tin mới nhất lập tức
    std::wstring remote_changelog_url = L"https://raw.githubusercontent.com/hungnt87/LauncherJX/main/CHANGELOG.md?t=" + std::to_wstring(std::time(nullptr));
    
    if (launcher::update::DownloadFile(nullptr, remote_changelog_url, temp_changelog_path, running_, nullptr)) {
        std::ifstream file(temp_changelog_path, std::ios::binary);
        if (file.is_open()) {
            changelog_content_ = std::string(std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>());
            if (changelog_content_.empty()) {
                changelog_content_ = "Thông tin cập nhật trống.";
            }
            file.close();
        }
        try {
            std::filesystem::remove(temp_changelog_path);
        } catch (...) {}
    } else {
        changelog_content_ = "Không thể tải thông tin cập nhật từ GitHub. Vui lòng kiểm tra kết nối.";
    }
}

void LauncherApp::RunCheckWorker() {
    LoadChangelog();
    const std::wstring temp_version_path = exe_dir_ + L"\\tmp\\version.json";
    const std::wstring remote_version_url = launcher::update::kManifestUrl;

    if (!launcher::update::DownloadFile(nullptr, remote_version_url, temp_version_path, running_, nullptr)) {




        launcher::update::UpdateSnapshot done_snapshot;
        done_snapshot.progress = 1.0f;
        done_snapshot.phase = launcher::update::UpdatePhase::Done;
        done_snapshot.message = "Không thể kết nối đến máy chủ để kiểm tra bản cập nhật. Sử dụng phiên bản hiện tại (" + version_string_ + ").";
        SetSnapshot(done_snapshot);
        has_update_ = false;
        return;
    }

    const std::string json_content = [&] {
        std::ifstream file(temp_version_path, std::ios::binary);
        if (!file.is_open()) {
            return std::string{};
        }
        return std::string(std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>());
    }();

    if (json_content.empty()) {
        launcher::update::UpdateSnapshot done_snapshot;
        done_snapshot.progress = 1.0f;
        done_snapshot.phase = launcher::update::UpdatePhase::Done;
        done_snapshot.message = "Lỗi đọc thông tin phiên bản máy chủ. Sử dụng phiên bản hiện tại (" + version_string_ + ").";
        SetSnapshot(done_snapshot);
        has_update_ = false;
        return;
    }

    launcher::update::ManifestSource source;
    source.path = temp_version_path;
    source.content = json_content;

    launcher::update::Manifest manifest;
    std::string error;
    if (!launcher::update::ParseManifest(source, &manifest, &error)) {
        launcher::update::UpdateSnapshot done_snapshot;
        done_snapshot.progress = 1.0f;
        done_snapshot.phase = launcher::update::UpdatePhase::Done;
        done_snapshot.message = "Lỗi phân tích thông tin phiên bản máy chủ. Sử dụng phiên bản hiện tại (" + version_string_ + ").";
        SetSnapshot(done_snapshot);
        has_update_ = false;
        return;
    }

    // Tự động kiểm tra hash và sửa cấu trúc các file .ini đặc biệt khi khởi động
    if (launcher::update::CheckAndRepairIniFiles(exe_dir_, manifest, running_)) {
        LoadResolutionSettings();
        LoadJx1ModSettings();
    }

    if (ShouldSelfUpdate(manifest)) {
        server_manifest_ = manifest;
        has_update_ = true;

        launcher::update::UpdateSnapshot self_update_snapshot;
        self_update_snapshot.progress = 0.0f;
        self_update_snapshot.phase = launcher::update::UpdatePhase::SelfUpdating;
        self_update_snapshot.message = "Phát hiện phiên bản launcher mới. Đang tự động cập nhật...";
        SetSnapshot(self_update_snapshot);

        RunSelfUpdateWorker();
        return;
    }

    int comp = launcher::update::CompareSemanticVersion(manifest.version, version_string_);
    if (comp > 0) {
        server_manifest_ = manifest;
        has_update_ = true;

        launcher::update::UpdateSnapshot ready_snapshot;
        ready_snapshot.progress = 0.0f;
        ready_snapshot.phase = launcher::update::UpdatePhase::Idle;
        ready_snapshot.message = "Có bản cập nhật mới: " + manifest.version + " (Hiện tại: " + version_string_ + "). Bấm CẬP NHẬT để cập nhật.";
        SetSnapshot(ready_snapshot);
    } else {

        // Kể cả khi phiên bản bằng hoặc nhỏ hơn server, vẫn quét kiểm tra tính toàn vẹn của các file game
        const auto files_to_update = launcher::update::CollectFilesToUpdate(exe_dir_, manifest);
        if (!files_to_update.empty()) {
            server_manifest_ = manifest;
            has_update_ = true;

            // Lấy danh sách ví dụ các file bị lỗi (tối đa 3 file)
            std::string examples;
            for (size_t i = 0; i < (std::min)(size_t(3), files_to_update.size()); ++i) {
                if (i > 0) {
                    examples += ", ";
                }
                examples += files_to_update[i].name;
            }

            launcher::update::UpdateSnapshot integrity_snapshot;
            integrity_snapshot.progress = 0.0f;
            integrity_snapshot.phase = launcher::update::UpdatePhase::Idle;
            integrity_snapshot.message = "Phát hiện " + std::to_string(files_to_update.size()) + 
                                         " tệp game bị lỗi/thiếu (Ví dụ: " + examples + "). Bấm CẬP NHẬT để sửa lỗi game.";
            SetSnapshot(integrity_snapshot);
        } else {
            has_update_ = false;
            try {
                std::filesystem::remove_all(std::filesystem::path(exe_dir_) / L"tmp");
            } catch (...) {}

            launcher::update::UpdateSnapshot done_snapshot;
            done_snapshot.progress = 1.0f;
            done_snapshot.phase = launcher::update::UpdatePhase::Done;
            done_snapshot.message = "Game đã ở phiên bản mới nhất (" + version_string_ + ")! (Đã quét " + std::to_string(manifest.files.size()) + " tệp toàn vẹn)";
            SetSnapshot(done_snapshot);
        }
    }
}

void LauncherApp::RunUpdateWorker() {
    std::string check_path_utf8 = [&] {
        std::string res;
        int size_needed = WideCharToMultiByte(CP_UTF8, 0, exe_dir_.c_str(), (int)exe_dir_.size(), nullptr, 0, nullptr, nullptr);
        res.resize(size_needed);
        WideCharToMultiByte(CP_UTF8, 0, exe_dir_.c_str(), (int)exe_dir_.size(), &res[0], size_needed, nullptr, nullptr);
        return res;
    }();

    launcher::update::UpdateSnapshot checking_snapshot;
    checking_snapshot.progress = 0.0f;
    checking_snapshot.phase = launcher::update::UpdatePhase::Checking;
    checking_snapshot.message = "Đang kiểm tra các tệp tại: " + check_path_utf8;
    SetSnapshot(checking_snapshot);

    const auto files_to_update = launcher::update::CollectFilesToUpdate(exe_dir_, server_manifest_);
    if (files_to_update.empty()) {
        try {
            std::filesystem::path dest_ver = std::filesystem::path(exe_dir_) / L"version.json";
            std::filesystem::create_directories(dest_ver.parent_path());
            std::filesystem::path temp_version_path = std::filesystem::path(exe_dir_) / L"tmp" / L"version.json";
            std::filesystem::copy_file(temp_version_path, dest_ver, std::filesystem::copy_options::overwrite_existing);
            std::filesystem::remove_all(std::filesystem::path(exe_dir_) / L"tmp");
        } catch (...) {}

        version_string_ = server_manifest_.version;
        has_update_ = false;

        launcher::update::UpdateSnapshot done_snapshot;
        done_snapshot.progress = 1.0f;
        done_snapshot.phase = launcher::update::UpdatePhase::Done;
        done_snapshot.message = "Game đã ở phiên bản mới nhất (" + version_string_ + ")! (Đã quét " + std::to_string(server_manifest_.files.size()) + " tệp)";
        SetSnapshot(done_snapshot);
        return;
    }

    // Phân loại các file zip cần tải và file lẻ cần tải trực tiếp
    std::vector<std::string> zips_to_download;
    std::vector<launcher::update::FileEntry> direct_files_to_download;

    for (const auto& file : files_to_update) {
        if (!file.zip.empty()) {
            if (std::find(zips_to_download.begin(), zips_to_download.end(), file.zip) == zips_to_download.end()) {
                zips_to_download.push_back(file.zip);
            }
        } else {
            direct_files_to_download.push_back(file);
        }
    }

    struct DownloadTask {
        bool is_zip;
        std::string name;
        launcher::update::FileEntry file_entry;
    };

    std::vector<DownloadTask> download_tasks;
    for (const auto& zip_name : zips_to_download) {
        download_tasks.push_back(DownloadTask{true, zip_name, {}});
    }
    for (const auto& file : direct_files_to_download) {
        download_tasks.push_back(DownloadTask{false, file.name, file});
    }

    if (download_tasks.empty()) {
        try {
            std::filesystem::path dest_ver = std::filesystem::path(exe_dir_) / L"version.json";
            std::filesystem::create_directories(dest_ver.parent_path());
            std::filesystem::path temp_version_path = std::filesystem::path(exe_dir_) / L"tmp" / L"version.json";
            std::filesystem::copy_file(temp_version_path, dest_ver, std::filesystem::copy_options::overwrite_existing);
            std::filesystem::remove_all(std::filesystem::path(exe_dir_) / L"tmp");
        } catch (...) {}

        version_string_ = server_manifest_.version;
        has_update_ = false;

        launcher::update::UpdateSnapshot done_snapshot;
        done_snapshot.progress = 1.0f;
        done_snapshot.phase = launcher::update::UpdatePhase::Done;
        done_snapshot.message = "Game đã ở phiên bản mới nhất (" + version_string_ + ")! (Đã quét " + std::to_string(server_manifest_.files.size()) + " tệp)";
        SetSnapshot(done_snapshot);
        return;
    }

    launcher::update::UpdateSnapshot downloading_snapshot;
    downloading_snapshot.progress = 0.0f;
    downloading_snapshot.phase = launcher::update::UpdatePhase::Downloading;
    downloading_snapshot.message = "Đang tải " + std::to_string(zips_to_download.size()) + " tệp zip và " + std::to_string(direct_files_to_download.size()) + " tệp lẻ...";
    SetSnapshot(downloading_snapshot);

    std::wstring wversion = launcher::update::Utf8ToWstring(server_manifest_.version);

    // Tải đa luồng song song
    const size_t kNumThreads = 4;
    std::vector<std::thread> download_threads;
    std::atomic<size_t> next_task_idx{0};
    std::atomic<size_t> tasks_finished{0};
    std::atomic<bool> download_failed{false};
    std::string error_message;
    std::mutex error_mutex;

    for (size_t t = 0; t < (std::min)(kNumThreads, download_tasks.size()); ++t) {
        download_threads.emplace_back([&]() {
            HINTERNET hInternet = InternetOpenW(L"LauncherJX/1.0", INTERNET_OPEN_TYPE_DIRECT, nullptr, nullptr, 0);
            if (!hInternet) {
                download_failed = true;
                return;
            }

            while (running_ && !download_failed) {
                size_t idx = next_task_idx.fetch_add(1);
                if (idx >= download_tasks.size()) {
                    break;
                }

                const auto& task = download_tasks[idx];
                std::wstring wname = launcher::update::Utf8ToWstring(task.name);
                std::wstring file_url;
                std::wstring temp_file_path;

                if (task.is_zip) {
                    file_url = L"https://github.com/hungnt87/LauncherJX/releases/download/" + wversion + L"/" + wname;
                    temp_file_path = (std::filesystem::path(exe_dir_) / L"tmp" / wname).wstring();
                } else {
                    std::string encoded_name = launcher::update::UrlEncode(task.name);
                    std::wstring wencoded_name = launcher::update::Utf8ToWstring(encoded_name);
                    file_url = launcher::update::kServerRawPrefix + wversion + L"/patch/" + wencoded_name;
                    temp_file_path = (std::filesystem::path(exe_dir_) / L"tmp" / wname).wstring();
                }

                if (!launcher::update::DownloadFile(hInternet, file_url, temp_file_path, running_, nullptr)) {
                    if (running_) {
                        std::lock_guard<std::mutex> lock(error_mutex);
                        download_failed = true;
                        error_message = "Lỗi tải tệp: " + task.name + " (Lỗi: " + std::to_string(GetLastError()) + ")";
                    }
                    break;
                }

                size_t finished = tasks_finished.fetch_add(1) + 1;

                float progress = static_cast<float>(finished) / download_tasks.size();
                launcher::update::UpdateSnapshot progress_snapshot;
                progress_snapshot.progress = progress;
                progress_snapshot.phase = launcher::update::UpdatePhase::Downloading;
                progress_snapshot.message = "Đang tải: " + std::to_string(finished) + "/" + std::to_string(download_tasks.size()) + " gói cập nhật...";
                SetSnapshot(progress_snapshot);
            }

            InternetCloseHandle(hInternet);
        });
    }

    for (auto& thread : download_threads) {
        if (thread.joinable()) {
            thread.join();
        }
    }

    if (download_failed) {
        launcher::update::UpdateSnapshot error_snapshot;
        error_snapshot.phase = launcher::update::UpdatePhase::Error;
        error_snapshot.message = error_message;
        SetSnapshot(error_snapshot);
        return;
    }

    if (running_) {
        launcher::update::UpdateSnapshot installing_snapshot;
        installing_snapshot.progress = 0.9f;
        installing_snapshot.phase = launcher::update::UpdatePhase::Downloading;
        installing_snapshot.message = "Đang giải nén và cài đặt bản cập nhật...";
        SetSnapshot(installing_snapshot);

        try {
            // Sao lưu cấu hình của người chơi nếu có trước khi giải nén zip để tránh bị ghi đè
            std::wstring backup_config = (std::filesystem::path(exe_dir_) / L"tmp" / L"backup_config.ini").wstring();
            std::wstring backup_jx1mod = (std::filesystem::path(exe_dir_) / L"tmp" / L"backup_jx1mod.ini").wstring();
            std::wstring backup_package = (std::filesystem::path(exe_dir_) / L"tmp" / L"backup_package.ini").wstring();

            bool has_backup_config = false;
            bool has_backup_jx1mod = false;
            bool has_backup_package = false;

            std::wstring local_config = (std::filesystem::path(exe_dir_) / L"config.ini").wstring();
            std::wstring local_jx1mod = (std::filesystem::path(exe_dir_) / L"JX1Mod.ini").wstring();
            std::wstring local_package = (std::filesystem::path(exe_dir_) / L"package.ini").wstring();

            if (std::filesystem::exists(local_config)) {
                std::filesystem::copy_file(local_config, backup_config, std::filesystem::copy_options::overwrite_existing);
                has_backup_config = true;
            }
            if (std::filesystem::exists(local_jx1mod)) {
                std::filesystem::copy_file(local_jx1mod, backup_jx1mod, std::filesystem::copy_options::overwrite_existing);
                has_backup_jx1mod = true;
            }
            if (std::filesystem::exists(local_package)) {
                std::filesystem::copy_file(local_package, backup_package, std::filesystem::copy_options::overwrite_existing);
                has_backup_package = true;
            }

            // 1. Giải nén các gói zip ra thư mục game
            for (const auto& zip_name : zips_to_download) {
                std::wstring wzip_name = launcher::update::Utf8ToWstring(zip_name);
                std::wstring zip_path = (std::filesystem::path(exe_dir_) / L"tmp" / wzip_name).wstring();

                if (!launcher::update::UnzipFile(zip_path, exe_dir_)) {
                    throw std::runtime_error("Không thể giải nén gói: " + zip_name);
                }
            }

            // Khôi phục lại cấu hình của người chơi sau khi giải nén bằng cách Merge cấu trúc mới vào cấu hình cũ
            if (has_backup_config) {
                launcher::update::MergeIniFiles(local_config, backup_config);
                std::filesystem::copy_file(backup_config, local_config, std::filesystem::copy_options::overwrite_existing);
                try { std::filesystem::remove(backup_config); } catch (...) {}
            }
            if (has_backup_jx1mod) {
                launcher::update::MergeIniFiles(local_jx1mod, backup_jx1mod);
                std::filesystem::copy_file(backup_jx1mod, local_jx1mod, std::filesystem::copy_options::overwrite_existing);
                try { std::filesystem::remove(backup_jx1mod); } catch (...) {}
            }
            if (has_backup_package) {
                launcher::update::MergeIniFiles(local_package, backup_package);
                std::filesystem::copy_file(backup_package, local_package, std::filesystem::copy_options::overwrite_existing);
                try { std::filesystem::remove(backup_package); } catch (...) {}
            }

            // 2. Copy các file lẻ không nén (nếu có)
            for (const auto& file : direct_files_to_download) {
                std::wstring wname = launcher::update::Utf8ToWstring(file.name);
                std::filesystem::path temp_path = std::filesystem::path(exe_dir_) / L"tmp" / wname;
                std::filesystem::path dest_path = std::filesystem::path(exe_dir_) / wname;

                if (dest_path.has_parent_path()) {
                    std::filesystem::create_directories(dest_path.parent_path());
                }
                std::filesystem::copy_file(temp_path, dest_path, std::filesystem::copy_options::overwrite_existing);
                // Bảo toàn ngày giờ của file lẻ
                common::CopyFileTime(temp_path.wstring(), dest_path.wstring());
            }

            // 3. Copy đè version.json mới
            std::filesystem::path temp_ver = std::filesystem::path(exe_dir_) / L"tmp" / L"version.json";
            std::filesystem::path dest_ver = std::filesystem::path(exe_dir_) / L"version.json";
            std::filesystem::copy_file(temp_ver, dest_ver, std::filesystem::copy_options::overwrite_existing);
            // Bảo toàn ngày giờ của tệp version.json
            common::CopyFileTime(temp_ver.wstring(), dest_ver.wstring());


            // 4. Xóa sạch thư mục tạm
            std::filesystem::remove_all(std::filesystem::path(exe_dir_) / L"tmp");

            version_string_ = server_manifest_.version;
            has_update_ = false;
            LoadChangelog();

            launcher::update::UpdateSnapshot done_snapshot;
            done_snapshot.progress = 1.0f;
            done_snapshot.phase = launcher::update::UpdatePhase::Done;
            done_snapshot.message = "Cập nhật hoàn tất! Hệ thống đã sẵn sàng.";
            SetSnapshot(done_snapshot);
        } catch (const std::exception& ex) {
            launcher::update::UpdateSnapshot error_snapshot;
            error_snapshot.phase = launcher::update::UpdatePhase::Error;
            error_snapshot.message = std::string("Lỗi cài đặt: ") + ex.what();
            SetSnapshot(error_snapshot);
        } catch (...) {
            launcher::update::UpdateSnapshot error_snapshot;
            error_snapshot.phase = launcher::update::UpdatePhase::Error;
            error_snapshot.message = "Lỗi cài đặt không xác định.";
            SetSnapshot(error_snapshot);
        }
    }
}

void LauncherApp::SetSnapshot(const launcher::update::UpdateSnapshot& snapshot) {
    std::lock_guard<std::mutex> lock(snapshot_mutex_);
    snapshot_ = snapshot;
}

int LauncherApp::GameResolution() const noexcept {
    return game_resolution_;
}

void LauncherApp::SetGameResolution(int resolution) {
    if (resolution == 800 || resolution == 1024) {
        SaveResolutionSettings(resolution);
    }
}

void LauncherApp::LoadResolutionSettings() {
    std::wstring config_path = exe_dir_ + L"\\config.ini";
    wchar_t theme_buf[32] = {0};
    GetPrivateProfileStringW(L"Client", L"Theme", L"1024", theme_buf, 32, config_path.c_str());
    
    std::wstring theme_str(theme_buf);
    if (theme_str == L"800") {
        game_resolution_ = 800;
    } else {
        game_resolution_ = 1024;
    }

    // Đọc FullScreen từ config.ini
    wchar_t fs_buf[32] = {0};
    GetPrivateProfileStringW(L"Client", L"FullScreen", L"0", fs_buf, 32, config_path.c_str());
    fullscreen_ = (std::wstring(fs_buf) == L"1");
}

void LauncherApp::SaveResolutionSettings(int resolution) {
    game_resolution_ = resolution;
    std::wstring wres_str = std::to_wstring(resolution);
    
    std::wstring config_path = exe_dir_ + L"\\config.ini";
    std::wstring package_path = exe_dir_ + L"\\package.ini";
    
    // 1. Ghi đè vào config.ini: [Client] -> Theme = 800 / 1024
    WritePrivateProfileStringW(L"Client", L"Theme", wres_str.c_str(), config_path.c_str());
    
    // 2. Ghi đè vào package.ini: [Package] -> 0 = 800.pak / 1024.pak
    std::wstring pak_val = wres_str + L".pak";
    WritePrivateProfileStringW(L"Package", L"0", pak_val.c_str(), package_path.c_str());
}

bool LauncherApp::IsFullScreen() const noexcept {
    return fullscreen_;
}

void LauncherApp::SetFullScreen(bool fullscreen) {
    SaveFullScreenSetting(fullscreen);
}

void LauncherApp::SaveFullScreenSetting(bool fullscreen) {
    fullscreen_ = fullscreen;
    std::wstring config_path = exe_dir_ + L"\\config.ini";
    WritePrivateProfileStringW(L"Client", L"FullScreen", fullscreen ? L"1" : L"0", config_path.c_str());
}

JX1ModSettings& LauncherApp::Jx1ModSettings() noexcept {
    return jx1mod_settings_;
}

void LauncherApp::WriteJx1ModKey(const std::wstring& section, const std::wstring& key, bool value) {
    std::wstring path = exe_dir_ + L"\\JX1Mod.ini";
    WritePrivateProfileStringW(section.c_str(), key.c_str(), value ? L"1" : L"0", path.c_str());
}

void LauncherApp::WriteJx1ModKey(const std::wstring& section, const std::wstring& key, int value) {
    std::wstring path = exe_dir_ + L"\\JX1Mod.ini";
    WritePrivateProfileStringW(section.c_str(), key.c_str(), std::to_wstring(value).c_str(), path.c_str());
}

void LauncherApp::LoadJx1ModSettings() {
    std::wstring path = exe_dir_ + L"\\JX1Mod.ini";
    auto readBool = [&](const wchar_t* sec, const wchar_t* key, bool def) -> bool {
        wchar_t buf[8] = {0};
        GetPrivateProfileStringW(sec, key, def ? L"1" : L"0", buf, 8, path.c_str());
        return std::wstring(buf) == L"1";
    };
    auto readInt = [&](const wchar_t* sec, const wchar_t* key, int def) -> int {
        return GetPrivateProfileIntW(sec, key, def, path.c_str());
    };
    jx1mod_settings_.trung_sinh          = readBool(L"ChucNang",          L"TrungSinh",          true);
    jx1mod_settings_.an_nu_kim_nam_thuy  = readBool(L"ChucNang",          L"AnNuKimNamThuy",     true);
    jx1mod_settings_.nam_thuy_nu_kim     = readBool(L"ChucNang",          L"NamThuyNuKim",       false);
    jx1mod_settings_.so_sanh_trang_bi    = readBool(L"ChucNang",          L"SoSanhTrangBi",      true);
    jx1mod_settings_.thong_so_trang_bi   = readBool(L"ChucNang",          L"ThongSoTrangBi",     false);
    jx1mod_settings_.hien_thi_thanh_mau  = readBool(L"ChucNang",          L"HienThiThanhMau",    true);
    jx1mod_settings_.xep_hang_tren_dau   = readBool(L"ChucNang",          L"XepHangTrenDau",     true);
    jx1mod_settings_.lien_tram           = readInt(L"ChucNang",           L"LienTram",           0);
    jx1mod_settings_.trade_info          = readBool(L"ChucNang",          L"TradeInfo",          false);
    jx1mod_settings_.thanh_mau_boss      = readBool(L"ThanhMauBoss",      L"Enabled",            false);
    jx1mod_settings_.thanh_mau_npc       = readBool(L"ThanhMauNPC",       L"Enabled",            false);
    jx1mod_settings_.f3_merge            = readBool(L"F3Merge",           L"Enabled",            false);
    jx1mod_settings_.xep_hang_f3         = readBool(L"XepHangF3",         L"Enabled",            true);
    jx1mod_settings_.thong_bao_pk        = readBool(L"ThongBaoPK",        L"Enable",             false);
    jx1mod_settings_.hieu_ung_xung_quanh = readBool(L"HieuUngXungQuanhNV",L"Enabled",            true);
    jx1mod_settings_.add_point_popup     = readBool(L"AddPointPopup",     L"Enabled",            false);
}

void LauncherApp::RunSelfUpdateWorker() {
    launcher::update::UpdateSnapshot snap;
    snap.phase = launcher::update::UpdatePhase::SelfUpdating;
    snap.progress = 0.1f;
    snap.message = "Đang chuẩn bị công cụ updater...";
    SetSnapshot(snap);

    std::wstring updater_path;
    std::string error;
    if (!EnsureUpdaterBinary(server_manifest_, &updater_path, &error)) {
        snap.phase = launcher::update::UpdatePhase::Error;
        snap.message = "Lỗi self-update: " + error;
        SetSnapshot(snap);
        return;
    }

    snap.progress = 0.3f;
    snap.message = "Đang tải LauncherJX mới...";
    SetSnapshot(snap);

    std::string launcher_hash;
    for (const auto& file : server_manifest_.files) {
        std::string name = file.name;
        std::transform(name.begin(), name.end(), name.begin(), [](unsigned char c) { return std::tolower(c); });
        if (name == "launcherjx.exe") {
            launcher_hash = file.hash;
            break;
        }
    }

    if (launcher_hash.empty()) {
        snap.phase = launcher::update::UpdatePhase::Error;
        snap.message = "Lỗi self-update: Không tìm thấy LauncherJX.exe trong manifest";
        SetSnapshot(snap);
        return;
    }

    std::wstring temp_new_launcher = exe_dir_ + L"\\tmp\\LauncherJX.exe.new";
    std::wstring wversion = common::Utf8ToWide(server_manifest_.version);
    std::wstring download_url = L"https://github.com/hungnt87/LauncherJX/releases/download/" + wversion + L"/LauncherJX.exe";

    auto progress_callback = [this](float prog) {
        launcher::update::UpdateSnapshot progress_snap = Snapshot();
        progress_snap.progress = 0.3f + prog * 0.5f;
        progress_snap.message = "Đang tải LauncherJX mới: " + std::to_string(static_cast<int>(prog * 100)) + "%...";
        SetSnapshot(progress_snap);
    };

    if (!launcher::update::DownloadFile(nullptr, download_url, temp_new_launcher, running_, progress_callback)) {
        snap.phase = launcher::update::UpdatePhase::Error;
        snap.message = "Lỗi self-update: Không thể tải LauncherJX.exe mới";
        SetSnapshot(snap);
        return;
    }

    snap.progress = 0.8f;
    snap.message = "Kiểm tra mã băm LauncherJX mới...";
    SetSnapshot(snap);

    if (!launcher::update::VerifyFileSha256(temp_new_launcher, launcher_hash)) {
        snap.phase = launcher::update::UpdatePhase::Error;
        snap.message = "Lỗi self-update: Mã băm LauncherJX.exe mới không khớp!";
        try {
            std::filesystem::remove(temp_new_launcher);
        } catch (...) {}
        SetSnapshot(snap);
        return;
    }

    snap.progress = 0.9f;
    snap.message = "Khởi chạy updater và khởi động lại launcher...";
    SetSnapshot(snap);

    if (!LaunchUpdaterAndExit(updater_path, temp_new_launcher, launcher_hash)) {
        snap.phase = launcher::update::UpdatePhase::Error;
        snap.message = "Lỗi self-update: Không thể khởi chạy " + server_manifest_.updater->name;
        SetSnapshot(snap);
        return;
    }
}

bool LauncherApp::ShouldSelfUpdate(const launcher::update::Manifest& manifest) const {
    int comp = launcher::update::CompareSemanticVersion(manifest.version, version_string_);
    return (comp > 0) && launcher::update::ManifestHasLauncherBinary(manifest);
}

bool LauncherApp::EnsureUpdaterBinary(const launcher::update::Manifest& manifest, std::wstring* updater_path, std::string* error) {
    if (!manifest.updater.has_value()) {
        if (error) *error = "Manifest missing updater metadata";
        return false;
    }
    
    std::wstring path = exe_dir_ + L"\\" + common::Utf8ToWide(manifest.updater->name);
    *updater_path = path;
    
    if (std::filesystem::exists(path) && launcher::update::VerifyFileSha256(path, manifest.updater->hash)) {
        return true;
    }
    
    std::wstring wversion = common::Utf8ToWide(manifest.version);
    std::wstring wupdater_name = common::Utf8ToWide(manifest.updater->name);
    std::wstring download_url = L"https://github.com/hungnt87/LauncherJX/releases/download/" + wversion + L"/" + wupdater_name;
    
    launcher::update::UpdateSnapshot snap = Snapshot();
    snap.phase = launcher::update::UpdatePhase::Downloading;
    snap.message = "Đang tải công cụ cập nhật (updater.exe)...";
    SetSnapshot(snap);
    
    if (!launcher::update::DownloadFile(nullptr, download_url, path, running_, nullptr)) {
        if (error) *error = "Không thể tải updater.exe";
        return false;
    }
    
    if (!launcher::update::VerifyFileSha256(path, manifest.updater->hash)) {
        if (error) *error = "Mã băm của updater.exe tải về không khớp";
        try {
            std::filesystem::remove(path);
        } catch (...) {}
        return false;
    }
    
    return true;
}

bool LauncherApp::LaunchUpdaterAndExit(const std::wstring& updater_path, const std::wstring& launcher_new_path, const std::string& expected_hash) {
    wchar_t current_exe_path[MAX_PATH];
    GetModuleFileNameW(nullptr, current_exe_path, MAX_PATH);
    
    DWORD pid = GetCurrentProcessId();
    
    std::wstring cmd = L"\"" + updater_path + L"\""
        + L" --launcher-pid " + std::to_wstring(pid)
        + L" --current \"" + current_exe_path + L"\""
        + L" --new \"" + launcher_new_path + L"\""
        + L" --expected-hash " + common::Utf8ToWide(expected_hash)
        + L" --launch \"" + current_exe_path + L"\"";
        
    STARTUPINFOW si;
    PROCESS_INFORMATION pi;
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));
    
    std::vector<wchar_t> cmd_buf(cmd.begin(), cmd.end());
    cmd_buf.push_back(L'\0');
    
    if (!CreateProcessW(nullptr, cmd_buf.data(), nullptr, nullptr, FALSE, CREATE_NO_WINDOW, nullptr, nullptr, &si, &pi)) {
        return false;
    }
    
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    
    // Đóng cửa sổ chính từ worker bằng WM_CLOSE, để luồng UI xử lý vòng lặp thoát
    HWND hWnd = GetMainWindowHandle();
    if (hWnd) {
        PostMessageW(hWnd, WM_CLOSE, 0, 0);
    } else {
        return false;
    }
    return true;
}
