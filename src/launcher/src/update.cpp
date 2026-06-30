#include "update.h"
#include "common.h"

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
    out_manifest->updater = std::nullopt;

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

    // Phân tích cú pháp khối updater (nếu có)
    const size_t updater_pos = content.find("\"updater\"");
    if (updater_pos != std::string::npos) {
        const size_t obj_start = content.find('{', updater_pos);
        const size_t obj_end = content.find('}', obj_start);
        if (obj_start != std::string::npos && obj_end != std::string::npos && obj_end > obj_start) {
            const std::string updater_obj = content.substr(obj_start, obj_end - obj_start + 1);
            const std::string name = ExtractStringField(updater_obj, "name");
            const std::string hash = ExtractStringField(updater_obj, "hash");
            if (!name.empty() && !hash.empty()) {
                UpdaterAsset asset;
                asset.name = name;
                asset.hash = ToLowerAscii(hash);
                out_manifest->updater = asset;
            }
        }
    }

    out_manifest->version = version;
    out_manifest->files = files;
    return true;
}

bool VerifyFileSha256(const std::wstring& file_path, const std::string& expected_hash) {
    if (expected_hash.empty()) return false;
    std::string actual_hash = ComputeSha256(file_path);
    std::string lower_actual = ToLowerAscii(actual_hash);
    std::string lower_expected = ToLowerAscii(expected_hash);
    return !lower_actual.empty() && lower_actual == lower_expected;
}

bool ManifestHasLauncherBinary(const Manifest& manifest) {
    for (const auto& file : manifest.files) {
        std::string name = file.name;
        std::transform(name.begin(), name.end(), name.begin(), [](unsigned char c) { return std::tolower(c); });
        if (name == "launcherjx.exe") {
            return true;
        }
    }
    return false;
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
        
        std::string rel_path = file.name;
        std::transform(rel_path.begin(), rel_path.end(), rel_path.begin(), ::tolower);
        for (char& c : rel_path) {
            if (c == '\\') c = '/';
        }

        if (rel_path == "launcherjx.exe") {
            continue;
        }

        if (rel_path == "config.ini" || rel_path == "jx1mod.ini" || rel_path == "package.ini" || rel_path == "settings/serverlist.ini") {
            if (!std::filesystem::exists(local_path)) {
                files_to_update.push_back(file);
            }
        } else {
            // Đối với các file game thông thường, check sự tồn tại và khớp hash SHA-256
            const std::string local_hash = ComputeSha256(local_path.wstring());
            if (local_hash.empty() || ToLowerAscii(local_hash) != ToLowerAscii(file.hash)) {
                files_to_update.push_back(file);
            }
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
    const wchar_t* headers = L"Cache-Control: no-cache\r\nPragma: no-cache\r\n";
    HINTERNET hUrl = InternetOpenUrlW(active_hInternet, url.c_str(), headers, (DWORD)-1, flags, 0);
    if (!hUrl) {
        DWORD err = GetLastError(); // Lưu lại mã lỗi kết nối
        if (internal_hInternet) {
            InternetCloseHandle(internal_hInternet);
        }
        SetLastError(err); // Khôi phục mã lỗi
        return false;
    }

    // Kiểm tra HTTP Status Code (ví dụ tránh tải file lỗi 404)
    DWORD statusCode = 0;
    DWORD statusCodeSize = sizeof(statusCode);
    if (HttpQueryInfoW(hUrl, HTTP_QUERY_STATUS_CODE | HTTP_QUERY_FLAG_NUMBER, &statusCode, &statusCodeSize, nullptr)) {
        if (statusCode < 200 || statusCode >= 300) {
            InternetCloseHandle(hUrl);
            if (internal_hInternet) {
                InternetCloseHandle(internal_hInternet);
            }
            SetLastError(statusCode); // Thiết lập LastError bằng HTTP status code
            return false;
        }
    }

    DWORD contentLength = 0;
    DWORD contentLengthSize = sizeof(contentLength);
    HttpQueryInfoW(hUrl, HTTP_QUERY_CONTENT_LENGTH | HTTP_QUERY_FLAG_NUMBER, &contentLength, &contentLengthSize, nullptr);

    std::ofstream file(dest_path, std::ios::binary);
    if (!file.is_open()) {
        DWORD err = GetLastError(); // Lưu lại mã lỗi ghi file
        InternetCloseHandle(hUrl);
        if (internal_hInternet) {
            InternetCloseHandle(internal_hInternet);
        }
        SetLastError(err); // Khôi phục mã lỗi
        return false;
    }

    char buffer[8192];
    DWORD bytesRead = 0;
    size_t totalBytesRead = 0;
    bool readSuccess = true;
    DWORD readError = 0;

    while (running) {
        BOOL ok = InternetReadFile(hUrl, buffer, sizeof(buffer), &bytesRead);
        if (!ok) {
            readError = GetLastError();
            readSuccess = false;
            break;
        }
        if (bytesRead == 0) {
            break;
        }
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

    if (!readSuccess) {
        std::filesystem::remove(dest_path);
        SetLastError(readError);
        return false;
    }

    return true;
}

void MergeIniFiles(const std::wstring& default_ini_path, const std::wstring& local_ini_path) {
    if (!std::filesystem::exists(default_ini_path)) {
        return;
    }
    if (!std::filesystem::exists(local_ini_path)) {
        try {
            std::filesystem::copy_file(default_ini_path, local_ini_path, std::filesystem::copy_options::overwrite_existing);
        } catch (...) {}
        return;
    }

    // 1. Đọc tất cả các Section từ file mặc định
    std::vector<wchar_t> section_names(4096);
    DWORD len = GetPrivateProfileSectionNamesW(section_names.data(), (DWORD)section_names.size(), default_ini_path.c_str());
    while (len == section_names.size() - 2) {
        section_names.resize(section_names.size() * 2);
        len = GetPrivateProfileSectionNamesW(section_names.data(), (DWORD)section_names.size(), default_ini_path.c_str());
    }

    std::vector<std::wstring> sections;
    wchar_t* p = section_names.data();
    while (*p) {
        sections.push_back(p);
        p += wcslen(p) + 1;
    }

    // 2. Với mỗi Section, đọc tất cả các Key từ file mặc định
    for (const auto& section : sections) {
        std::vector<wchar_t> key_names(4096);
        DWORD key_len = GetPrivateProfileStringW(section.c_str(), nullptr, nullptr, key_names.data(), (DWORD)key_names.size(), default_ini_path.c_str());
        while (key_len == key_names.size() - 2) {
            key_names.resize(key_names.size() * 2);
            key_len = GetPrivateProfileStringW(section.c_str(), nullptr, nullptr, key_names.data(), (DWORD)key_names.size(), default_ini_path.c_str());
        }

        std::vector<std::wstring> keys;
        wchar_t* kp = key_names.data();
        while (*kp) {
            keys.push_back(kp);
            kp += wcslen(kp) + 1;
        }

        // 3. Với mỗi Key, kiểm tra xem file local đã có chưa. Nếu chưa có, lấy giá trị từ file mặc định và ghi vào file local
        for (const auto& key : keys) {
            wchar_t local_val[1024] = {0};
            const wchar_t* sentinel = L"__INI_KEY_NOT_FOUND__";
            GetPrivateProfileStringW(section.c_str(), key.c_str(), sentinel, local_val, 1024, local_ini_path.c_str());

            if (wcscmp(local_val, sentinel) == 0) {
                wchar_t default_val[1024] = {0};
                GetPrivateProfileStringW(section.c_str(), key.c_str(), L"", default_val, 1024, default_ini_path.c_str());
                WritePrivateProfileStringW(section.c_str(), key.c_str(), default_val, local_ini_path.c_str());
            }
        }
    }
}

void UpdateServerListOnlineRegion(const std::wstring& default_ini_path, const std::wstring& local_ini_path) {
    if (!std::filesystem::exists(default_ini_path)) return;
    
    if (!std::filesystem::exists(local_ini_path)) {
        std::filesystem::path parent = std::filesystem::path(local_ini_path).parent_path();
        if (!parent.empty()) {
            std::filesystem::create_directories(parent);
        }
        std::filesystem::copy_file(default_ini_path, local_ini_path, std::filesystem::copy_options::overwrite_existing);
        return;
    }

    int count = GetPrivateProfileIntW(L"Region_2", L"Count", 0, default_ini_path.c_str());
    
    WritePrivateProfileSectionW(L"Region_2", nullptr, local_ini_path.c_str());
    
    WritePrivateProfileStringW(L"Region_2", L"Count", std::to_wstring(count).c_str(), local_ini_path.c_str());
    
    for (int i = 0; i < count; ++i) {
        std::wstring title_key = std::to_wstring(i) + L"_Title";
        std::wstring addr_key = std::to_wstring(i) + L"_Address";
        
        wchar_t title_val[256] = {0};
        wchar_t addr_val[256] = {0};
        
        GetPrivateProfileStringW(L"Region_2", title_key.c_str(), L"", title_val, 256, default_ini_path.c_str());
        GetPrivateProfileStringW(L"Region_2", addr_key.c_str(), L"", addr_val, 256, default_ini_path.c_str());
        
        WritePrivateProfileStringW(L"Region_2", title_key.c_str(), title_val, local_ini_path.c_str());
        WritePrivateProfileStringW(L"Region_2", addr_key.c_str(), addr_val, local_ini_path.c_str());
    }

    wchar_t region2_val[64] = {0};
    GetPrivateProfileStringW(L"List", L"Region_2", L"", region2_val, 64, local_ini_path.c_str());
    if (wcslen(region2_val) == 0) {
        wchar_t default_r2[64] = {0};
        GetPrivateProfileStringW(L"List", L"Region_2", L"Online", default_r2, 64, default_ini_path.c_str());
        WritePrivateProfileStringW(L"List", L"Region_2", default_r2, local_ini_path.c_str());
    }
    
    wchar_t region_count[8] = {0};
    GetPrivateProfileStringW(L"List", L"RegionCount", L"", region_count, 8, local_ini_path.c_str());
    if (wcslen(region_count) == 0) {
        wchar_t default_rc[8] = {0};
        GetPrivateProfileStringW(L"List", L"RegionCount", L"2", default_rc, 8, default_ini_path.c_str());
        WritePrivateProfileStringW(L"List", L"RegionCount", default_rc, local_ini_path.c_str());
    }
}

bool CheckAndRepairIniFiles(const std::wstring& exe_dir, const Manifest& manifest, const std::atomic<bool>& running) {
    std::wstring branch = (manifest.version.empty() || manifest.version == "v0.0.0") ? L"dev" : Utf8ToWstring(manifest.version);
    std::wstring remote_prefix = L"https://raw.githubusercontent.com/hungnt87/LauncherJX/" + branch + L"/patch/";

    std::vector<std::string> special_configs = {"config.ini", "jx1mod.ini", "package.ini", "settings/serverlist.ini"};
    bool any_merged = false;

    for (const auto& config_name : special_configs) {
        // Tìm file entry tương ứng trong manifest từ server
        FileEntry target_entry;
        bool found_in_manifest = false;
        for (const auto& f : manifest.files) {
            std::string fname = f.name;
            std::transform(fname.begin(), fname.end(), fname.begin(), ::tolower);
            if (fname == config_name) {
                target_entry = f;
                found_in_manifest = true;
                break;
            }
        }

        if (!found_in_manifest) continue;

        std::wstring wconfig_name = Utf8ToWstring(target_entry.name);
        std::wstring local_path = (std::filesystem::path(exe_dir) / wconfig_name).wstring();
        std::wstring temp_default_path = (std::filesystem::path(exe_dir) / L"tmp" / (wconfig_name + L".default")).wstring();

        // Tính hash thực tế
        std::string local_hash = ComputeSha256(local_path);
        std::transform(local_hash.begin(), local_hash.end(), local_hash.begin(), ::tolower);
        std::string target_hash = target_entry.hash;
        std::transform(target_hash.begin(), target_hash.end(), target_hash.begin(), ::tolower);

        // Chỉ tải và merge nếu file bị thiếu hoặc hash thay đổi
        if (local_hash.empty() || local_hash != target_hash) {
            std::string encoded_name = UrlEncode(target_entry.name);
            std::wstring wencoded_name = Utf8ToWstring(encoded_name);
            std::wstring file_url = remote_prefix + wencoded_name;

            if (config_name == "settings/serverlist.ini") {
                std::wstring tag_w = Utf8ToWstring(manifest.version);
                file_url = L"https://github.com/hungnt87/LauncherJX/releases/download/" + tag_w + L"/serverlist.ini";
            }

            if (DownloadFile(nullptr, file_url, temp_default_path, running, nullptr)) {
                if (config_name == "settings/serverlist.ini") {
                    UpdateServerListOnlineRegion(temp_default_path, local_path);
                } else {
                    MergeIniFiles(temp_default_path, local_path);
                }
                try { std::filesystem::remove(temp_default_path); } catch (...) {}
                any_merged = true;
            }
        }
    }
    return any_merged;
}

}  // namespace launcher::update
