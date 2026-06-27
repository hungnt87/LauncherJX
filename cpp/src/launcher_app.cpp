#include "launcher_app.h"
#include "update.h"

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
    ready_snapshot.message = "Dang kiem tra ban cap nhat tu server...";
    SetSnapshot(ready_snapshot);

    if (check_thread_.joinable()) {
        check_thread_.join();
    }
    changelog_content_ = "Dang tai thong tin cap nhat tu GitHub...";
    LoadResolutionSettings();
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
    start_snapshot.message = "Dang kiem tra cac file can cap nhat...";
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
                changelog_content_ = "Thong tin cap nhat trong.";
            }
            file.close();
        }
        try {
            std::filesystem::remove(temp_changelog_path);
        } catch (...) {}
    } else {
        changelog_content_ = "Khong the tai thong tin cap nhat tu GitHub. Vui long kiem tra ket noi.";
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
        done_snapshot.message = "Khong the ket noi den server de kiem tra ban cap nhat. Su dung phien ban hien tai (" + version_string_ + ").";
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
        done_snapshot.message = "Loi doc thong tin phien ban server. Su dung phien ban hien tai (" + version_string_ + ").";
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
        done_snapshot.message = "Loi phan tich thong tin phien ban server. Su dung phien ban hien tai (" + version_string_ + ").";
        SetSnapshot(done_snapshot);
        has_update_ = false;
        return;
    }

    int comp = launcher::update::CompareSemanticVersion(manifest.version, version_string_);
    if (comp > 0) {
        server_manifest_ = manifest;
        has_update_ = true;

        launcher::update::UpdateSnapshot ready_snapshot;
        ready_snapshot.progress = 0.0f;
        ready_snapshot.phase = launcher::update::UpdatePhase::Idle;
        ready_snapshot.message = "Co ban cap nhat moi: " + manifest.version + " (Hien tai: " + version_string_ + "). Bam UPDATE de cap nhat.";
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
            integrity_snapshot.message = "Phat hien " + std::to_string(files_to_update.size()) + 
                                         " file game bi loi/thieu (Vi du: " + examples + "). Bam UPDATE de sua loi game.";
            SetSnapshot(integrity_snapshot);
        } else {
            has_update_ = false;
            try {
                std::filesystem::remove_all(std::filesystem::path(exe_dir_) / L"tmp");
            } catch (...) {}

            launcher::update::UpdateSnapshot done_snapshot;
            done_snapshot.progress = 1.0f;
            done_snapshot.phase = launcher::update::UpdatePhase::Done;
            done_snapshot.message = "Game da o phien ban moi nhat (" + version_string_ + ")! (Da quet " + std::to_string(manifest.files.size()) + " file toan ven)";
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
    checking_snapshot.message = "Dang kiem tra cac file tai: " + check_path_utf8;
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
        done_snapshot.message = "Game da o phien ban moi nhat (" + version_string_ + ")! (Da quet " + std::to_string(server_manifest_.files.size()) + " file)";
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
        done_snapshot.message = "Game da o phien ban moi nhat (" + version_string_ + ")! (Da quet " + std::to_string(server_manifest_.files.size()) + " file)";
        SetSnapshot(done_snapshot);
        return;
    }

    launcher::update::UpdateSnapshot downloading_snapshot;
    downloading_snapshot.progress = 0.0f;
    downloading_snapshot.phase = launcher::update::UpdatePhase::Downloading;
    downloading_snapshot.message = "Dang tai " + std::to_string(zips_to_download.size()) + " file zip va " + std::to_string(direct_files_to_download.size()) + " file le...";
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
                        error_message = "Loi tai file: " + task.name + " (Error: " + std::to_string(GetLastError()) + ")";
                    }
                    break;
                }

                size_t finished = tasks_finished.fetch_add(1) + 1;

                float progress = static_cast<float>(finished) / download_tasks.size();
                launcher::update::UpdateSnapshot progress_snapshot;
                progress_snapshot.progress = progress;
                progress_snapshot.phase = launcher::update::UpdatePhase::Downloading;
                progress_snapshot.message = "Dang tai: " + std::to_string(finished) + "/" + std::to_string(download_tasks.size()) + " goi cap nhat...";
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
        installing_snapshot.message = "Dang giai nen va cai dat ban cap nhat...";
        SetSnapshot(installing_snapshot);

        try {
            // 1. Giải nén các gói zip ra thư mục game
            for (const auto& zip_name : zips_to_download) {
                std::wstring wzip_name = launcher::update::Utf8ToWstring(zip_name);
                std::wstring zip_path = (std::filesystem::path(exe_dir_) / L"tmp" / wzip_name).wstring();

                if (!launcher::update::UnzipFile(zip_path, exe_dir_)) {
                    throw std::runtime_error("Khong the giai nen goi: " + zip_name);
                }
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
            }

            // 3. Copy đè version.json mới
            std::filesystem::path temp_ver = std::filesystem::path(exe_dir_) / L"tmp" / L"version.json";
            std::filesystem::path dest_ver = std::filesystem::path(exe_dir_) / L"version.json";
            std::filesystem::copy_file(temp_ver, dest_ver, std::filesystem::copy_options::overwrite_existing);

            // 4. Xóa sạch thư mục tạm
            std::filesystem::remove_all(std::filesystem::path(exe_dir_) / L"tmp");

            version_string_ = server_manifest_.version;
            has_update_ = false;
            LoadChangelog();

            launcher::update::UpdateSnapshot done_snapshot;
            done_snapshot.progress = 1.0f;
            done_snapshot.phase = launcher::update::UpdatePhase::Done;
            done_snapshot.message = "Cap nhat hoan tat! He thong da san sang.";
            SetSnapshot(done_snapshot);
        } catch (const std::exception& ex) {
            launcher::update::UpdateSnapshot error_snapshot;
            error_snapshot.phase = launcher::update::UpdatePhase::Error;
            error_snapshot.message = std::string("Loi cai dat: ") + ex.what();
            SetSnapshot(error_snapshot);
        } catch (...) {
            launcher::update::UpdateSnapshot error_snapshot;
            error_snapshot.phase = launcher::update::UpdatePhase::Error;
            error_snapshot.message = "Loi cai dat khong xac dinh.";
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
