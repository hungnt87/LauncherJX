# Nhật ký thay đổi (Changelog)

Tất cả các thay đổi lớn đối với dự án này sẽ được ghi lại trong tệp này.

## v1.0.7 - 2026-06-30

### Sửa lỗi & Cải tiến
- **Tách biệt danh sách máy chủ Admin và Offline**: Cập nhật hàm `UpdateServerListOnlineRegion` và các unit test liên quan nhằm tách biệt hoàn toàn danh sách máy chủ trực tuyến do Admin quản lý (`Region_1`) và danh sách máy chủ ngoại tuyến tự chỉnh sửa (`Region_2`).

## v1.0.3 - 2026-06-30

### Tính năng nổi bật & Cải tiến
- **Tải trực tiếp serverlist.ini**: Thay đổi cơ chế đồng bộ danh sách máy chủ, hỗ trợ tải trực tiếp tệp `serverlist.ini` từ tài nguyên release (Release Assets) của GitHub thay vì tải toàn bộ gói nén `settings.zip`.

## v1.0.1 - 2026-06-30

### Tính năng nổi bật & Cải tiến

#### 1. Quản lý Máy chủ Độc lập (Region_1 & Region_2)
- **Tách biệt vai trò**: Danh sách máy chủ trong `settings/serverlist.ini` được chia làm 2 vùng riêng biệt:
  - `Region_1` (Offline): Người chơi tự do thêm, sửa, xóa máy chủ offline/LAN của họ trực tiếp trên giao diện Cài đặt.
  - `Region_2` (Online): Danh sách máy chủ trực tuyến chính thức do Admin quản lý.
- **Tự động đồng bộ Online**: Launcher tự động tải và cập nhật đè nội dung máy chủ Online của Admin từ GitHub (`Region_2`) khi khởi động/sửa lỗi game.
- **Bảo toàn cài đặt Offline**: Khi cập nhật game hoặc giải nén bản vá ZIP, hệ thống tự động backup và khôi phục nguyên vẹn toàn bộ máy chủ Offline của người chơi (`Region_1`).

#### 2. Trình chỉnh sửa máy chủ thủ công & Kiểm tra lỗi (Validation)
- **Lưu thủ công**: Loại bỏ cơ chế tự động lưu đĩa liên tục khi gõ phím, tích hợp nút **"Lưu thay đổi"** để người chơi chủ động lưu thiết lập.
- **Kiểm tra tính hợp lệ**: Khi nhấn lưu, launcher sẽ tự động kiểm tra các điều kiện:
  - Tên máy chủ và địa chỉ IP không được để trống.
  - Địa chỉ IP phải đúng định dạng IPv4 số (`A.B.C.D` từ `0.0.0.0` đến `255.255.255.255`).
  - Không được trùng tên máy chủ (không phân biệt chữ hoa/thường) hoặc trùng địa chỉ IP giữa các dòng.
  - Chặn lưu và cảnh báo nếu phát hiện lỗi.
- **Popup thông báo**: Tích hợp Modal Popup trong ImGui hiển thị thông báo Lưu thành công hoặc chi tiết lỗi validation cụ thể để người chơi dễ dàng khắc phục.

#### 3. Tối ưu hóa giao diện (UI)
- **Cột song song hoàn hảo**: Sử dụng `ImGui::Table` để chia giao diện Cài đặt thành 2 cột độc lập song song (bên trái chỉnh đồ họa/hiển thị, bên phải sửa serverlist), khắc phục triệt để lỗi lệch dòng do separator của `ImGui::Columns`.
- **Dọn dẹp nút dư thừa**: Loại bỏ 2 nút khôi phục thủ công "Cập nhật từ Admin" và "Reset mặc định" để giao diện gọn gàng, do quá trình đồng bộ IP Online từ Admin hiện tại đã được thực hiện tự động hoàn toàn.

## v1.0.0 - 2026-06-28

Đây là phiên bản phát hành chính thức đầu tiên (Production-ready) của **LauncherJX**, mang lại một giải pháp khởi chạy game và cập nhật dữ liệu toàn diện cho game MMORPG võ hiệp với phong cách giao diện Win32 Retro hoài cổ.

### Tính năng nổi bật

#### 1. Giao diện & Trải nghiệm Người dùng (Win32 Retro Style)
- **Thiết kế Cổ điển:** Giao diện hoài cổ mang phong cách Win32/MFC kinh điển với tông màu xám (#c0c0c0), các đường viền 3D nổi và chìm, mang lại cảm giác thân thuộc cho người chơi dòng game kiếm hiệp cổ xưa.
- **Quản lý Cấu hình Game:** Tab "Cài đặt" cho phép người chơi dễ dàng thay đổi độ phân giải (800x600, 1024x768), chế độ cửa sổ (Windowed) hoặc toàn màn hình (FullScreen) trực tiếp ghi đè vào các tệp cấu hình game (`config.ini` và `package.ini`).
- **Quản lý Mod JX1:** Tích hợp tab "JX1 Mod" hỗ trợ tới 16 tùy chọn bật/tắt (toggles) tinh chỉnh nâng cao cho game, tương tác trực tiếp qua tệp `JX1Mod.ini`.
- **Đa phương tiện:** Tích hợp icon trò chơi chuyên nghiệp, hiển thị banner phong cảnh võ hiệp hoài cổ trực tiếp trên launcher bằng cách tải ảnh PNG từ tài nguyên EXE thông qua thư viện đồ họa GDI+.
- **Hỗ trợ Tiếng Việt:** Toàn bộ giao diện, nút bấm, thông báo trạng thái cập nhật và thông báo lỗi được việt hóa 100%.

#### 2. Cơ chế Cập nhật Tự động & Sửa lỗi Toàn vẹn (Auto-Update & Auto-Repair)
- **Tải xuống song song đa luồng:** Hỗ trợ tải dữ liệu đồng thời với 4 luồng kết hợp HTTP Keep-Alive, giúp tăng tốc độ cập nhật từ 3 đến 5 lần so với tải tuần tự truyền thống.
- **Tự động Sửa lỗi (Auto-Repair):** Kiểm tra tính toàn vẹn của tất cả các file game bằng cách đối chiếu mã băm SHA-256 nội bộ với file cấu hình manifest. Tự động tải lại và sửa các file bị lỗi hoặc thiếu.
- **Cập nhật phân đoạn dạng ZIP:** Phân chia các gói cập nhật theo thư mục con thành các file zip tương ứng (`data.zip`, `script.zip`, `settings.zip`, `spr.zip`, `ui.zip`) và sử dụng PowerShell chạy ngầm trên Windows để tự động giải nén native.
- **Bảo toàn Cấu hình Người chơi:** Khi cập nhật, LauncherJX tự động đối chiếu các tệp thiết lập cá nhân (`config.ini`, `JX1Mod.ini`, `package.ini`) với file gốc mặc định. Nếu phát hiện thiếu Section hoặc Key, hệ thống sẽ sử dụng Win32 Private Profile APIs để tự động khôi phục và bổ sung cấu hình còn thiếu đó mà hoàn toàn giữ nguyên giá trị thiết lập hiện tại của người chơi.
- **Mã hóa URL thông minh:** Hỗ trợ xử lý mã hóa URL (Percent-Encoding) độc lập với ngôn ngữ hệ thống (locale-independent), đảm bảo tải chính xác các file chứa ký tự tiếng Việt hoặc ký tự đặc biệt.

#### 3. Cơ chế Tự cập nhật Launcher (Self-Update)
- **Tự động Cập nhật Không gián đoạn:** Tích hợp ứng dụng phụ `updater.exe` để thay thế `LauncherJX.exe` một cách an sau khi tải phiên bản launcher mới.
- **Cơ chế Rollback an toàn:** Tự động khôi phục lại Launcher cũ nếu quá trình ghi đè tệp mới hoặc cập nhật file manifest `version.json` xảy ra lỗi.
- **Quản lý Tiến trình an toàn:** Tự động kiểm tra và cưỡng bức tắt tiến trình Launcher cũ (nếu không tự thoát sau 5 giây) trước khi tiến hành cập nhật.
- **Ngăn chặn Đa cửa sổ:** Sử dụng Named Mutex của Windows để ngăn người chơi mở nhiều cửa sổ launcher cùng một lúc.
- **Bảo toàn thời gian của tệp:** Sử dụng Win32 API `GetFileTime`/`SetFileTime` để bảo toàn thời gian tạo/chỉnh sửa của file launcher khi tự cập nhật, tránh gây hiểu nhầm về tính toàn vẹn.

### Sửa lỗi & Tối ưu hóa
- Khắc phục lỗi deadlock khi thoát launcher bằng cách sử dụng `PostMessageW` gửi thông điệp đóng cửa sổ từ luồng chính thay vị gọi trực tiếp `PostQuitMessage` từ luồng cập nhật.
- Sửa lỗi lặp tự động cập nhật vô hạn bằng cách sao chép đúng tệp `version.json` mới vào thư mục gốc sau khi chạy xong updater.
- Khắc phục lỗi cache của CDN GitHub Raw khi tải `CHANGELOG.md` và `version.json` bằng cách thêm tham số truy vấn dấu thời gian (cache-buster query) và các HTTP Header `Cache-Control`/`Pragma` chống lưu đệm trên WinINet.
- Tải file thông báo thay đổi `CHANGELOG.md` trực tiếp vào bộ nhớ RAM qua luồng chạy ngầm để hiển thị trên tab Thông báo thay vì lưu tạm ra file vật lý trên ổ cứng.

### DevOps & Công cụ Phát hành
- **Script Manifest:** Cung cấp công cụ Python `tools/generate_manifest.py` tự động hóa việc tính toán hash SHA-256 các file patch, đóng gói các file zip theo thư mục con, gom file lẻ ở gốc vào `root.zip` và xuất ra manifest `version.json`.
- **Hệ thống CI/CD:** Cấu hình workflow GitHub Actions (`.github/workflows/release.yml`) tự động hóa toàn bộ quy trình:
  - Tự động cấu hình và build mã nguồn C++ ở chế độ Release bằng CMake trên môi trường `windows-latest`.
  - Chạy Smoke Test tự động để kiểm tra tính ổn định của `LauncherJX.exe` và `updater.exe` trước khi đóng gói.
  - Tự động sinh file manifest, đóng gói các file zip cập nhật game.
  - Tự động tạo và phát hành GitHub Release khi đẩy tag `v*` mới lên repo, đính kèm đầy đủ các file thực thi và tệp zip cập nhật, sau đó đồng bộ file `version.json` ngược lại về nhánh `main`.
