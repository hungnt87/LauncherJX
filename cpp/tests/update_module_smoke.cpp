#include "update.h"

#include <filesystem>
#include <fstream>
#include <iostream>

int main() {
    namespace fs = std::filesystem;

    const fs::path temp_root = fs::temp_directory_path() / "launcherjx-update-smoke";
    const fs::path launcher_res = temp_root / "launcher_res";
    fs::create_directories(launcher_res);

    const fs::path payload_path = launcher_res / "payload.bin";
    {
        std::ofstream out(payload_path, std::ios::binary);
        out << "abc";
    }

    const fs::path manifest_path = temp_root / "version.json";
    {
        std::ofstream out(manifest_path, std::ios::binary);
        out << R"json({
  "version": "v1.0.1",
  "files": [
    { "name": "payload.bin", "hash": "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad" }
  ]
})json";
    }

    std::ifstream manifest_file(manifest_path);
    const std::string manifest_content{
        std::istreambuf_iterator<char>(manifest_file),
        std::istreambuf_iterator<char>()
    };

    launcher::update::ManifestSource source;
    source.path = manifest_path.wstring();
    source.content = manifest_content;

    launcher::update::Manifest manifest;
    std::string error;
    if (!launcher::update::ParseManifest(source, &manifest, &error)) {
        std::cerr << error << "\n";
        return 1;
    }

    if (manifest.version != "v1.0.1" || manifest.files.size() != 1) {
        std::cerr << "manifest parse mismatch\n";
        return 1;
    }

    if (launcher::update::ComputeSha256(payload_path.wstring()) !=
        "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad") {
        std::cerr << "sha256 mismatch\n";
        return 1;
    }

    const auto pending = launcher::update::CollectFilesToUpdate(temp_root.wstring(), manifest);
    if (!pending.empty()) {
        std::cerr << "expected no pending files\n";
        return 1;
    }

    return 0;
}
