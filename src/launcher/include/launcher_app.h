#pragma once

#include <atomic>
#include <mutex>
#include <string>
#include <thread>

#include "update.h"

struct JX1ModSettings {
    // [ChucNang]
    bool trung_sinh           = true;
    bool an_nu_kim_nam_thuy   = true;
    bool nam_thuy_nu_kim      = false;
    bool so_sanh_trang_bi     = true;
    bool thong_so_trang_bi    = false;
    bool hien_thi_thanh_mau   = true;
    bool xep_hang_tren_dau    = true;
    int lien_tram             = 0;
    bool trade_info           = false;
    // Các section riêng
    bool thanh_mau_boss       = false;  // [ThanhMauBoss] Enabled
    bool thanh_mau_npc        = false;  // [ThanhMauNPC]  Enabled
    bool f3_merge             = false;  // [F3Merge]      Enabled
    bool xep_hang_f3          = true;   // [XepHangF3]    Enabled
    bool thong_bao_pk         = false;  // [ThongBaoPK]   Enable
    bool hieu_ung_xung_quanh  = true;   // [HieuUngXungQuanhNV] Enabled
    bool add_point_popup      = false;  // [AddPointPopup] Enabled
};

struct ServerInfo {
    std::string title;
    std::string address;
};

class LauncherApp {
public:
    LauncherApp();
    ~LauncherApp();

    void Initialize(const std::wstring& exe_dir);
    void StartUpdate();
    void Shutdown() noexcept;

    const std::vector<ServerInfo>& GetServerList() const noexcept;
    void SaveServerList(const std::vector<ServerInfo>& servers);
    void LoadServerList();
    void RestoreDefaultServerList(bool overwrite);

    launcher::update::UpdateSnapshot Snapshot() const;
    const std::wstring& ExecutableDir() const noexcept;
    const std::string& VersionString() const noexcept;
    const std::string& ChangelogContent() const noexcept;
    void LoadChangelog();

    int GameResolution() const noexcept;
    void SetGameResolution(int resolution);

    bool IsFullScreen() const noexcept;
    void SetFullScreen(bool fullscreen);

    JX1ModSettings& Jx1ModSettings() noexcept;
    void WriteJx1ModKey(const std::wstring& section, const std::wstring& key, bool value);
    void WriteJx1ModKey(const std::wstring& section, const std::wstring& key, int value);

private:
    void RunCheckWorker();
    void RunUpdateWorker();
    void RunSelfUpdateWorker();
    bool ShouldSelfUpdate(const launcher::update::Manifest& manifest) const;
    bool EnsureUpdaterBinary(const launcher::update::Manifest& manifest, std::wstring* updater_path, std::string* error);
    bool LaunchUpdaterAndExit(const std::wstring& updater_path, const std::wstring& launcher_new_path, const std::string& expected_hash);
    void SetSnapshot(const launcher::update::UpdateSnapshot& snapshot);

    void LoadResolutionSettings();
    void SaveResolutionSettings(int resolution);
    void SaveFullScreenSetting(bool fullscreen);
    void LoadJx1ModSettings();

    std::atomic<bool> running_{true};
    mutable std::mutex snapshot_mutex_;
    launcher::update::UpdateSnapshot snapshot_{};
    std::wstring exe_dir_;
    std::string version_string_;
    std::string changelog_content_;
    int game_resolution_ = 1024;
    bool fullscreen_ = false;
    JX1ModSettings jx1mod_settings_;
    std::vector<ServerInfo> servers_;
    int original_server_count_ = 0;
    
    launcher::update::Manifest server_manifest_;
    bool has_update_ = false;
    
    std::thread check_thread_;
    std::thread update_thread_;
};

