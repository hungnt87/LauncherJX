#include "common.h"

#include <windows.h>

namespace common {

std::wstring Utf8ToWide(const std::string& text) {
    if (text.empty()) {
        return L"";
    }

    const int size = MultiByteToWideChar(CP_UTF8, 0, text.data(), static_cast<int>(text.size()), nullptr, 0);
    if (size <= 0) {
        return L"";
    }

    std::wstring result(static_cast<size_t>(size), L'\0');
    MultiByteToWideChar(CP_UTF8, 0, text.data(), static_cast<int>(text.size()), result.data(), size);
    return result;
}

std::string WideToUtf8(const std::wstring& text) {
    if (text.empty()) {
        return "";
    }

    const int size = WideCharToMultiByte(CP_UTF8, 0, text.data(), static_cast<int>(text.size()), nullptr, 0, nullptr, nullptr);
    if (size <= 0) {
        return "";
    }

    std::string result(static_cast<size_t>(size), '\0');
    WideCharToMultiByte(CP_UTF8, 0, text.data(), static_cast<int>(text.size()), result.data(), size, nullptr, nullptr);
    return result;
}

bool CopyFileTime(const std::wstring& src_path, const std::wstring& dest_path) {
    HANDLE hSrc = CreateFileW(src_path.c_str(), GENERIC_READ, FILE_SHARE_READ, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (hSrc == INVALID_HANDLE_VALUE) {
        return false;
    }

    FILETIME creation_time, last_access_time, last_write_time;
    bool success = GetFileTime(hSrc, &creation_time, &last_access_time, &last_write_time);
    CloseHandle(hSrc);
    if (!success) {
        return false;
    }

    HANDLE hDest = CreateFileW(dest_path.c_str(), GENERIC_WRITE, FILE_SHARE_WRITE, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (hDest == INVALID_HANDLE_VALUE) {
        return false;
    }

    success = SetFileTime(hDest, &creation_time, &last_access_time, &last_write_time);
    CloseHandle(hDest);

    return success;
}

}  // namespace common

