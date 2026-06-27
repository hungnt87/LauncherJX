# Thiết kế: Tối ưu CMake/build cho LauncherJX

## Mục tiêu

Làm gọn và rõ build graph của `LauncherJX` trước khi tách kiến trúc C++.
Pha này chỉ tập trung vào CMake, target boundaries, và cách tổ chức nguồn build.
Hành vi runtime phải giữ nguyên.

## Phạm vi

- Giữ root `CMakeLists.txt` đơn giản, chỉ điều phối các subdirectory.
- Làm rõ vai trò của `common/` và `cpp/`.
- Tách target theo trách nhiệm để tránh một executable target ôm toàn bộ nguồn và dependency.
- Giữ asset copy sau build, nhưng gom vào một điểm dễ hiểu.
- Không thay đổi UI, update flow, hay logic runtime trong pha này.
- Không tách tiếp `ui.cpp` / `update.cpp` ở pha này ngoài những thay đổi bắt buộc để build graph sạch hơn.

## Tình trạng hiện tại

Repo đã có các phần sau:

- `common/` chứa helper dùng chung.
- `cpp/` chứa launcher executable, ImGui backend, UI, update logic, và resource copy.
- `cpp/CMakeLists.txt` đang vừa thêm object library cho ImGui, vừa build executable, vừa gắn resource copy, vừa link system libraries.
- `main.cpp`, `ui.cpp`, `update.cpp` đều được nhét thẳng vào một target executable.

Điều này vẫn chạy được, nhưng build graph đang khó đọc và khó mở rộng khi codebase lớn lên.

## Kiến trúc mục tiêu

### 1. Root CMake

Root chỉ giữ:

- `cmake_minimum_required`
- `project`
- chuẩn C++ mặc định
- output directory chung
- `add_subdirectory(common)`
- `add_subdirectory(cpp)`

Root không nên biết chi tiết ImGui, resource copy, hay system libs.

### 2. `common` target

`common/` tiếp tục là static library cho helper dùng chung.
Mục tiêu của target này là giữ các hàm nhỏ, có thể tái sử dụng, và tránh kéo Windows-specific code vào chỗ không cần thiết.

### 3. Launcher application target

`cpp/` nên tách rõ:

- một target cho ImGui backend/object code nếu vẫn cần object library;
- một target cho launcher executable;
- source `main.cpp`, `ui.cpp`, `update.cpp` vẫn có thể nằm cùng executable trong pha này;
- dependency declaration phải rõ, không double-count object source theo kiểu khó đọc.

Mục tiêu không phải là "ít file nhất", mà là "mỗi target có một vai trò rõ".

### 4. Resources

Copy `cpp/resources/*` sau build vẫn giữ nguyên hành vi hiện tại.
Điểm thay đổi là gom phần resource list và custom command vào một block riêng, tránh lẫn với khai báo executable.

## Đề xuất cấu trúc target

Pha này dùng phương án ít rủi ro:

- `common_lib`: static library dùng chung.
- `imgui_objects`: object library chứa ImGui core/backends.
- `LauncherJX`: executable chính.

Nếu cần, có thể thêm một interface target nhỏ cho include paths hoặc compile defs, nhưng chỉ khi nó làm build graph dễ đọc hơn thật sự.

## Quy tắc CMake

- Mỗi target chỉ nên có một vai trò chính.
- Include path nên khai báo ở target cần dùng, không dựa vào hiệu ứng phụ toàn cục.
- Compile definitions nên gắn sát target.
- System libraries nên được link ở target tiêu thụ, không rải ở root.
- Resource copy phải có input list rõ ràng, không phụ thuộc vào trật tự file hệ thống.
- Không thêm bước build phức tạp nếu chưa có nhu cầu rõ.

## Luồng build mục tiêu

1. CMake configure root.
2. `common_lib` build trước.
3. `imgui_objects` build object files của ImGui.
4. `LauncherJX` link executable từ nguồn launcher và object files cần thiết.
5. Sau build, assets được copy sang `bin/launcher_res`.

## Xử lý lỗi và rủi ro

- Nếu resource copy fail, build phải fail rõ ràng thay vì im lặng.
- Nếu target include path thiếu, lỗi phải xuất hiện ở configure/build time, không đợi tới runtime.
- Không đổi runtime behavior để "sửa" build.
- Không chuyển logic UI/update sang nơi khác chỉ để làm CMake đẹp hơn.

## Tiêu chí hoàn thành

- Root CMake chỉ còn vai trò điều phối.
- `cpp/CMakeLists.txt` đọc được theo từng khối trách nhiệm.
- `common` và `cpp` có boundary rõ.
- Build vẫn tạo ra đúng executable như hiện tại.
- Asset copy vẫn hoạt động.
- Không có thay đổi behavior người dùng có thể thấy.

## Không nằm trong pha này

- Tách `ui.cpp` thành nhiều module.
- Tách update flow khỏi UI.
- Đổi thuật toán checksum hay parse manifest.
- Đổi layout, theme, hoặc hành vi UI.

## Ghi chú cho pha sau

Sau khi build graph ổn, pha kế tiếp sẽ tách kiến trúc C++ theo hướng:

- `ui.cpp` chỉ render và poll state;
- update logic đi qua module riêng;
- `main.cpp` chỉ bootstrap Win32/DX11/ImGui.

Pha đó nên có spec riêng để tránh trộn lẫn mục tiêu build với mục tiêu kiến trúc.
