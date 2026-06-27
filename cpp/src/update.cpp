#include "update.h"

#include <windows.h>
#include <wincrypt.h>
#include <wininet.h>

#include <algorithm>
#include <cctype>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <sstream>
#include <iomanip>

namespace launcher::update {

namespace {

std::string ToLowerAscii(std::string text) {
    std::transform(text.begin(), text.end(), text.begin(), [](unsigned char ch) {
        return static_cast<char>(std::tolower(ch));
    });
    return text;
}

std::string ExtractStringField(const std::string& json, const std::string& key) {
    const std::string quoted_key = "\"" + key + "\"";
    const size_t key_pos = json.find(quoted_key);
    if (key_pos == std::string::npos) {
        return "";
    }

    const size_t colon_pos = json.find(':', key_pos + quoted_key.size());
    if (colon_pos == std::string::npos) {
        return "";
    }

    const size_t start_quote = json.find('"', colon_pos + 1);
    if (start_quote == std::string::npos) {
        return "";
    }

    const size_t end_quote = json.find('"', start_quote + 1);
    if (end_quote == std::string::npos || end_quote <= start_quote) {
        return "";
    }

    return json.substr(start_quote + 1, end_quote - start_quote - 1);
}

std::vector<FileEntry> ExtractFiles(const std::string& json) {
    std::vector<FileEntry> files;

    const size_t files_pos = json.find("\"files\"");
    if (files_pos == std::string::npos) {
        return files;
    }

    const size_t array_start = json.find('[', files_pos);
    const size_t array_end = json.find(']', array_start);
    if (array_start == std::string::npos || array_end == std::string::npos || array_end <= array_start) {
        return files;
    }

    const std::string array_content = json.substr(array_start + 1, array_end - array_start - 1);
    size_t cursor = 0;
    while (true) {
        const size_t object_start = array_content.find('{', cursor);
        if (object_start == std::string::npos) {
            break;
        }

        const size_t object_end = array_content.find('}', object_start);
        if (object_end == std::string::npos) {
            break;
        }

        const std::string object = array_content.substr(object_start, object_end - object_start + 1);
        const std::string name = ExtractStringField(object, "name");
        const std::string hash = ExtractStringField(object, "hash");
        const std::string zip = ExtractStringField(object, "zip");
        if (!name.empty() && !hash.empty()) {
            files.push_back(FileEntry{name, ToLowerAscii(hash), zip});
        }

        cursor = object_end + 1;
    }

    return files;
}

}  // namespace

int CompareSemanticVersion(const std::string& v1, const std::string& v2) {
    auto cleanup = [](const std::string& version) -> std::string {
        size_t start = 0;
        while (start < version.size() && !std::isdigit(static_cast<unsigned char>(version[start]))) {
            start++;
        }
        return version.substr(start);
    };

    std::string clean_v1 = cleanup(v1);
    std::string clean_v2 = cleanup(v2);

    auto split = [](const std::string& s) -> std::vector<int> {
        std::vector<int> parts;
        std::stringstream ss(s);
        std::string item;
        while (std::getline(ss, item, '.')) {
            try {
                size_t num_end = 0;
                int val = std::stoi(item, &num_end);
                parts.push_back(val);
            } catch (...) {
                parts.push_back(0);
            }
        }
        return parts;
    };

    std::vector<int> parts_v1 = split(clean_v1);
    std::vector<int> parts_v2 = split(clean_v2);

    size_t max_size = (std::max)(parts_v1.size(), parts_v2.size());
    for (size_t i = 0; i < max_size; ++i) {
        int val1 = (i < parts_v1.size()) ? parts_v1[i] : 0;
        int val2 = (i < parts_v2.size()) ? parts_v2[i] : 0;
        if (val1 > val2) {
            return 1;
        } else if (val1 < val2) {
            return -1;
        }
    }

    return 0;
}

bool ParseManifest(const ManifestSource& source, Manifest* out_manifest, std::string* error) {
    if (out_manifest == nullptr) {
        if (error != nullptr) {
            *error = "out_manifest is null";
        }
        return false;
    }

    out_manifest->version.clear();
    out_manifest->files.clear();

    const std::string content = source.content;
    const std::string version = ExtractStringField(content, "version");
    if (version.empty()) {
        if (error != nullptr) {
            *error = "version.json missing version";
        }
        return false;
    }

    const std::vector<FileEntry> files = ExtractFiles(content);
    if (files.empty()) {
        if (error != nullptr) {
            *error = "version.json missing files";
        }
        return false;
    }

    out_manifest->version = version;
    out_manifest->files = files;
    return true;
}

std::string ComputeSha256(const std::wstring& file_path) {
    std::ifstream file(file_path, std::ios::binary);
    if (!file.is_open()) {
        return "";
    }

    HCRYPTPROV provider = 0;
    HCRYPTHASH hash = 0;
    std::string result;

    if (!CryptAcquireContextW(&provider, nullptr, nullptr, PROV_RSA_AES, CRYPT_VERIFYCONTEXT)) {
        return "";
    }

    if (!CryptCreateHash(provider, CALG_SHA_256, 0, 0, &hash)) {
        CryptReleaseContext(provider, 0);
        return "";
    }

    char buffer[4096];
    while (file.good()) {
        file.read(buffer, sizeof(buffer));
        const std::streamsize bytes_read = file.gcount();
        if (bytes_read > 0) {
            if (!CryptHashData(hash, reinterpret_cast<BYTE*>(buffer), static_cast<DWORD>(bytes_read), 0)) {
                CryptDestroyHash(hash);
                CryptReleaseContext(provider, 0);
                return "";
            }
        }
    }

    DWORD hash_size = 0;
    DWORD hash_size_len = sizeof(hash_size);
    if (!CryptGetHashParam(hash, HP_HASHSIZE, reinterpret_cast<BYTE*>(&hash_size), &hash_size_len, 0)) {
        CryptDestroyHash(hash);
        CryptReleaseContext(provider, 0);
        return "";
    }

    std::vector<BYTE> hash_bytes(hash_size);
    DWORD hash_value_len = hash_size;
    if (!CryptGetHashParam(hash, HP_HASHVAL, hash_bytes.data(), &hash_value_len, 0)) {
        CryptDestroyHash(hash);
        CryptReleaseContext(provider, 0);
        return "";
    }

    std::ostringstream output;
    output.setf(std::ios::hex, std::ios::basefield);
    output.fill('0');
    for (BYTE byte : hash_bytes) {
        output.width(2);
        output << std::nouppercase << static_cast<int>(byte);
    }
    result = output.str();

    CryptDestroyHash(hash);
    CryptReleaseContext(provider, 0);
    return ToLowerAscii(result);
}

std::wstring Utf8ToWstring(const std::string& str) {
    if (str.empty()) return L"";
    int size_needed = MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), nullptr, 0);
    std::wstring wstrTo(size_needed, 0);
    MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), &wstrTo[0], size_needed);
    return wstrTo;
}

std::string UrlEncode(const std::string& value) {
    std::ostringstream escaped;
    escaped.fill('0');
    escaped.setf(std::ios::hex, std::ios::basefield);

    for (std::string::const_iterator i = value.begin(), n = value.end(); i != n; ++i) {
        unsigned char c = static_cast<unsigned char>(*i);

        // Kiểm tra ký tự ASCII an toàn thủ công, độc lập với locale hệ thống
        if ((c >= 'a' && c <= 'z') ||
            (c >= 'A' && c <= 'Z') ||
            (c >= '0' && c <= '9') ||
            c == '-' || c == '_' || c == '.' || c == '~' || c == '/') {
            escaped << static_cast<char>(c);
            continue;
        }

        escaped << '%' << std::setw(2) << std::uppercase << int(c);
    }

    return escaped.str();
}

std::vector<FileEntry> CollectFilesToUpdate(const std::wstring& exe_dir, const Manifest& manifest) {
    std::vector<FileEntry> files_to_update;

    const std::filesystem::path root(exe_dir);

    for (const FileEntry& file : manifest.files) {
        std::wstring wname = Utf8ToWstring(file.name);
        const std::filesystem::path local_path = root / std::filesystem::path(wname);
        const std::string local_hash = ComputeSha256(local_path.wstring());
        if (local_hash.empty() || ToLowerAscii(local_hash) != ToLowerAscii(file.hash)) {
            files_to_update.push_back(file);
        }
    }

    return files_to_update;
}

bool UnzipFile(const std::wstring& zip_path, const std::wstring& dest_dir) {
    std::filesystem::create_directories(dest_dir);

    std::wstring cmd = L"powershell.exe -NoProfile -NonInteractive -WindowStyle Hidden -Command \"Expand-Archive -Path '" + zip_path + L"' -DestinationPath '" + dest_dir + L"' -Force\"";
    
    STARTUPINFOW si;
    PROCESS_INFORMATION pi;
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESHOWWINDOW;
    si.wShowWindow = SW_HIDE;
    ZeroMemory(&pi, sizeof(pi));

    std::vector<wchar_t> cmd_buf(cmd.begin(), cmd.end());
    cmd_buf.push_back(L'\0');

    if (!CreateProcessW(nullptr, cmd_buf.data(), nullptr, nullptr, FALSE, CREATE_NO_WINDOW, nullptr, nullptr, &si, &pi)) {
        return false;
    }

    WaitForSingleObject(pi.hProcess, INFINITE);

    DWORD exit_code = 0;
    GetExitCodeProcess(pi.hProcess, &exit_code);

    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);

    return exit_code == 0;
}

bool DownloadFile(void* hInternet, const std::wstring& url, const std::wstring& dest_path, const std::atomic<bool>& running, const std::function<void(float)>& progress_callback) {
    // Đảm bảo thư mục cha tồn tại
    std::filesystem::path dest(dest_path);
    if (dest.has_parent_path()) {
        std::filesystem::create_directories(dest.parent_path());
    }

    HINTERNET active_hInternet = reinterpret_cast<HINTERNET>(hInternet);
    HINTERNET internal_hInternet = nullptr;

    if (!active_hInternet) {
        internal_hInternet = InternetOpenW(L"LauncherJX/1.0", INTERNET_OPEN_TYPE_DIRECT, nullptr, nullptr, 0);
        active_hInternet = internal_hInternet;
    }
    if (!active_hInternet) return false;

    DWORD flags = INTERNET_FLAG_RELOAD | INTERNET_FLAG_DONT_CACHE | INTERNET_FLAG_SECURE;
    HINTERNET hUrl = InternetOpenUrlW(active_hInternet, url.c_str(), nullptr, 0, flags, 0);
    if (!hUrl) {
        if (internal_hInternet) {
            InternetCloseHandle(internal_hInternet);
        }
        return false;
    }

    // Kiểm tra HTTP Status Code (ví dụ tránh tải file lỗi 404)
    DWORD statusCode = 0;
    DWORD statusCodeSize = sizeof(statusCode);
    if (HttpQueryInfoW(hUrl, HTTP_QUERY_STATUS_CODE | HTTP_QUERY_FLAG_NUMBER, &statusCode, &statusCodeSize, nullptr)) {
        if (statusCode < 200 || statusCode >= 300) {
            SetLastError(statusCode); // Thiết lập LastError bằng HTTP status code để hiển thị
            InternetCloseHandle(hUrl);
            if (internal_hInternet) {
                InternetCloseHandle(internal_hInternet);
            }
            return false;
        }
    }

    DWORD contentLength = 0;
    DWORD contentLengthSize = sizeof(contentLength);
    HttpQueryInfoW(hUrl, HTTP_QUERY_CONTENT_LENGTH | HTTP_QUERY_FLAG_NUMBER, &contentLength, &contentLengthSize, nullptr);

    std::ofstream file(dest_path, std::ios::binary);
    if (!file.is_open()) {
        InternetCloseHandle(hUrl);
        if (internal_hInternet) {
            InternetCloseHandle(internal_hInternet);
        }
        return false;
    }

    char buffer[8192];
    DWORD bytesRead = 0;
    size_t totalBytesRead = 0;

    while (running && InternetReadFile(hUrl, buffer, sizeof(buffer), &bytesRead) && bytesRead > 0) {
        file.write(buffer, bytesRead);
        totalBytesRead += bytesRead;
        if (contentLength > 0 && progress_callback) {
            progress_callback(static_cast<float>(totalBytesRead) / contentLength);
        }
    }

    file.close();
    InternetCloseHandle(hUrl);
    if (internal_hInternet) {
        InternetCloseHandle(internal_hInternet);
    }

    if (!running) {
        // Xóa file tải dở nếu bị hủy giữa chừng
        std::filesystem::remove(dest_path);
        return false;
    }

    return true;
}

}  // namespace launcher::update
