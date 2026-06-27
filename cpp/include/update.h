#pragma once

#include <string>
#include <vector>
#include <atomic>
#include <functional>

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

int CompareSemanticVersion(const std::string& v1, const std::string& v2);
bool ParseManifest(const ManifestSource& source, Manifest* out_manifest, std::string* error);
std::string ComputeSha256(const std::wstring& file_path);

// Thay đổi kiểu trả về thành FileEntry để lấy được cả tên và hash file cần tải
std::vector<FileEntry> CollectFilesToUpdate(const std::wstring& exe_dir, const Manifest& manifest);

// Hàm tiện ích chuyển đổi UTF-8 string sang std::wstring (Win32)
std::wstring Utf8ToWstring(const std::string& str);

// Hàm tiện ích mã hóa URL (Percent-encoding) cho tên file chứa ký tự đặc biệt
std::string UrlEncode(const std::string& value);

// Hàm thực hiện tải file qua WinINet hỗ trợ báo cáo tiến trình và hủy tải
// hInternet có thể truyền từ ngoài vào để tái sử dụng kết nối (HTTP Keep-Alive), nếu truyền nullptr sẽ tự mở
bool DownloadFile(void* hInternet, const std::wstring& url, const std::wstring& dest_path, const std::atomic<bool>& running, const std::function<void(float)>& progress_callback);

}  // namespace launcher::update
