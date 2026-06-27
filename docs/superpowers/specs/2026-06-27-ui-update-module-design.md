# Thiết kế: Deepen `cpp/src/ui.cpp` bằng update module riêng

## Mục tiêu

Deepen `cpp/src/ui.cpp` để `RenderUI` chỉ còn nhiệm vụ hiển thị, còn toàn bộ update flow đi vào một module sâu riêng. Mục tiêu là tăng locality, làm seam rõ hơn, và tạo test surface tốt hơn cho phần kiểm tra cập nhật.

## Phạm vi

- Giữ `cpp/src/ui.cpp` làm module điều phối giao diện và worker thread.
- Tách logic update ra module riêng cho:
  - đọc `version.json` từ path + nội dung,
  - parse manifest,
  - so khớp file local bằng `SHA-256`,
  - quyết định danh sách file cần cập nhật,
  - cập nhật state để UI poll.
- Không đổi luồng Win32 / DirectX / ImGui trong lần này.
- Không thêm `current file` hay `error` vào state ban đầu.

## Kiến trúc

### 1. UI module

`cpp/src/ui.cpp` giữ ba nhiệm vụ:

- khởi tạo texture, font, style, và ImGui state;
- render toàn bộ launcher UI;
- sở hữu worker thread của update flow và poll state từ module cập nhật.

UI chỉ đọc một state struct nhỏ gồm:

- `progress`
- `phase`
- `message`

UI không parse JSON, không tính hash, và không quyết định file nào cần tải.

### 2. Update module

Module cập nhật là deep module chứa implementation cho update flow. Nó nhận `version.json` qua cả `path` và `nội dung`, rồi:

- parse `version` và danh sách file;
- chuẩn hóa tên file / path local;
- tính `SHA-256` cho file local;
- so khớp manifest với nội dung local;
- trả ra danh sách file cần cập nhật;
- phát state cho UI theo từng phase.

### 3. Adapter cho dữ liệu

`version.json` là adapter dữ liệu hiện tại. Dữ liệu đi vào module dưới hai dạng:

- path, để test và debug theo filesystem thật;
- nội dung, để test dễ hơn và giảm phụ thuộc vào I/O ở test surface.

`common` chỉ giữ helper nhỏ nếu cần cho chuyển đổi text/path. Không kéo thêm trách nhiệm mới vào `common` trong lần này.

## Seams

- `ui.cpp` -> update module: một seam rõ, UI chỉ poll state.
- update module -> filesystem/hash: một seam nội bộ, để test parse/compare mà không boot UI.
- update module -> manifest input: một seam qua path + nội dung, để locality của test cao hơn.

## Luồng dữ liệu

1. `InitUI` đọc `version.json` từ `launcher_res`.
2. `ui.cpp` truyền path + nội dung vào update module.
3. Update module parse manifest, lấy `version` và `files`.
4. Update module tính `SHA-256` cho các file local tương ứng.
5. Update module trả danh sách file sai hash hoặc thiếu.
6. Worker thread mô phỏng hoặc thực hiện tải từng file, cập nhật `progress`, `phase`, `message`.
7. `RenderUI` poll state và vẽ status text, progress bar, và nút hành động.

## State

State polling giữ đúng 3 trường:

- `progress`: số thực từ `0.0` đến `1.0`
- `phase`: trạng thái rời rạc cho UI
- `message`: chuỗi ngắn hiển thị cho người dùng

Quy ước phase:

- `idle`
- `checking`
- `downloading`
- `done`

`message` mang nội dung người dùng đọc được, ví dụ trạng thái đang kiểm tra hoặc đang tải.

## Hashing

Chuẩn integrity check dùng `SHA-256`.

Lý do:

- tránh yếu điểm của `MD5`;
- vẫn đủ nhẹ cho launcher;
- giữ được lựa chọn bền hơn nếu manifest hoặc backend đổi sau này.

## Xử lý lỗi

- Nếu không đọc được `version.json`, UI vẫn mở và hiển thị trạng thái lỗi ngắn trong `message`.
- Nếu một file không tính được hash, file đó được xem là cần cập nhật.
- Nếu worker thread dừng sớm, `phase` quay về `idle` hoặc giữ `done` tùy trạng thái hoàn tất trước đó.
- Cleanup vẫn join thread trước khi thoát để tránh dangling work.

## Test surface

### Nên test

- parse `version.json` với nội dung hợp lệ;
- parse `version.json` với file list rỗng;
- compare manifest và local file theo `SHA-256`;
- chuyển `phase` theo luồng kiểm tra -> tải -> hoàn tất;
- xử lý lỗi đọc manifest và lỗi hash.

### Không cần test ở vòng này

- render pixel-perfect;
- Win32 window lifecycle;
- DirectX device setup;
- asset loading chi tiết.

## Tiêu chí hoàn thành

- `RenderUI` không còn chứa parse JSON, hash, hay quyết định update file.
- Update flow có một seam rõ giữa UI và logic dữ liệu.
- `SHA-256` thay cho `MD5`.
- State polling chỉ còn `progress`, `phase`, `message`.
- Có đường test cho update logic mà không cần boot toàn bộ UI.

## Ghi chú triển khai

- Worker thread vẫn nằm ở `ui.cpp` theo quyết định đã chốt.
- Nếu sau này update module cần thêm metadata, ưu tiên mở rộng trong update module trước khi chạm vào UI.
- Không mở rộng phạm vi sang host Win32 / CMake trong bản này.
