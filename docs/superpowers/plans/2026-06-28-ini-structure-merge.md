# C++ Ini Structure Merge Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bổ sung cơ chế tự động so sánh và hợp nhất (merge) cấu trúc file `.ini` mặc định từ bản cập nhật vào file cấu hình cục bộ của người chơi. Khi phát hiện file cục bộ bị thiếu Section hoặc Key, Launcher sẽ tự động bổ sung chúng với giá trị mặc định mà không ghi đè hay làm thay đổi các giá trị cấu hình hiện có của người chơi.

**Architecture:**
- Xây dựng hàm helper `MergeIniFiles(const std::wstring& default_ini, const std::wstring& local_ini)` bằng cách sử dụng Win32 API (`GetPrivateProfileSectionNamesW`, `GetPrivateProfileStringW`, `WritePrivateProfileStringW`) để đọc/ghi file `.ini`.
- Khi giải nén xong các file cập nhật, thay vì ghi đè file cấu hình cũ của người chơi lên file mới giải nén, Launcher sẽ tiến hành Merge các key thiếu từ file mặc định mới vào file cấu hình cũ của người chơi, sau đó mới áp dụng file đã trộn này vào thư mục game.

**Tech Stack:** C++, Win32 API

## Global Constraints
- Chỉ sử dụng các hàm API chuẩn của Windows, không dùng thư viện ngoài.
- Bảo toàn nguyên vẹn giá trị các Key đã được cấu hình từ trước bởi người chơi.
- Sau khi cập nhật, game và Launcher phải hoạt động bình thường, các test cases phải PASS.

---

### Task 1: Định nghĩa hàm Merge cấu trúc file INI trong launcher_app.cpp

**Files:**
- Modify: [src/launcher/src/launcher_app.cpp](file:///d:/1.DEV/2026/LauncherJX/src/launcher/src/launcher_app.cpp)

- [ ] **Step 1: Thêm hàm helper `MergeIniFiles` vào `src/launcher/src/launcher_app.cpp`**
  Thêm đoạn mã sau vào trong anonymous namespace (hoặc phía trên cùng của file sau các phần include):
  ```cpp
  namespace {
  
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
  
  } // namespace
  ```

---

### Task 2: Áp dụng cơ chế Merge khi phục hồi cấu hình sau cập nhật

**Files:**
- Modify: [src/launcher/src/launcher_app.cpp](file:///d:/1.DEV/2026/LauncherJX/src/launcher/src/launcher_app.cpp)

- [ ] **Step 1: Cập nhật phần phục hồi cấu hình (tại dòng ~450)**
  Thay đổi logic copy đè file backup thành logic Merge:
  ```cpp
              // Khôi phục lại cấu hình của người chơi sau khi giải nén bằng cách Merge cấu trúc mới vào cấu hình cũ
              if (has_backup_config) {
                  MergeIniFiles(local_config, backup_config);
                  std::filesystem::copy_file(backup_config, local_config, std::filesystem::copy_options::overwrite_existing);
                  try { std::filesystem::remove(backup_config); } catch (...) {}
              }
              if (has_backup_jx1mod) {
                  MergeIniFiles(local_jx1mod, backup_jx1mod);
                  std::filesystem::copy_file(backup_jx1mod, local_jx1mod, std::filesystem::copy_options::overwrite_existing);
                  try { std::filesystem::remove(backup_jx1mod); } catch (...) {}
              }
              if (has_backup_package) {
                  MergeIniFiles(local_package, backup_package);
                  std::filesystem::copy_file(backup_package, local_package, std::filesystem::copy_options::overwrite_existing);
                  try { std::filesystem::remove(backup_package); } catch (...) {}
              }
  ```

---

### Task 3: Biên dịch thử nghiệm và xác minh

**Files:**
- Run commands inside `d:\1.DEV\2026\LauncherJX`

- [ ] **Step 1: Biên dịch (Build) dự án**
  Chạy lệnh build:
  ```powershell
  cmake --build build --config Release
  ```
  *Mong đợi:* Dự án biên dịch thành công không gặp lỗi.

- [ ] **Step 2: Chạy kiểm tra bộ test**
  ```powershell
  build\bin\Release\update_tests.exe
  ```
  *Mong đợi:* Bộ test chạy thành công đạt kết quả PASS.
