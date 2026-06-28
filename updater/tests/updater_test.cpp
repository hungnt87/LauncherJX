#include "updater.h"
#include <cassert>
#include <iostream>

int main() {
    using namespace launcher::updater;

    UpdaterArgs args{};
    std::wstring error;

    const wchar_t* argv[] = {
        L"updater.exe",
        L"--launcher-pid", L"1234",
        L"--current", L"C:\\LauncherJX\\LauncherJX.exe",
        L"--new", L"C:\\LauncherJX\\tmp\\LauncherJX.exe.new",
        L"--expected-hash", L"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        L"--launch", L"C:\\LauncherJX\\LauncherJX.exe"
    };

    assert(ParseUpdaterArgs(sizeof(argv) / sizeof(argv[0]), const_cast<wchar_t**>(argv), &args, &error));
    assert(args.launcher_pid == 1234);
    assert(args.launch_path == L"C:\\LauncherJX\\LauncherJX.exe");
    
    std::cout << "All updater tests passed!" << std::endl;
    return 0;
}
