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
    const std::string& ChangelogContent() const noexcept;
    void LoadChangelog();

    int GameResolution() const noexcept;
    void SetGameResolution(int resolution);

    bool IsFullScreen() const noexcept;
    void SetFullScreen(bool fullscreen);

private:
    void RunCheckWorker();
    void RunUpdateWorker();
    void SetSnapshot(const launcher::update::UpdateSnapshot& snapshot);
    void LoadResolutionSettings();
    void SaveResolutionSettings(int resolution);
    void SaveFullScreenSetting(bool fullscreen);

    std::atomic<bool> running_{true};
    mutable std::mutex snapshot_mutex_;
    launcher::update::UpdateSnapshot snapshot_{};
    std::wstring exe_dir_;
    std::string version_string_;
    std::string changelog_content_;
    int game_resolution_ = 1024;
    bool fullscreen_ = false;
    
    launcher::update::Manifest server_manifest_;
    bool has_update_ = false;
    
    std::thread check_thread_;
    std::thread update_thread_;
};
