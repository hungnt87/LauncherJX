#include "updater.h"
#include <cassert>
#include <filesystem>
#include <fstream>
#include <iostream>

namespace {

void WriteTextFile(const std::filesystem::path& path, const std::string& content) {
    std::filesystem::create_directories(path.parent_path());
    std::ofstream file(path, std::ios::binary);
    file << content;
}

std::string ReadTextFile(const std::filesystem::path& path) {
    std::ifstream file(path, std::ios::binary);
    return std::string(std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>());
}

}  // namespace

void TestReplaceExecutableCopiesVersionJson() {
    using namespace launcher::updater;

    const std::filesystem::path root = std::filesystem::temp_directory_path() / "LauncherJX_updater_test";
    std::filesystem::remove_all(root);
    std::filesystem::create_directories(root / "tmp");

    const std::filesystem::path current = root / "LauncherJX.exe";
    const std::filesystem::path replacement = root / "tmp" / "LauncherJX.exe.new";
    const std::filesystem::path backup = root / "LauncherJX.exe.bak";
    const std::filesystem::path version_src = root / "tmp" / "version.json";
    const std::filesystem::path version_dest = root / "version.json";

    WriteTextFile(current, "old-launcher");
    WriteTextFile(replacement, "new-launcher");
    WriteTextFile(version_src, R"({"version":"v9.9.9"})");

    std::wstring error;
    assert(ReplaceExecutable(current.wstring(), replacement.wstring(), backup.wstring(), &error));
    assert(std::filesystem::exists(current));
    assert(ReadTextFile(current) == "new-launcher");
    assert(std::filesystem::exists(version_dest));
    assert(ReadTextFile(version_dest) == R"({"version":"v9.9.9"})");
    assert(!std::filesystem::exists(backup));
    assert(!std::filesystem::exists(replacement));
    assert(!std::filesystem::exists(version_src));

    std::filesystem::remove_all(root);
}

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

    TestReplaceExecutableCopiesVersionJson();
    
    std::cout << "All updater tests passed!" << std::endl;
    return 0;
}
