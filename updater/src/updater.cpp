#include "updater.h"
#include "common.h"

#include <windows.h>
#include <wincrypt.h>
#include <fstream>
#include <algorithm>
#include <sstream>
#include <iomanip>
#include <vector>

namespace launcher::updater {

namespace {

std::string ToLowerAscii(std::string text) {
    std::transform(text.begin(), text.end(), text.begin(), [](unsigned char ch) {
        return static_cast<char>(std::tolower(ch));
    });
    return text;
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

}  // namespace

bool ParseUpdaterArgs(int argc, wchar_t** argv, UpdaterArgs* out, std::wstring* error) {
    if (out == nullptr) {
        if (error) *error = L"Output structure is null";
        return false;
    }

    for (int i = 1; i < argc; ++i) {
        std::wstring arg = argv[i];
        if (arg == L"--launcher-pid" && i + 1 < argc) {
            out->launcher_pid = std::wcstoul(argv[++i], nullptr, 10);
        } else if (arg == L"--current" && i + 1 < argc) {
            out->current_path = argv[++i];
        } else if (arg == L"--new" && i + 1 < argc) {
            out->new_path = argv[++i];
        } else if (arg == L"--backup" && i + 1 < argc) {
            out->backup_path = argv[++i];
        } else if (arg == L"--launch" && i + 1 < argc) {
            out->launch_path = argv[++i];
        } else if (arg == L"--expected-hash" && i + 1 < argc) {
            // expected_hash trong struct là std::string, ta convert từ wide sang utf8
            out->expected_hash = common::WideToUtf8(argv[++i]);
        }
    }

    if (out->launcher_pid == 0) {
        if (error) *error = L"Missing or invalid --launcher-pid";
        return false;
    }
    if (out->current_path.empty()) {
        if (error) *error = L"Missing --current path";
        return false;
    }
    if (out->new_path.empty()) {
        if (error) *error = L"Missing --new path";
        return false;
    }
    if (out->expected_hash.empty()) {
        if (error) *error = L"Missing --expected-hash";
        return false;
    }
    if (out->launch_path.empty()) {
        // Mặc định launch_path giống current_path
        out->launch_path = out->current_path;
    }

    return true;
}

bool WaitForLauncherExit(DWORD pid, std::wstring* error) {
    // Mở tiến trình với quyền SYNCHRONIZE để đợi và PROCESS_TERMINATE để có thể tắt nếu bị kẹt
    HANDLE hProcess = OpenProcess(SYNCHRONIZE | PROCESS_TERMINATE, FALSE, pid);
    if (!hProcess) {
        // Có thể tiến trình đã thoát rồi
        return true;
    }

    DWORD wait_result = WaitForSingleObject(hProcess, 5000); // Đợi tối đa 5 giây
    if (wait_result == WAIT_TIMEOUT) {
        // Nếu quá 5 giây mà launcher cũ chưa thoát (bị kẹt), ép buộc kết thúc tiến trình
        TerminateProcess(hProcess, 0);
        // Đợi thêm tối đa 2 giây để hệ điều hành giải phóng hoàn toàn tệp thực thi
        WaitForSingleObject(hProcess, 2000);
    } else if (wait_result == WAIT_FAILED) {
        if (error) *error = L"Failed to wait for launcher process exit: " + std::to_wstring(GetLastError());
        CloseHandle(hProcess);
        return false;
    }

    CloseHandle(hProcess);
    return true;
}


bool VerifyFileSha256(const std::wstring& path, const std::string& expected_hash, std::wstring* error) {
    std::string actual_hash = ComputeSha256(path);
    if (actual_hash.empty()) {
        if (error) *error = L"Could not compute hash for file: " + path;
        return false;
    }

    std::string lower_actual = ToLowerAscii(actual_hash);
    std::string lower_expected = ToLowerAscii(expected_hash);

    if (lower_actual != lower_expected) {
        if (error) {
            *error = L"Hash mismatch for " + path + L". Expected: " + 
                     common::Utf8ToWide(lower_expected) + L", Got: " + common::Utf8ToWide(lower_actual);
        }
        return false;
    }

    return true;
}

bool ReplaceExecutable(const std::wstring& current_path, const std::wstring& new_path, const std::wstring& backup_path, std::wstring* error) {
    std::wstring bak_path = backup_path;
    if (bak_path.empty()) {
        bak_path = current_path + L".bak";
    }

    // Xóa file backup cũ nếu có
    if (GetFileAttributesW(bak_path.c_str()) != INVALID_FILE_ATTRIBUTES) {
        DeleteFileW(bak_path.c_str());
    }

    // Đổi tên file đang chạy sang backup (.bak)
    if (!MoveFileW(current_path.c_str(), bak_path.c_str())) {
        if (error) *error = L"Không thể đổi tên launcher hiện tại thành file sao lưu (Mã lỗi: " + std::to_wstring(GetLastError()) + L")";
        return false;
    }

    // Sao chép file mới đè lên file launcher chính
    if (!CopyFileW(new_path.c_str(), current_path.c_str(), FALSE)) {
        if (error) *error = L"Không thể sao chép launcher mới (Mã lỗi: " + std::to_wstring(GetLastError()) + L")";
        // Khôi phục từ file backup
        MoveFileW(bak_path.c_str(), current_path.c_str());
        return false;
    }

    // Sao chép tệp version.json mới để cập nhật thông tin phiên bản local của người chơi
    std::wstring cur_dir = current_path;
    size_t pos_cur = cur_dir.find_last_of(L"\\/");
    if (pos_cur != std::wstring::npos) {
        cur_dir = cur_dir.substr(0, pos_cur);
    }
    std::wstring new_dir = new_path;
    size_t pos_new = new_dir.find_last_of(L"\\/");
    if (pos_new != std::wstring::npos) {
        new_dir = new_dir.substr(0, pos_new);
    }
    std::wstring src_ver = new_dir + L"\\version.json";
    std::wstring dest_ver = cur_dir + L"\\version.json";
    if (GetFileAttributesW(src_ver.c_str()) != INVALID_FILE_ATTRIBUTES) {
        CopyFileW(src_ver.c_str(), dest_ver.c_str(), FALSE);
    }

    // Xóa file tạm launcher mới, file version.json tạm và file backup
    DeleteFileW(new_path.c_str());
    DeleteFileW(src_ver.c_str());
    DeleteFileW(bak_path.c_str()); // Có thể thất bại nếu OS chưa nhả file, nhưng không sao


    return true;
}

bool RelaunchLauncher(const std::wstring& launch_path, std::wstring* error) {
    STARTUPINFOW si;
    PROCESS_INFORMATION pi;
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));

    std::wstring working_dir;
    size_t pos = launch_path.find_last_of(L"\\/");
    if (pos != std::wstring::npos) {
        working_dir = launch_path.substr(0, pos);
    }

    std::wstring cmd = L"\"" + launch_path + L"\"";
    std::vector<wchar_t> cmd_buf(cmd.begin(), cmd.end());
    cmd_buf.push_back(L'\0');

    if (!CreateProcessW(
            nullptr,
            cmd_buf.data(),
            nullptr,
            nullptr,
            FALSE,
            0,
            nullptr,
            working_dir.empty() ? nullptr : working_dir.c_str(),
            &si,
            &pi)) {
        if (error) *error = L"Không thể chạy lại launcher mới (Mã lỗi: " + std::to_wstring(GetLastError()) + L")";
        return false;
    }

    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    return true;
}

}  // namespace launcher::updater
