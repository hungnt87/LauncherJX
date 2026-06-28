#include "update.h"
#include <iostream>
#include <cassert>
#include <string>

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

int main() {
    try {
        TestCompareSemanticVersion();
        TestUrlEncode();
        TestManifestUpdaterAndHash();
        TestLauncherSelfUpdateSelection();
    } catch (const std::exception& e) {
        std::cerr << "Test failed with exception: " << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "Test failed with unknown error" << std::endl;
        return 1;
    }
    return 0;
}


