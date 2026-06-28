# C++ INI Online Repair Structure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bổ sung cơ chế tự động kiểm tra hash SHA-256 các file `.ini` cục bộ khi khởi động. Nếu phát hiện sai khác hash (do bị thiếu key hoặc người chơi sửa đổi), Launcher sẽ tải file gốc từ server về để đối chiếu và sửa cấu trúc (bổ sung key thiếu) mà không ghi đè giá trị cũ của người chơi. Tách biệt logic này vào module `update` (`update.cpp` & `update.h`) để đảm bảo cấu trúc dự án sạch sẽ, dễ bảo trì.

**Architecture:**
- Khai báo và định nghĩa hai hàm `MergeIniFiles` và `CheckAndRepairIniFiles` trong namespace `launcher::update` (file `update.cpp`/`update.h`).
- `CheckAndRepairIniFiles` thực hiện:
  - Duyệt qua 3 file: `config.ini`, `JX1Mod.ini`, `package.ini`.
  - Tính hash cục bộ, so sánh với hash chuẩn trong manifest.
  - Tải file gốc về `tmp/` nếu phát hiện sai khác hash.
  - Gọi `MergeIniFiles` để bổ sung key thiếu vào file cục bộ.
- Trong `launcher_app.cpp`:
  - Gọi `launcher::update::CheckAndRepairIniFiles` trong `RunCheckWorker` ngay sau khi phân tích manifest từ server.
  - Gọi `launcher::update::MergeIniFiles` để hợp nhất cấu trúc trong quy trình phục hồi cấu hình sau cập nhật của `RunUpdateWorker`.

**Tech Stack:** C++, Win32 APIs, Cryptography

## Global Constraints
- Không làm thay đổi giá trị cấu hình tùy biến của người chơi.
- Hoạt động bất đồng bộ trên worker thread để tránh đơ giao diện Launcher.
- Nếu mất kết nối mạng, bỏ qua mượt mà.

---

### Task 1: Định nghĩa cơ chế INI Merge và Repair trong module update

**Files:**
- Modify: [src/launcher/include/update.h](file:///d:/1.DEV/2026/LauncherJX/src/launcher/include/update.h)
- Modify: [src/launcher/src/update.cpp](file:///d:/1.DEV/2026/LauncherJX/src/launcher/src/update.cpp)

- [ ] **Step 1: Khai báo hàm trong `update.h`**
  Thêm khai báo vào cuối `namespace launcher::update` của file [src/launcher/include/update.h](file:///d:/1.DEV/2026/LauncherJX/src/launcher/include/update.h):
  ```cpp
  void MergeIniFiles(const std::wstring& default_ini_path, const std::wstring& local_ini_path);
  bool CheckAndRepairIniFiles(const std::wstring& exe_dir, const Manifest& manifest, const std::atomic<bool>& running);
  ```

- [ ] **Step 2: Định nghĩa hàm trong `update.cpp`**
  Thêm định nghĩa hàm vào cuối file [src/launcher/src/update.cpp](file:///d:/1.DEV/2026/LauncherJX/src/launcher/src/update.cpp) (trước thẻ đóng namespace):
  ```cpp
  void MergeIniFiles(const std::wstring& default_ini_path, const std::wstring& local_ini_path) {
      if (!std::filesystem::exists(default_ini_path)) {
          return;
      }
      if (!std::filesystem::exists(local_ini_path)) {
          try {
              std::filesystem::copy_file(default_ini_path, local_ini_path, std::filesystem::copy_options::overwrite_existing);
          } catch (...) {}
          return;
      }
  
      // 1. Đọc tất cả các Section từ file mặc định
      std::vector<wchar_t> section_names(4096);
      DWORD len = GetPrivateProfileSectionNamesW(section_names.data(), (DWORD)section_names.size(), default_ini_path.c_str());
      while (len == section_names.size() - 2) {
          section_names.resize(section_names.size() * 2);
          len = GetPrivateProfileSectionNamesW(section_names.data(), (DWORD)section_names.size(), default_ini_path.c_str());
      }
  
      std::vector<std::wstring> sections;
      wchar_t* p = section_names.data();
      while (*p) {
          sections.push_back(p);
          p += wcslen(p) + 1;
      }
  
      // 2. Với mỗi Section, đọc tất cả các Key từ file mặc định
      for (const auto& section : sections) {
          std::vector<wchar_t> key_names(4096);
          DWORD key_len = GetPrivateProfileStringW(section.c_str(), nullptr, nullptr, key_names.data(), (DWORD)key_names.size(), default_ini_path.c_str());
          while (key_len == key_names.size() - 2) {
              key_names.resize(key_names.size() * 2);
              key_len = GetPrivateProfileStringW(section.c_str(), nullptr, nullptr, key_names.data(), (DWORD)key_names.size(), default_ini_path.c_str());
          }
  
          std::vector<std::wstring> keys;
          wchar_t* kp = key_names.data();
          while (*kp) {
              keys.push_back(kp);
              kp += wcslen(kp) + 1;
          }
  
          // 3. Với mỗi Key, kiểm tra xem file local đã có chưa. Nếu chưa có, lấy giá trị từ file mặc định và ghi vào file local
          for (const auto& key : keys) {
              wchar_t local_val[1024] = {0};
              const wchar_t* sentinel = L"__INI_KEY_NOT_FOUND__";
              GetPrivateProfileStringW(section.c_str(), key.c_str(), sentinel, local_val, 1024, local_ini_path.c_str());
  
              if (wcscmp(local_val, sentinel) == 0) {
                  wchar_t default_val[1024] = {0};
                  GetPrivateProfileStringW(section.c_str(), key.c_str(), L"", default_val, 1024, default_ini_path.c_str());
                  WritePrivateProfileStringW(section.c_str(), key.c_str(), default_val, local_ini_path.c_str());
              }
          }
      }
  }
  
  bool CheckAndRepairIniFiles(const std::wstring& exe_dir, const Manifest& manifest, const std::atomic<bool>& running) {
      std::wstring branch = (manifest.version.empty() || manifest.version == "v0.0.0") ? L"dev" : Utf8ToWstring(manifest.version);
      std::wstring remote_prefix = L"https://raw.githubusercontent.com/hungnt87/LauncherJX/" + branch + L"/patch/";
  
      std::vector<std::string> special_configs = {"config.ini", "jx1mod.ini", "package.ini"};
      bool any_merged = false;
  
      for (const auto& config_name : special_configs) {
          // Tìm file entry tương ứng trong manifest từ server
          FileEntry target_entry;
          bool found_in_manifest = false;
          for (const auto& f : manifest.files) {
              std::string fname = f.name;
              std::transform(fname.begin(), fname.end(), fname.begin(), ::tolower);
              if (fname == config_name) {
                  target_entry = f;
                  found_in_manifest = true;
                  break;
              }
          }
  
          if (!found_in_manifest) continue;
  
          std::wstring wconfig_name = Utf8ToWstring(target_entry.name);
          std::wstring local_path = (std::filesystem::path(exe_dir) / wconfig_name).wstring();
          std::wstring temp_default_path = (std::filesystem::path(exe_dir) / L"tmp" / (wconfig_name + L".default")).wstring();
  
          // Tính hash thực tế
          std::string local_hash = ComputeSha256(local_path);
          std::transform(local_hash.begin(), local_hash.end(), local_hash.begin(), ::tolower);
          std::string target_hash = target_entry.hash;
          std::transform(target_hash.begin(), target_hash.end(), target_hash.begin(), ::tolower);
  
          // Chỉ tải và merge nếu file bị thiếu hoặc hash thay đổi
          if (local_hash.empty() || local_hash != target_hash) {
              std::string encoded_name = UrlEncode(target_entry.name);
              std::wstring wencoded_name = Utf8ToWstring(encoded_name);
              std::wstring file_url = remote_prefix + wencoded_name;
  
              if (DownloadFile(nullptr, file_url, temp_default_path, running, nullptr)) {
                  MergeIniFiles(temp_default_path, local_path);
                  try { std::filesystem::remove(temp_default_path); } catch (...) {}
                  any_merged = true;
              }
          }
      }
      return any_merged;
  }
  ```

---

### Task 2: Kết nối và dọn dẹp logic trong launcher_app.cpp

**Files:**
- Modify: [src/launcher/src/launcher_app.cpp](file:///d:/1.DEV/2026/LauncherJX/src/launcher/src/launcher_app.cpp)

- [ ] **Step 1: Xóa bỏ định nghĩa `MergeIniFiles` cũ trong `launcher_app.cpp`**
  Xóa bỏ định nghĩa `MergeIniFiles` tạm thời đã được tạo trong anonymous namespace ở đầu file [src/launcher/src/launcher_app.cpp](file:///d:/1.DEV/2026/LauncherJX/src/launcher/src/launcher_app.cpp) (để tránh lỗi định nghĩa trùng).

- [ ] **Step 2: Gọi `CheckAndRepairIniFiles` trong `RunCheckWorker`**
  Tại hàm `LauncherApp::RunCheckWorker()`, ngay sau khi phân tích manifest thành công:
  ```cpp
      if (launcher::update::CheckAndRepairIniFiles(exe_dir_, manifest, running_)) {
          LoadResolutionSettings();
          LoadJx1ModSettings();
      }
  ```

- [ ] **Step 3: Cập nhật hàm gọi `MergeIniFiles` trong `RunUpdateWorker`**
  Trong logic phục hồi cấu hình `.ini` sau khi giải nén zips, chuyển lời gọi `MergeIniFiles(...)` thành `launcher::update::MergeIniFiles(...)`.

---

### Task 3: Biên dịch và xác minh kiểm thử

**Files:**
- Run commands inside `d:\1.DEV\2026\LauncherJX`

- [ ] **Step 1: Biên dịch dự án**
  Chạy build:
  ```powershell
  cmake --build build --config Release
  ```
  *Mong đợi:* Dự án biên dịch thành công 100%.

- [ ] **Step 2: Chạy kiểm thử thủ công**
  1. Xóa một vài key trong `build\bin\Release\package.ini`.
  2. Khởi động `build\bin\Release\LauncherJX.exe`.
  3. Xác nhận: File `package.ini` được tự động điền lại các key thiếu, các key khác không đổi giá trị.
