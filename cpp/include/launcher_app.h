#pragma once

#include <atomic>
#include <mutex>
#include <string>
#include <thread>

#include "update.h"

class LauncherApp {
public:
    LauncherApp();
    ~LauncherApp();

    void Initialize(const std::wstring& exe_dir);
    void StartUpdate();
    void Shutdown() noexcept;

    launcher::update::UpdateSnapshot Snapshot() const;
    const std::wstring& ExecutableDir() const noexcept;
    const std::string& VersionString() const noexcept;

private:
    void RunUpdateWorker();
    void SetSnapshot(const launcher::update::UpdateSnapshot& snapshot);

    std::atomic<bool> running_{true};
    mutable std::mutex snapshot_mutex_;
    launcher::update::UpdateSnapshot snapshot_{};
    std::wstring exe_dir_;
    std::string version_string_;
    std::thread update_thread_;
};
