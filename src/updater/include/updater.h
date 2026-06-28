#pragma once

#include <windows.h>
#include <string>

namespace launcher::updater {

struct UpdaterArgs {
    DWORD launcher_pid = 0;
    std::wstring current_path;
    std::wstring new_path;
    std::wstring backup_path;
    std::wstring launch_path;
    std::string expected_hash;
};

bool ParseUpdaterArgs(int argc, wchar_t** argv, UpdaterArgs* out, std::wstring* error);
bool WaitForLauncherExit(DWORD pid, std::wstring* error);
bool VerifyFileSha256(const std::wstring& path, const std::string& expected_hash, std::wstring* error);
bool ReplaceExecutable(const std::wstring& current_path, const std::wstring& new_path, const std::wstring& backup_path, std::wstring* error);
bool RelaunchLauncher(const std::wstring& launch_path, std::wstring* error);

}  // namespace launcher::updater
