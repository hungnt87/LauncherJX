#include <windows.h>
#include <shellapi.h>
#include "updater.h"

int WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int) {
    int argc = 0;
    wchar_t** argv = CommandLineToArgvW(GetCommandLineW(), &argc);
    if (!argv) {
        MessageBoxW(nullptr, L"Không thể phân tích đối số dòng lệnh.", L"Lỗi Updater", MB_OK | MB_ICONERROR);
        return 1;
    }

    using namespace launcher::updater;

    UpdaterArgs args;
    std::wstring error;

    if (!ParseUpdaterArgs(argc, argv, &args, &error)) {
        LocalFree(argv);
        MessageBoxW(nullptr, (L"Tham số dòng lệnh không hợp lệ:\n" + error).c_str(), L"Lỗi Updater", MB_OK | MB_ICONERROR);
        return 1;
    }

    LocalFree(argv);

    // 1. Đợi tiến trình launcher cũ thoát hẳn
    if (!WaitForLauncherExit(args.launcher_pid, &error)) {
        MessageBoxW(nullptr, (L"Không thể chờ launcher cũ thoát:\n" + error).c_str(), L"Lỗi Cập Nhật", MB_OK | MB_ICONERROR);
        return 1;
    }

    // 2. Kiểm tra SHA-256 của launcher mới tải về
    if (!VerifyFileSha256(args.new_path, args.expected_hash, &error)) {
        MessageBoxW(nullptr, (L"Kiểm tra tính toàn vẹn thất bại:\n" + error).c_str(), L"Lỗi Cập Nhật", MB_OK | MB_ICONERROR);
        return 1;
    }

    // 3. Thay thế file launcher hiện tại
    if (!ReplaceExecutable(args.current_path, args.new_path, args.backup_path, &error)) {
        MessageBoxW(nullptr, (L"Không thể thay thế tệp launcher:\n" + error).c_str(), L"Lỗi Cập Nhật", MB_OK | MB_ICONERROR);
        return 1;
    }

    // 4. Chạy lại launcher mới
    if (!RelaunchLauncher(args.launch_path, &error)) {
        MessageBoxW(nullptr, (L"Không thể khởi chạy lại launcher mới:\n" + error).c_str(), L"Lỗi Cập Nhật", MB_OK | MB_ICONERROR);
        return 1;
    }

    return 0;
}
