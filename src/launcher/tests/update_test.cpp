#include "update.h"
#include <iostream>
#include <cassert>
#include <string>
#include <filesystem>
#include <fstream>
#include <windows.h>

void TestCompareSemanticVersion() {
    using namespace launcher::update;

    // Bằng nhau
    assert(CompareSemanticVersion("v1.0.0", "1.0.0") == 0);
    assert(CompareSemanticVersion("v1.0.0", "v1.0.0") == 0);
    assert(CompareSemanticVersion("1.0", "1.0.0") == 0);
    assert(CompareSemanticVersion("v2.5", "2.5.0.0") == 0);

    // Lớn hơn
    assert(CompareSemanticVersion("v1.0.1", "1.0.0") == 1);
    assert(CompareSemanticVersion("v1.1.0", "v1.0.9") == 1);
    assert(CompareSemanticVersion("2.0.0", "v1.9.9") == 1);
    assert(CompareSemanticVersion("v1.0.0.1", "1.0.0") == 1);
    assert(CompareSemanticVersion("v1.0.1-alpha", "1.0.0") == 1);

    // Nhỏ hơn
    assert(CompareSemanticVersion("v1.0.0", "1.0.1") == -1);
    assert(CompareSemanticVersion("v1.0.9", "v1.1.0") == -1);
    assert(CompareSemanticVersion("1.9.9", "v2.0.0") == -1);
    assert(CompareSemanticVersion("1.0.0", "v1.0.0.1") == -1);

    std::cout << "All Semantic Version tests passed successfully!" << std::endl;
}

void TestUrlEncode() {
    using namespace launcher::update;

    assert(UrlEncode("script/a.lua") == "script/a.lua");
    assert(UrlEncode("data-txt_1.0.txt") == "data-txt_1.0.txt");
    assert(UrlEncode("script/½ð.lua") == "script/%C2%BD%C3%B0.lua");
    assert(UrlEncode("script/skill/gaibang/½ðÎÚÓ³Ñ©.lua") == "script/skill/gaibang/%C2%BD%C3%B0%C3%8E%C3%9A%C3%93%C2%B3%C3%91%C2%A9.lua");
    assert(UrlEncode("script/skill/kunlun/ÎåÀ×Õý·¨.lua") == "script/skill/kunlun/%C3%8E%C3%A5%C3%80%C3%97%C3%95%C3%BD%C2%B7%C2%A8.lua");

    std::cout << "All UrlEncode tests passed successfully!" << std::endl;
}

void TestManifestUpdaterAndHash() {
    using namespace launcher::update;

    const std::string json = R"({
      "version": "v1.2.3",
      "updater": {
        "name": "updater.exe",
        "hash": "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
      },
      "files": [
        { "name": "LauncherJX.exe", "hash": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "zip": "" }
      ]
    })";

    ManifestSource source;
    source.path = L"manifest.json";
    source.content = json;

    Manifest manifest;
    std::string error;
    assert(ParseManifest(source, &manifest, &error));
    assert(manifest.updater.has_value());
    assert(manifest.updater->name == "updater.exe");
    assert(ManifestHasLauncherBinary(manifest));
}

void TestLauncherSelfUpdateSelection() {
    using namespace launcher::update;

    Manifest manifest;
    manifest.version = "v2.0.0";
    manifest.updater = UpdaterAsset{"updater.exe", "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"};
    manifest.files.push_back(FileEntry{"LauncherJX.exe", "cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc", ""});
    manifest.files.push_back(FileEntry{"data.pak", "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd", "patch.zip"});

    // Expected behavior: launcher binary is treated as self-update, not as a manual file update.
    assert(ManifestHasLauncherBinary(manifest));
}

void TestMergeIniFiles() {
    using namespace launcher::update;

    std::filesystem::path temp_dir = std::filesystem::temp_directory_path() / "launcher_test_ini";
    std::filesystem::create_directories(temp_dir);

    std::filesystem::path default_path = temp_dir / "default.ini";
    std::filesystem::path local_path = temp_dir / "local.ini";

    // Tạo default.ini (file mẫu chuẩn mới từ server)
    {
        std::ofstream out(default_path);
        out << "[List]\n"
            << "RegionCount=3\n"
            << "Region_0=May chu da vao\n"
            << "Region_1=Vo lam truyen ky\n"
            << "\n"
            << "[Region_1]\n"
            << "Count=3\n"
            << "0_Title=Offline_CentOS\n"
            << "0_Address=192.168.1.12\n"
            << "1_Title=Online\n"
            << "1_Address=192.168.196.111\n"
            << "2_Title=New_Server\n"
            << "2_Address=192.168.1.200\n";
    }

    // Tạo local.ini (file cấu hình hiện tại của người chơi)
    {
        std::ofstream out(local_path);
        out << "[List]\n"
            << "RegionCount=2\n"
            << "Region_0=May chu da vao\n"
            << "Region_1=Vo lam truyen ky\n"
            << "\n"
            << "[Region_1]\n"
            << "Count=2\n"
            << "0_Title=Offline_CentOS\n"
            << "0_Address=192.168.1.12\n"
            << "1_Title=Online\n"
            << "1_Address=192.168.196.111\n";
    }

    // Tiến hành merge
    MergeIniFiles(default_path.wstring(), local_path.wstring());

    wchar_t val[100];
    // Kiểm tra RegionCount (vẫn phải là 2 vì đã tồn tại ở local)
    GetPrivateProfileStringW(L"List", L"RegionCount", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"2");

    // Kiểm tra Count (vẫn phải là 2 vì đã tồn tại ở local)
    GetPrivateProfileStringW(L"Region_1", L"Count", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"2");

    // Kiểm tra 2_Title (phải được thêm mới)
    GetPrivateProfileStringW(L"Region_1", L"2_Title", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"New_Server");

    // Kiểm tra 2_Address (phải được thêm mới)
    GetPrivateProfileStringW(L"Region_1", L"2_Address", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"192.168.1.200");

    // Dọn dẹp
    std::filesystem::remove_all(temp_dir);

    std::cout << "All MergeIniFiles tests passed successfully!" << std::endl;
}

void TestUpdateServerListOnlineRegion() {
    using namespace launcher::update;

    std::filesystem::path temp_dir = std::filesystem::temp_directory_path() / "launcher_test_serverlist";
    std::filesystem::remove_all(temp_dir);
    std::filesystem::create_directories(temp_dir);

    std::filesystem::path default_path = temp_dir / "server_default.ini";
    std::filesystem::path local_path = temp_dir / "server_local.ini";

    {
        std::ofstream out(default_path);
        out << "[List]\n"
            << "RegionCount=3\n"
            << "Region_0=Server Recent\n"
            << "Region_1=Server Online\n"
            << "Region_2=Server Offline\n"
            << "\n"
            << "[Region_1]\n"
            << "Count=1\n"
            << "0_Title=Admin Online\n"
            << "0_Address=10.0.0.1\n";
    }

    {
        std::ofstream out(local_path);
        out << "[List]\n"
            << "RegionCount=2\n"
            << "Region_0=Local Recent\n"
            << "Region_1=Local Online\n"
            << "Region_2=Local Editable\n"
            << "\n"
            << "[Region_1]\n"
            << "Count=2\n"
            << "0_Title=Old Admin\n"
            << "0_Address=192.168.1.10\n"
            << "1_Title=Extra Old\n"
            << "1_Address=192.168.1.11\n"
            << "\n"
            << "[Region_2]\n"
            << "Count=1\n"
            << "0_Title=User Server\n"
            << "0_Address=172.16.0.1\n";
    }

    UpdateServerListOnlineRegion(default_path.wstring(), local_path.wstring());

    wchar_t val[100];
    GetPrivateProfileStringW(L"List", L"RegionCount", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"3");

    GetPrivateProfileStringW(L"List", L"Region_0", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"Server Recent");

    GetPrivateProfileStringW(L"List", L"Region_1", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"Server Online");

    GetPrivateProfileStringW(L"List", L"Region_2", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"Local Editable");

    GetPrivateProfileStringW(L"Region_1", L"Count", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"1");

    GetPrivateProfileStringW(L"Region_1", L"0_Title", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"Admin Online");

    GetPrivateProfileStringW(L"Region_1", L"0_Address", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"10.0.0.1");

    GetPrivateProfileStringW(L"Region_1", L"1_Title", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val).empty());

    GetPrivateProfileStringW(L"Region_2", L"Count", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"1");

    GetPrivateProfileStringW(L"Region_2", L"0_Title", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"User Server");

    GetPrivateProfileStringW(L"Region_2", L"0_Address", L"", val, 100, local_path.wstring().c_str());
    assert(std::wstring(val) == L"172.16.0.1");

    std::filesystem::remove_all(temp_dir);

    std::cout << "All UpdateServerListOnlineRegion tests passed successfully!" << std::endl;
}

int main() {
    try {
        TestCompareSemanticVersion();
        TestUrlEncode();
        TestManifestUpdaterAndHash();
        TestLauncherSelfUpdateSelection();
        TestMergeIniFiles();
        TestUpdateServerListOnlineRegion();
    } catch (const std::exception& e) {
        std::cerr << "Test failed with exception: " << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "Test failed with unknown error" << std::endl;
        return 1;
    }
    return 0;
}


