# LauncherJX (Classic Win32 Edition)

**LauncherJX** là một trình khởi chạy game desktop (Game Launcher) gọn nhẹ, hiệu năng cao, được thiết kế dành riêng cho các tựa game MMORPG võ hiệp (ví dụ: Võ Lâm Truyền Kỳ). Giao diện của trình khởi chạy được lấy cảm hứng từ phong cách thiết kế Win32/MFC retro cổ điển của Windows, mang lại cảm giác hoài cổ và thân thuộc cho người chơi.

Dự án được phát triển bằng ngôn ngữ **C++17**, sử dụng thư viện **Dear ImGui** cho phần giao diện người dùng và render thông qua **DirectX 11**, đảm bảo tốc độ phản hồi nhanh chóng và tiêu tốn tối thiểu tài nguyên hệ thống.

---

## 1. Các Tính năng Nổi bật

- **Tự động Sửa lỗi (Auto-Repair):** Quét và so khớp mã băm SHA-256 của tất cả các file game cục bộ với manifest từ xa. Tự động phát hiện và tải lại các file bị hỏng hoặc thiếu.
- **Cấu hình Game & Mod JX1:**
  - Hỗ trợ thay đổi độ phân giải (800x600, 1024x768), chế độ cửa sổ/toàn màn hình trực tiếp ghi vào `config.ini` và `package.ini`.
  - Tab quản lý Mod JX1 với 16 tùy chọn tinh chỉnh nâng cao được ghi vào `JX1Mod.ini`.
- **Tự cập nhật Launcher (Self-Update):** Tự động phát hiện phiên bản mới của launcher, tải xuống chương trình phụ `updater.exe` để thay thế `LauncherJX.exe` một cách an toàn mà không làm gián đoạn người chơi. Có cơ chế Rollback tự động khôi phục bản cũ nếu cập nhật lỗi.
- **Bảo toàn Thiết lập Người chơi:** Cơ chế tự động so sánh các tệp cấu hình thiết lập (`config.ini`, `jx1mod.ini`, `package.ini`) với file gốc mặc định. Nếu phát hiện thiếu Key hoặc Section, launcher sẽ tự động bổ sung phần còn thiếu mà hoàn toàn giữ nguyên giá trị thiết lập hiện tại của người chơi.
- **Chống Khởi chạy Đa cửa sổ:** Sử dụng Windows Named Mutex để đảm bảo chỉ có duy nhất một cửa sổ launcher được chạy tại một thời điểm.

---

## 2. Yêu cầu Hệ thống & Môi trường

Để build và chạy dự án này, máy tính của bạn cần đáp ứng các yêu cầu sau:

- **Hệ điều hành:** Windows 10 hoặc Windows 11.
- **Trình biên dịch:** MSVC (Microsoft Visual C++) đi kèm với **Visual Studio 2022** (đã cài đặt gói _Desktop development with C++_).
- **Công cụ build:** **CMake** phiên bản 3.20 trở lên.
- **Môi trường chạy script:** **Python 3.x** (dùng để chạy công cụ đóng gói cập nhật và sinh manifest).

> [!NOTE]
> Dự án sử dụng tính năng `FetchContent` của CMake để tự động tải thư viện **Dear ImGui** trực tiếp từ GitHub khi cấu hình dự án, do đó bạn không cần phải cài đặt thủ công thư viện này.

---

## 3. Hướng dẫn Build Dự án (Local Build)

Bạn có thể build dự án trực tiếp trên máy tính Windows của mình theo các bước sau:

### Bước 1: Mở Command Prompt hoặc PowerShell tại thư mục gốc của dự án

### Bước 2: Cấu hình CMake (Configure)

Chạy lệnh sau để cấu hình dự án và sinh ra các file build của Visual Studio:

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
```

### Bước 3: Biên dịch dự án (Build)

Biên dịch dự án ở chế độ Release:

```bash
cmake --build build --config Release
```

### Đầu ra sau khi build thành công:

Sau khi build hoàn tất, các tệp thực thi sẽ được xuất ra thư mục `build/bin/Release/`:

- `LauncherJX.exe`: Trình khởi chạy chính của game.
- `updater.exe`: Chương trình phụ trợ xử lý tự động cập nhật LauncherJX.
- `update_tests.exe` & `updater_tests.exe`: Các tệp chạy thử nghiệm unit test cho hệ thống cập nhật.

---

## 4. Quy trình Cập nhật Dữ liệu Patch Game

Hệ thống cập nhật của LauncherJX hoạt động dựa trên cơ chế nén phân đoạn (Zip) và đối chiếu manifest `version.json`.

### Cấu trúc thư mục patch nguồn (`patch/`):

Bạn đặt toàn bộ file game cần cập nhật vào thư mục [patch](file:///d:/1.DEV/2026/LauncherJX/patch). Thư mục này được tổ chức như sau:

- Các thư mục con cấp 1 (như `data/`, `script/`, `settings/`, `spr/`, `ui/`...): Sẽ được nén thành các tệp `.zip` tương ứng (ví dụ: `data.zip`, `script.zip`...) để tăng tốc độ tải và giải nén.
- Các tệp lẻ nằm ở thư mục gốc của `patch/` (như các file `.dll`, `game.exe`, `config.exe`...): Sẽ được tự động đóng gói chung vào tệp `root.zip`.
- Các tệp cấu hình thiết lập của người chơi (`config.ini`, `jx1mod.ini`, `package.ini`): Được bỏ qua khi tính toán mã băm của client để tránh việc ghi đè thiết lập riêng của người chơi khi cập nhật, nhưng vẫn được đóng gói vào `root.zip` để làm dự phòng. Khi cập nhật, LauncherJX sẽ tự động so sánh cấu hình hiện tại của người chơi với file gốc mặc định, nếu phát hiện thiếu Section hoặc Key thì sẽ tự động bổ sung phần còn thiếu đó mà không thay đổi bất kỳ giá trị thiết lập sẵn có nào của người chơi.

### Quy trình cập nhật dữ liệu game & Phát hành (Release Workflow)

Dự án sử dụng **GitHub Actions** kết hợp với script [generate_manifest.py](file:///d:/1.DEV/2026/LauncherJX/tools/generate_manifest.py) để tự động hóa hoàn toàn quy trình đóng gói cập nhật game, sinh mã băm manifest, biên dịch mã nguồn C++, chạy thử nghiệm và phát hành phiên bản mới. 

Nhà phát triển **không cần chạy script đóng gói thủ công ở local**. Quy trình phát hành diễn ra hoàn toàn tự động chỉ với các bước đơn giản sau:

#### Bước 1: Chuẩn bị file cập nhật ở local
Sao chép các file game mới (file cấu hình, map, script, spr, dll...) vào các thư mục tương ứng bên trong thư mục [patch](file:///d:/1.DEV/2026/LauncherJX/patch).

#### Bước 2: Commit và Push code lên nhánh `main`
Đưa các file cập nhật vào hệ thống Git và push lên nhánh `main` của GitHub:
```bash
git add .
git commit -m "update: thêm các file cập nhật game mới"
git push origin main
```

#### Bước 3: Tạo Git Tag và đẩy lên GitHub để kích hoạt Release
Tạo một tag mới đại diện cho phiên bản bạn muốn phát hành (ví dụ: `v1.0.0`) từ nhánh `main` và push lên:
```bash
git tag v1.0.0
git push origin v1.0.0
```

---

## 5. Cơ chế Tự động hóa của GitHub Actions

Sau khi nhận được Git Tag `v*` mới được đẩy lên, GitHub Actions ([release.yml](file:///d:/1.DEV/2026/LauncherJX/.github/workflows/release.yml)) sẽ tự động khởi chạy và thực hiện các nhiệm vụ sau:

1.  **Build & Test:**
    *   Khởi tạo môi trường Windows sạch (`windows-latest`).
    *   Tự động cấu hình và biên dịch mã nguồn C++ ở chế độ Release bằng CMake để tạo ra các file `LauncherJX.exe` và `updater.exe`.
    *   Chạy Smoke Test tự động để đảm bảo các tệp thực thi khởi chạy thành công, không gặp lỗi runtime.
2.  **Đóng gói cập nhật & Sinh Manifest (Tự động):**
    *   Chạy script `generate_manifest.py` với phiên bản tương ứng với tag Git.
    *   Tự động nén các file game trong thư mục `patch/` thành các file `.zip` (`data.zip`, `root.zip`...) và lưu vào thư mục `zips/`.
    *   Tự động băm mã SHA-256 cho `LauncherJX.exe`, `updater.exe` và các tệp cập nhật để ghi vào file manifest `version.json`.
3.  **Tạo GitHub Release:**
    *   Tự động tạo một Release mới tương ứng với tên tag Git vừa push.
    *   Tự động upload toàn bộ tệp thực thi (`LauncherJX.exe`, `updater.exe`), tệp manifest `version.json` và các tệp zip cập nhật game (`zips/*.zip`) lên Release Assets.
4.  **Đồng bộ Manifest (Sync version.json):**
    *   Tự động tải về file `version.json` đã chứa đầy đủ mã hash chính xác của phiên bản vừa đóng gói.
    *   Commit và push tệp `version.json` này ngược lại nhánh `main` để đảm bảo mã nguồn trên kho lưu trữ luôn lưu vết phiên bản mới nhất cùng mã hash chính xác của các tệp thực thi vừa build.

*(Lưu ý: Nếu bạn vẫn muốn chạy script để kiểm tra manifest hoặc tạo tệp zip cục bộ ở máy cá nhân, bạn có thể chạy lệnh: `python tools/generate_manifest.py [tên_phiên_bản]`)*
