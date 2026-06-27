#include "update.h"

#include <windows.h>
#include <wincrypt.h>

#include <algorithm>
#include <cctype>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <sstream>

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
        if (!name.empty() && !hash.empty()) {
            files.push_back(FileEntry{name, ToLowerAscii(hash)});
        }

        cursor = object_end + 1;
    }

    return files;
}

}  // namespace

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

std::vector<std::wstring> CollectFilesToUpdate(const std::wstring& exe_dir, const Manifest& manifest) {
    std::vector<std::wstring> files_to_update;

    const std::filesystem::path root(exe_dir);
    const std::filesystem::path launcher_res = root / L"launcher_res";

    for (const FileEntry& file : manifest.files) {
        const std::filesystem::path local_path = launcher_res / std::filesystem::path(std::wstring(file.name.begin(), file.name.end()));
        const std::string local_hash = ComputeSha256(local_path.wstring());
        if (local_hash.empty() || ToLowerAscii(local_hash) != ToLowerAscii(file.hash)) {
            files_to_update.push_back(local_path.wstring());
        }
    }

    return files_to_update;
}

}  // namespace launcher::update
