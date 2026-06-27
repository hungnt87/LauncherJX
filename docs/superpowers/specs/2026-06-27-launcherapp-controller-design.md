# Thiet ke: Tach LauncherApp controller

## Muc tieu

Tach lifecycle, snapshot state, va update worker ra khoi `cpp/src/ui.cpp` vao mot controller trung tam `LauncherApp`.
Sau pha nay, UI chi con render va goi hanh dong, con `LauncherApp` giu thread, state, va vong doi update.

## Pham vi

- Them controller `LauncherApp` cho update lifecycle.
- Di chuyen running flag, snapshot state, va worker thread vao controller.
- Di chuyen parse `version.json` va khoi tao state ban dau vao controller.
- De `ui.cpp` chi render, doc snapshot, va phat tin hieu `UPDATE` / `PLAY`.
- De `main.cpp` tao controller, khoi tao UI, chay render loop, va shutdown sach.
- Cap nhat CMake de build them source moi neu can.
- Khong doi update algorithm.
- Khong doi giao dien, asset, hay layout UI.
- Khong doi build refactor da lam o pha truoc ngoai viec them source moi.

## Trang thai hien tai

Hien tai `cpp/src/ui.cpp` dang giu nhieu trach nhiem:

- lay duong dan executable;
- doc `version.json`;
- parse manifest;
- quan ly `std::thread` cho update;
- giu `UpdateSnapshot` bang mutex;
- render UI.

`cpp/src/main.cpp` chi bootstrap Win32 / DX11 / ImGui va goi `InitUI`, `RenderUI`, `CleanupUI`.
Dieu nay lam UI file to va kho tai su dung khi update lifecycle thay doi.

## Kien truc muc tieu

### 1. `LauncherApp` la controller trung tam

`LauncherApp` la lop so huu tat ca state lien quan den update flow.
No giu:

- `std::atomic<bool>` running flag;
- `std::thread` update worker;
- `launcher::update::UpdateSnapshot` hien tai;
- `std::mutex` bao ve snapshot;
- `std::wstring` exe directory;
- `std::string` version string;
- logic khoi tao, start update, va shutdown.

Public API muc tieu:

```cpp
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
};
```

`Initialize()` doc `version.json`, parse manifest, va dat `VersionString()` hoac snapshot loi neu manifest khong hop le.
`StartUpdate()` chay worker trong controller, khong con nam trong UI.
`Shutdown()` join thread an toan va khong nem exception.

### 2. `ui.cpp` chi render

`ui.cpp` van giu:

- texture loading;
- ImGui font/style setup;
- rendering toan bo launcher UI;
- cleanup texture va graphics-side state.

`ui.cpp` khong con:

- own worker thread;
- own snapshot mutex;
- parse manifest;
- doc `version.json` cho logic update;
- quyet dinh file nao can update.

`RenderUI(LauncherApp& app)` se:

- doc snapshot tu app;
- doc version string tu app;
- goi `app.StartUpdate()` khi user bam `UPDATE`;
- hien `PLAY` khi snapshot phase la `Done`.

### 3. `main.cpp` la bootstrapper

`main.cpp` chi:

- tao `LauncherApp`;
- lay duong dan executable hoac de app cung cap;
- goi `app.Initialize(...)`;
- khoi tao UI backend;
- chay render loop;
- khi thoat, goi `app.Shutdown()` truoc khi huy UI/graphics backend.

Muc tieu la de lifecycle cap cao nam o `main.cpp`, con lifecycle cua update flow nam o `LauncherApp`.

## Data flow

1. `main.cpp` tao `LauncherApp`.
2. `LauncherApp::Initialize()` doc `version.json` va dat state ban dau.
3. `InitUI()` load texture va style.
4. `RenderUI(app)` doc snapshot va version string tu `LauncherApp`.
5. Khi bam `UPDATE`, `RenderUI` goi `app.StartUpdate()`.
6. Worker thread trong `LauncherApp` chay update flow va cap nhat snapshot.
7. Khi thoat app, `LauncherApp::Shutdown()` join thread an toan.

## Error handling

- Neu `version.json` khong doc duoc, `LauncherApp::Initialize()` dat snapshot `Error` voi message ngan, de UI van mo va hien thi trang thai loi.
- Neu parse manifest that bai, controller giu message loi tu update module.
- Neu update worker gap loi file/hash, controller cap nhat snapshot loi hoac ket thuc voi trang thai phu hop.
- `Shutdown()` phai `noexcept` ve mat hanh vi quan sat: khong nem ra ngoai, luon join thread neu co.

## Pham vi file

- Tao: `cpp/include/launcher_app.h`
- Tao: `cpp/src/launcher_app.cpp`
- Modify: `cpp/include/ui.h`
- Modify: `cpp/src/ui.cpp`
- Modify: `cpp/src/main.cpp`
- Modify: `cpp/CMakeLists.txt`

## Test surface

### Nen test

- Build `LauncherJX` sau khi them controller.
- Chay app va bam `UPDATE` de xac nhan progress/status van hoat dong.
- Dong app trong luc worker dang chay de xac nhan khong treo va thread duoc join sach.
- Xac nhan `PLAY` van xuat hien khi snapshot chuyen sang `Done`.

### Khong can test trong pha nay

- Doi algorithm checksum.
- Doi parser manifest.
- Doi layout, mau sac, hay asset loading.

## Tieu chi hoan thanh

- `ui.cpp` khong con giu thread update hoac snapshot mutex.
- `LauncherApp` giu update lifecycle, state, va worker thread.
- `main.cpp` dieu phoi controller + UI ro rang.
- Build van thanh cong va app chay nhu cu.
- Hanh vi nguoi dung thay duoc giu nguyen.

## Khong nam trong pha nay

- Tach `LauncherView` rieng.
- Doi update algorithm.
- Doi resource pipeline.
- Doi CMake target layout ngoai nhung source moi can thiet cho controller.

## Ghi chu cho pha sau

Sau khi controller on dinh, co the tiep tuc chuyen cac helper filesystem / render thu cong thanh cac file nho hon neu UI file van con lon.
Nhung pha nay chi dam bao ranh gioi `LauncherApp` vs `ui.cpp` ro rang truoc da.
