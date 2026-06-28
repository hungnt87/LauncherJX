#pragma once

#include <string>
#include <vector>
#include <atomic>
#include <functional>
#include <optional>

namespace launcher::update {

// URL tải manifest version.json từ Release mới nhất của GitHub
const std::wstring kManifestUrl = L"https://github.com/hungnt87/LauncherJX/releases/latest/download/version.json";




// Tiền tố URL để tải các file game theo Tag phiên bản
const std::wstring kServerRawPrefix = L"https://raw.githubusercontent.com/hungnt87/LauncherJX/";

struct ManifestSource {
    std::wstring path;
    std::string content;
};

struct FileEntry {
    std::string name;
    std::string hash;
    std::string zip;
};

struct UpdaterAsset {
    std::string name;
    std::string hash;
};

struct Manifest {
    std::string version;
    std::optional<UpdaterAsset> updater;
    std::vector<FileEntry> files;
};


enum class UpdatePhase {
    Idle,
    Checking,
    Downloading,
    SelfUpdating,
    Done,
    Error,
};


struct UpdateSnapshot {
    float progress = 0.0f;
    UpdatePhase phase = UpdatePhase::Idle;
    std::string message;
};

int CompareSemanticVersion(const std::string& v1, const std::string& v2);
bool ParseManifest(const ManifestSource& source, Manifest* out_manifest, std::string* error);
std::string ComputeSha256(const std::wstring& file_path);
bool VerifyFileSha256(const std::wstring& file_path, const std::string& expected_hash);
bool ManifestHasLauncherBinary(const Manifest& manifest);


// Thay đổi kiểu trả về thành FileEntry để lấy được cả tên và hash file cần tải
std::vector<FileEntry> CollectFilesToUpdate(const std::wstring& exe_dir, const Manifest& manifest);

// Hàm tiện ích chuyển đổi UTF-8 string sang std::wstring (Win32)
std::wstring Utf8ToWstring(const std::string& str);

// Hàm tiện ích mã hóa URL (Percent-encoding) cho tên file chứa ký tự đặc biệt
std::string UrlEncode(const std::string& value);

// Hàm tiện ích giải nén file zip ngầm bằng PowerShell
bool UnzipFile(const std::wstring& zip_path, const std::wstring& dest_dir);

// Hàm thực hiện tải file qua WinINet hỗ trợ báo cáo tiến trình và hủy tải
// hInternet có thể truyền từ ngoài vào để tái sử dụng kết nối (HTTP Keep-Alive), nếu truyền nullptr sẽ tự mở
bool DownloadFile(void* hInternet, const std::wstring& url, const std::wstring& dest_path, const std::atomic<bool>& running, const std::function<void(float)>& progress_callback);

void MergeIniFiles(const std::wstring& default_ini_path, const std::wstring& local_ini_path);
bool CheckAndRepairIniFiles(const std::wstring& exe_dir, const Manifest& manifest, const std::atomic<bool>& running);

}  // namespace launcher::update
