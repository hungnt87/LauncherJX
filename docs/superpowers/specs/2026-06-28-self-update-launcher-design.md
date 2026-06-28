# Thiết kế Self-Update cho LauncherJX

Tài liệu này mô tả thiết kế chức năng tự cập nhật chính nó cho LauncherJX. Mục tiêu là cho phép launcher tự cập nhật file `LauncherJX.exe` ngay khi mở ứng dụng, trong khi các file game khác vẫn giữ luồng cập nhật thủ công như hiện tại.

## 1. Mục tiêu

1. Launcher tự kiểm tra bản mới ngay khi khởi động.
2. Nếu có bản mới của chính `LauncherJX.exe`, launcher sẽ ưu tiên cập nhật trước khi vào UI chính.
3. Khi update launcher, chương trình vẫn hiển thị màn hình chờ trong lúc tải file mới.
4. Khi đến bước thay thế file đang chạy, launcher sẽ tự đóng và chuyển quyền cho `updater.exe`.
5. `updater.exe` là công cụ riêng chịu trách nhiệm thay file, kiểm tra hash, rồi mở lại launcher mới.
6. Nếu máy chưa có `updater.exe`, launcher sẽ tự tải từ release asset.
7. `LauncherJX.exe` phải kiểm tra SHA-256 của `updater.exe` trước khi chạy nó.
8. `updater.exe` phải kiểm tra SHA-256 của `LauncherJX.exe` mới trước khi thay thế.
9. Các file game khác không tự cài đặt; người dùng vẫn bấm nút cập nhật như hiện tại.

## 2. Phạm vi

### Trong phạm vi

- Kiểm tra version khi launcher mở.
- Tải metadata update từ `version.json` của release mới nhất.
- Nhận diện file launcher mới và file updater.
- Tải `updater.exe` nếu thiếu hoặc hash không khớp.
- Tải `LauncherJX.exe.new` vào thư mục tạm.
- Khởi chạy `updater.exe` để replace file đang chạy.
- Giữ luồng update thủ công cho các file còn lại.

### Ngoài phạm vi

- Không tự động cập nhật toàn bộ file game không phải `exe`.
- Không xây hệ thống delta patch.
- Không thay đổi cách launch game chính.
- Không thiết kế update đa nền tảng.

## 3. Hiện trạng

Codebase hiện đã có:

- `LauncherApp::Initialize()` để khởi tạo và kiểm tra bản phát hành hiện tại.
- `RunCheckWorker()` để tải `version.json` và so sánh version.
- `RunUpdateWorker()` để tải/cài đặt các file game còn thiếu hoặc lệch hash.
- `CollectFilesToUpdate()` để quét các file cần cập nhật theo manifest.
- `DownloadFile()` và `UnzipFile()` để tải và giải nén gói cập nhật.

Luồng hiện tại cài đặt trực tiếp các file trong thư mục ứng dụng. Cách này không phù hợp cho file đang chạy trên Windows, nên self-update cần tách ra thành `updater.exe`.

## 4. Kiến trúc đề xuất

### 4.1 Thành phần

- `LauncherJX.exe`: điều phối kiểm tra update, quyết định có self-update hay không, và khởi động `updater.exe` khi cần.
- `updater.exe`: chương trình phụ ngoài tiến trình, chỉ xử lý thay thế `LauncherJX.exe` và relaunch.
- `version.json`: manifest release chứa version, danh sách file, và metadata cho updater.
- `tools/generate_manifest.py`: script sinh manifest cần mở rộng để ghi thêm thông tin về updater asset.

### 4.2 Nguyên tắc

- Không ghi đè trực tiếp file `.exe` đang chạy.
- Không dùng script shell tạm thời để replace file.
- Hash là nguồn kiểm tra tin cậy trước khi chạy updater và trước khi thay launcher.
- Bất kỳ bước hash hoặc download nào thất bại đều phải dừng an toàn và giữ launcher hiện tại.

## 5. Cấu trúc dữ liệu

### 5.1 Manifest

`version.json` cần bổ sung metadata cho updater, ngoài trường `version` và `files`.

Đề xuất thêm một khối tùy chọn:

```json
{
  "version": "v1.2.3",
  "updater": {
    "name": "updater.exe",
    "hash": "sha256-of-updater",
    "asset": "updater.exe"
  },
  "files": [
    {
      "name": "LauncherJX.exe",
      "hash": "sha256-of-launcher-exe",
      "zip": ""
    }
  ]
}
```

Ghi chú:

- `updater.asset` là tên asset trên GitHub Release.
- `updater.hash` là SHA-256 của binary `updater.exe` tương ứng release đó.
- Trường `files` vẫn dùng cho các file game còn lại.

### 5.2 Trạng thái update

`UpdatePhase` hiện có thể tiếp tục dùng cho phần tải/kiểm tra chung, nhưng cần thêm trạng thái hoặc message riêng để biểu diễn self-update, ví dụ:

- `Checking`
- `Downloading`
- `SelfUpdating`
- `Done`
- `Error`

Nếu không muốn thêm enum mới, có thể dùng `Downloading` và message cụ thể, nhưng `SelfUpdating` giúp UI rõ ràng hơn.

## 6. Luồng chạy

### 6.1 Khởi động launcher

1. `LauncherJX.exe` mở lên và giữ màn hình chờ như hiện tại.
2. Launcher tải `version.json` từ latest release.
3. Nếu tải hoặc parse manifest thất bại, launcher vẫn cho phép vào trạng thái hiện tại với thông báo lỗi phù hợp.
4. Nếu manifest hợp lệ, launcher so sánh version local với version server.

### 6.2 Quyết định self-update

Nếu phát hiện có bản mới của launcher:

1. Launcher kiểm tra file `updater.exe` local.
2. Nếu thiếu hoặc hash không khớp, launcher tải `updater.exe` từ release asset.
3. Launcher tính hash file `updater.exe` vừa có và so với hash trong manifest.
4. Nếu hash đúng, launcher tải `LauncherJX.exe.new` vào thư mục tạm.
5. Launcher tạo tham số cho `updater.exe` bao gồm:
   - đường dẫn launcher hiện tại
   - đường dẫn file mới
   - hash mong đợi của file mới
   - version mới
6. Launcher khởi chạy `updater.exe`.
7. Launcher tự đóng.

### 6.3 Công việc của updater

`updater.exe` chỉ làm các việc sau:

1. Chờ tiến trình launcher cũ thoát hẳn.
2. Kiểm tra SHA-256 của `LauncherJX.exe.new`.
3. Nếu hash khớp, đổi file mới thành `LauncherJX.exe`.
4. Có thể giữ bản backup tạm của `LauncherJX.exe` cũ để phục hồi nếu cần.
5. Mở lại `LauncherJX.exe` mới sau khi replace xong.
6. Nếu hash sai hoặc replace lỗi, báo lỗi và dừng.

### 6.4 Luồng file game khác

Nếu manifest có các file khác ngoài launcher:

1. Launcher giữ cơ chế update hiện tại.
2. Người dùng bấm nút cập nhật như trước.
3. Các file này vẫn được tải, giải nén, và copy đè bởi `LauncherApp::RunUpdateWorker()`.
4. Self-update không can thiệp vào luồng này.

## 7. Xử lý hash

### 7.1 Hash của `updater.exe`

- `LauncherJX.exe` là bên kiểm tra hash `updater.exe`.
- Nếu hash local của updater khác manifest, launcher tải lại updater từ release asset.
- Sau khi tải xong, launcher kiểm tra lại hash trước khi chạy.

### 7.2 Hash của `LauncherJX.exe` mới

- `updater.exe` là bên kiểm tra hash file launcher mới.
- Nếu hash không khớp, updater không replace.
- File sai hash phải bị loại bỏ để tránh khởi động binary không tin cậy.

### 7.3 Tính ổn định của hash

- Mỗi lần build lại launcher, hash của `LauncherJX.exe` có thể thay đổi.
- Vì vậy hash phải được sinh theo từng release/build cụ thể.
- Release manifest là nguồn sự thật cho hash của từng binary.

## 8. Thay đổi mã nguồn dự kiến

### 8.1 `cpp/include/update.h`

- Mở rộng `Manifest` để chứa metadata cho updater.
- Có thể thêm struct riêng như `UpdaterAsset`.
- Cần bổ sung hàm tiện ích để lấy thông tin asset từ manifest.

### 8.2 `cpp/src/update.cpp`

- Bổ sung helper kiểm tra hash file local với hash mong đợi.
- Có thể thêm hàm tạo đường dẫn tạm cho `LauncherJX.exe.new`.
- Giữ nguyên `DownloadFile()` và `UnzipFile()` cho luồng file game hiện tại.

### 8.3 `cpp/include/launcher_app.h`

- Thêm trạng thái/biến điều phối self-update.
- Có thể tách `RunSelfUpdateWorker()` ra khỏi `RunUpdateWorker()`.
- Giữ nguyên worker cập nhật file game khác.

### 8.4 `cpp/src/launcher_app.cpp`

- `Initialize()` sẽ kích hoạt check update sớm ngay khi mở app.
- `RunCheckWorker()` sẽ phân nhánh:
  - có bản launcher mới -> đi vào self-update
  - không có bản launcher mới nhưng có file game lệch hash -> giữ luồng update thủ công
- `RunUpdateWorker()` tiếp tục phục vụ file game còn lại.
- Thêm logic tải, kiểm tra hash, và khởi chạy `updater.exe`.

### 8.5 `tools/generate_manifest.py`

- Bổ sung sinh metadata cho updater asset.
- Có thể ghi sẵn `updater.hash` và tên asset theo release.
- Tiếp tục sinh hash cho các file trong `patch`.

## 9. Xử lý lỗi

1. **Không tải được `version.json`**
   - Không chặn launcher.
   - Hiển thị thông báo sử dụng phiên bản hiện tại.

2. **Không có `updater.exe` và tải lại thất bại**
   - Không tự đóng launcher.
   - Báo lỗi rõ ràng để người dùng biết update không hoàn tất.

3. **Hash của `updater.exe` sai**
   - Không chạy updater.
   - Tải lại từ release asset hoặc báo lỗi nếu vẫn không khớp.

4. **Tải `LauncherJX.exe.new` thất bại**
   - Không đóng launcher.
   - Giữ nguyên phiên bản hiện tại.

5. **Hash của file launcher mới sai**
   - Updater không replace.
   - Không mở launcher mới.

6. **Replace file thất bại**
   - Updater giữ trạng thái lỗi.
   - Nếu dùng backup, có thể phục hồi file cũ.

## 10. Kiểm thử

### 10.1 Unit test

- So sánh version.
- So sánh SHA-256 local với giá trị manifest.
- Parse manifest có thêm trường `updater`.

### 10.2 Tích hợp

- Launcher có bản mới và `updater.exe` đã có sẵn.
- Launcher có bản mới nhưng thiếu `updater.exe`.
- Hash `updater.exe` sai nên phải tải lại.
- Tải `LauncherJX.exe.new` thành công và relaunch thành công.
- Tải `LauncherJX.exe.new` lỗi giữa chừng.
- Replace launcher lỗi do file bị khóa.

### 10.3 Thủ công

- Mở launcher khi đã ở version mới nhất.
- Mở launcher khi có bản launcher mới.
- Mở launcher khi chỉ có file game khác bị lệch hash.
- Xác nhận user vẫn bấm cập nhật thủ công cho file không phải `exe`.

## 11. Tiêu chí hoàn thành

Tính năng được xem là hoàn tất khi:

- Launcher tự phát hiện và ưu tiên self-update cho `LauncherJX.exe`.
- `updater.exe` được tải tự động nếu không có hoặc hash sai.
- Hash của `updater.exe` và file launcher mới đều được kiểm tra trước khi chạy/replace.
- Launcher tự đóng và mở lại bản mới sau khi update launcher thành công.
- Các file game khác vẫn cập nhật theo luồng thủ công hiện có.

