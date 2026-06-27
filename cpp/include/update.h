#pragma once

#include <string>
#include <vector>

namespace launcher::update {

struct ManifestSource {
    std::wstring path;
    std::string content;
};

struct FileEntry {
    std::string name;
    std::string hash;
};

struct Manifest {
    std::string version;
    std::vector<FileEntry> files;
};

enum class UpdatePhase {
    Idle,
    Checking,
    Downloading,
    Done,
    Error,
};

struct UpdateSnapshot {
    float progress = 0.0f;
    UpdatePhase phase = UpdatePhase::Idle;
    std::string message;
};

bool ParseManifest(const ManifestSource& source, Manifest* out_manifest, std::string* error);
std::string ComputeSha256(const std::wstring& file_path);
std::vector<std::wstring> CollectFilesToUpdate(const std::wstring& exe_dir, const Manifest& manifest);

}  // namespace launcher::update
