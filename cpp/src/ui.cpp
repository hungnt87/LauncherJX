#include "ui.h"

#include <commctrl.h>
#include <string>
#include <thread>
#include <atomic>
#include <gdiplus.h>

namespace {

constexpr wchar_t kWindowClassName[] = L"LauncherJXWindowClass";
constexpr wchar_t kWindowTitle[] = L"Aetheris Launcher";

constexpr wchar_t kNewsContainerClassName[] = L"NewsContainerClass";
constexpr wchar_t kSettingsContainerClassName[] = L"SettingsContainerClass";

constexpr UINT WM_USER_UPDATE_PROGRESS = WM_USER + 1;
constexpr UINT WM_USER_UPDATE_COMPLETE = WM_USER + 2;

HWND g_mainWindow = nullptr;
HWND g_tabControl = nullptr;
HWND g_statusText = nullptr;
HWND g_progressBar = nullptr;
HWND g_playButton = nullptr;

// Containers
HWND g_newsContainer = nullptr;
HWND g_settingsContainer = nullptr;

// Font chung
HFONT g_defaultFont = nullptr;

// Controls cho Tab News (Thong bao)
HWND g_newsTextBox = nullptr;

// Controls cho Tab Settings (Cai dat)
HWND g_settingsGroupBox = nullptr;
HWND g_resRadio1 = nullptr;
HWND g_resRadio2 = nullptr;
HWND g_resRadio3 = nullptr;
HWND g_windowedCheckbox = nullptr;
HWND g_soundCheckbox = nullptr;

// Đa luong
std::atomic<bool> g_appRunning{true};
std::thread g_updateThread;

void UpdateProcessWorker(HWND mainWindow) {
    for (int i = 0; i <= 100; ++i) {
        if (!g_appRunning) {
            break;
        }
        
        PostMessageW(mainWindow, WM_USER_UPDATE_PROGRESS, static_cast<WPARAM>(i), 0);
        std::this_thread::sleep_for(std::chrono::milliseconds(50));
    }
    
    if (g_appRunning) {
        PostMessageW(mainWindow, WM_USER_UPDATE_COMPLETE, 0, 0);
    }
}

void ApplyClassicLook(HWND hwnd) {
    SendMessageW(g_progressBar, PBM_SETRANGE, 0, MAKELPARAM(0, 100));
    SendMessageW(g_progressBar, PBM_SETPOS, 0, 0);
    SetWindowTextW(g_statusText, L"Hệ thống đã sẵn sàng. Vui lòng bấm UPDATE để cập nhật game.");
    EnableWindow(g_playButton, TRUE);
}

void LayoutChildren(HWND hwnd) {
    RECT rc = {};
    GetClientRect(hwnd, &rc);

    const int margin = 12;
    const int top = margin;
    const int fullWidth = rc.right - rc.left - (margin * 2);
    const int statusHeight = 20;
    const int progressHeight = 22;
    const int buttonWidth = 120;
    const int buttonHeight = 34;

    // Di chuyen Tab Control
    MoveWindow(g_tabControl, margin, top, fullWidth, rc.bottom - margin * 3 - progressHeight - statusHeight, TRUE);

    // Lay vung lam viec cua Tab
    RECT rcTab = { margin, top, margin + fullWidth, top + (rc.bottom - margin * 3 - progressHeight - statusHeight) };
    TabCtrl_AdjustRect(g_tabControl, FALSE, &rcTab);

    // Di chuyen các Container con
    MoveWindow(g_newsContainer, rcTab.left, rcTab.top, rcTab.right - rcTab.left, rcTab.bottom - rcTab.top, TRUE);
    MoveWindow(g_settingsContainer, rcTab.left, rcTab.top, rcTab.right - rcTab.left, rcTab.bottom - rcTab.top, TRUE);

    // Di chuyen các control footer
    MoveWindow(g_statusText, margin, rc.bottom - margin - statusHeight - progressHeight - 6, fullWidth, statusHeight, TRUE);
    MoveWindow(g_progressBar, margin, rc.bottom - margin - progressHeight - 2, fullWidth - buttonWidth - 14, progressHeight, TRUE);
    MoveWindow(g_playButton, rc.right - margin - buttonWidth, rc.bottom - margin - buttonHeight, buttonWidth, buttonHeight, TRUE);
}

// Thu tuc xu ly cho Tab News
LRESULT CALLBACK WndProcNews(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
    case WM_CREATE: {
        g_newsTextBox = CreateWindowExW(
            WS_EX_CLIENTEDGE, L"EDIT",
            L"=== TIN TỨC VÕ LÂM JX ===\r\n\r\n"
            L"1. Khai mở máy chủ thử nghiệm Thái Sơn vào ngày 28/06/2026.\r\n"
            L"2. Sự kiện 'Kiếm Hiệp Tranh Hùng' nhận kỳ trân dị bảo cực hot.\r\n"
            L"3. Hệ thống launcher Win32 classic thế hệ mới hoạt động mượt mà.\r\n"
            L"4. Tự động cập nhật patch mới nhất chỉ với 1 cú click chuột.\r\n\r\n"
            L"Chúc các đại hiệp hành tẩu giang hồ gặp nhiều may mắn!",
            WS_CHILD | WS_VISIBLE | ES_MULTILINE | ES_READONLY | WS_VSCROLL,
            0, 0, 0, 0,
            hwnd, nullptr, GetModuleHandleW(nullptr), nullptr);
        SendMessageW(g_newsTextBox, WM_SETFONT, reinterpret_cast<WPARAM>(g_defaultFont), TRUE);
        return 0;
    }
    case WM_SIZE: {
        RECT rc = {};
        GetClientRect(hwnd, &rc);
        int bannerHeight = 120;
        MoveWindow(g_newsTextBox, 4, bannerHeight + 6, rc.right - rc.left - 8, rc.bottom - rc.top - bannerHeight - 10, TRUE);
        return 0;
    }
    case WM_PAINT: {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hwnd, &ps);
        
        Gdiplus::Graphics graphics(hdc);
        Gdiplus::Image image(L"wuxia_banner.png");
        
        RECT rc = {};
        GetClientRect(hwnd, &rc);
        
        if (image.GetLastStatus() == Gdiplus::Ok) {
            graphics.DrawImage(&image, 4, 4, rc.right - rc.left - 8, 120);
        } else {
            HBRUSH hbrShadow = CreateSolidBrush(RGB(90, 90, 90));
            RECT rcBanner = { 4, 4, rc.right - 4, 124 };
            FillRect(hdc, &rcBanner, hbrShadow);
            DeleteObject(hbrShadow);
            
            SetTextColor(hdc, RGB(255, 255, 255));
            SetBkMode(hdc, TRANSPARENT);
            DrawTextW(hdc, L"Không thể tải ảnh wuxia_banner.png", -1, &rcBanner, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
        }
        
        EndPaint(hwnd, &ps);
        return 0;
    }
    case WM_CTLCOLORSTATIC:
    case WM_CTLCOLOREDIT: {
        HDC hdc = reinterpret_cast<HDC>(wParam);
        SetBkColor(hdc, GetSysColor(COLOR_BTNFACE));
        return reinterpret_cast<LRESULT>(GetSysColorBrush(COLOR_BTNFACE));
    }
    default:
        return DefWindowProcW(hwnd, msg, wParam, lParam);
    }
}

// Thu tuc xu ly cho Tab Settings
LRESULT CALLBACK WndProcSettings(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
    case WM_CREATE: {
        HINSTANCE hInst = GetModuleHandleW(nullptr);
        
        g_settingsGroupBox = CreateWindowExW(
            0, L"BUTTON", L"Cấu hình đồ họa & Âm thanh",
            WS_CHILD | WS_VISIBLE | BS_GROUPBOX,
            0, 0, 0, 0,
            hwnd, nullptr, hInst, nullptr);
        SendMessageW(g_settingsGroupBox, WM_SETFONT, reinterpret_cast<WPARAM>(g_defaultFont), TRUE);

        g_resRadio1 = CreateWindowExW(
            0, L"BUTTON", L"800 x 600 (Mặc định)",
            WS_CHILD | WS_VISIBLE | BS_AUTORADIOBUTTON | WS_GROUP,
            0, 0, 0, 0,
            hwnd, reinterpret_cast<HMENU>(301), hInst, nullptr);
        SendMessageW(g_resRadio1, WM_SETFONT, reinterpret_cast<WPARAM>(g_defaultFont), TRUE);
        SendMessageW(g_resRadio1, BM_SETCHECK, BST_CHECKED, 0);

        g_resRadio2 = CreateWindowExW(
            0, L"BUTTON", L"1024 x 768",
            WS_CHILD | WS_VISIBLE | BS_AUTORADIOBUTTON,
            0, 0, 0, 0,
            hwnd, reinterpret_cast<HMENU>(302), hInst, nullptr);
        SendMessageW(g_resRadio2, WM_SETFONT, reinterpret_cast<WPARAM>(g_defaultFont), TRUE);

        g_resRadio3 = CreateWindowExW(
            0, L"BUTTON", L"1280 x 720 (HD)",
            WS_CHILD | WS_VISIBLE | BS_AUTORADIOBUTTON,
            0, 0, 0, 0,
            hwnd, reinterpret_cast<HMENU>(303), hInst, nullptr);
        SendMessageW(g_resRadio3, WM_SETFONT, reinterpret_cast<WPARAM>(g_defaultFont), TRUE);

        g_windowedCheckbox = CreateWindowExW(
            0, L"BUTTON", L"Chế độ cửa sổ (Windowed)",
            WS_CHILD | WS_VISIBLE | BS_AUTOCHECKBOX,
            0, 0, 0, 0,
            hwnd, reinterpret_cast<HMENU>(304), hInst, nullptr);
        SendMessageW(g_windowedCheckbox, WM_SETFONT, reinterpret_cast<WPARAM>(g_defaultFont), TRUE);
        SendMessageW(g_windowedCheckbox, BM_SETCHECK, BST_CHECKED, 0);

        g_soundCheckbox = CreateWindowExW(
            0, L"BUTTON", L"Bật âm thanh trong game",
            WS_CHILD | WS_VISIBLE | BS_AUTOCHECKBOX,
            0, 0, 0, 0,
            hwnd, reinterpret_cast<HMENU>(305), hInst, nullptr);
        SendMessageW(g_soundCheckbox, WM_SETFONT, reinterpret_cast<WPARAM>(g_defaultFont), TRUE);
        SendMessageW(g_soundCheckbox, BM_SETCHECK, BST_CHECKED, 0);

        return 0;
    }
    case WM_SIZE: {
        RECT rc = {};
        GetClientRect(hwnd, &rc);
        
        MoveWindow(g_settingsGroupBox, 10, 10, rc.right - rc.left - 20, rc.bottom - rc.top - 20, TRUE);
        
        MoveWindow(g_resRadio1, 30, 40, 200, 24, TRUE);
        MoveWindow(g_resRadio2, 30, 70, 200, 24, TRUE);
        MoveWindow(g_resRadio3, 30, 100, 200, 24, TRUE);
        
        MoveWindow(g_windowedCheckbox, 30, 140, 240, 24, TRUE);
        MoveWindow(g_soundCheckbox, 30, 170, 240, 24, TRUE);
        return 0;
    }
    case WM_CTLCOLORSTATIC: {
        HDC hdc = reinterpret_cast<HDC>(wParam);
        SetBkColor(hdc, GetSysColor(COLOR_BTNFACE));
        return reinterpret_cast<LRESULT>(GetSysColorBrush(COLOR_BTNFACE));
    }
    default:
        return DefWindowProcW(hwnd, msg, wParam, lParam);
    }
}

// Thu tuc xu ly cho Cua so chinh
LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
    case WM_CREATE: {
        INITCOMMONCONTROLSEX icc = { sizeof(icc), ICC_TAB_CLASSES | ICC_PROGRESS_CLASS };
        InitCommonControlsEx(&icc);

        // Tao Font he thong dep hon
        g_defaultFont = CreateFontW(16, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE, 
                                    DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, 
                                    DEFAULT_QUALITY, DEFAULT_PITCH | FF_DONTCARE, L"Segoe UI");

        g_tabControl = CreateWindowExW(
            0, WC_TABCONTROLW, nullptr,
            WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS,
            0, 0, 0, 0,
            hwnd, reinterpret_cast<HMENU>(1), GetModuleHandleW(nullptr), nullptr);
        SendMessageW(g_tabControl, WM_SETFONT, reinterpret_cast<WPARAM>(g_defaultFont), TRUE);

        TCITEMW tabItem = {};
        tabItem.mask = TCIF_TEXT;
        tabItem.pszText = const_cast<LPWSTR>(L"Thông báo");
        TabCtrl_InsertItem(g_tabControl, 0, &tabItem);
        tabItem.pszText = const_cast<LPWSTR>(L"Cài đặt");
        TabCtrl_InsertItem(g_tabControl, 1, &tabItem);

        // Tao các container cua so con
        g_newsContainer = CreateWindowExW(
            0, kNewsContainerClassName, nullptr,
            WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS,
            0, 0, 0, 0,
            hwnd, nullptr, GetModuleHandleW(nullptr), nullptr);

        g_settingsContainer = CreateWindowExW(
            0, kSettingsContainerClassName, nullptr,
            WS_CHILD | WS_CLIPSIBLINGS,
            0, 0, 0, 0,
            hwnd, nullptr, GetModuleHandleW(nullptr), nullptr);

        g_statusText = CreateWindowExW(
            0, L"STATIC",
            L"Đang khởi tạo...",
            WS_CHILD | WS_VISIBLE,
            0, 0, 0, 0,
            hwnd, nullptr, GetModuleHandleW(nullptr), nullptr);
        SendMessageW(g_statusText, WM_SETFONT, reinterpret_cast<WPARAM>(g_defaultFont), TRUE);

        g_progressBar = CreateWindowExW(
            0, PROGRESS_CLASSW, nullptr,
            WS_CHILD | WS_VISIBLE,
            0, 0, 0, 0,
            hwnd, nullptr, GetModuleHandleW(nullptr), nullptr);

        g_playButton = CreateWindowExW(
            0, L"BUTTON", L"UPDATE",
            WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON,
            0, 0, 0, 0,
            hwnd, reinterpret_cast<HMENU>(2), GetModuleHandleW(nullptr), nullptr);
        SendMessageW(g_playButton, WM_SETFONT, reinterpret_cast<WPARAM>(g_defaultFont), TRUE);

        ApplyClassicLook(hwnd);
        LayoutChildren(hwnd);
        return 0;
    }
    case WM_SIZE:
        LayoutChildren(hwnd);
        return 0;
    case WM_NOTIFY: {
        LPNMHDR lpnmhdr = reinterpret_cast<LPNMHDR>(lParam);
        if (lpnmhdr->hwndFrom == g_tabControl && lpnmhdr->code == TCN_SELCHANGE) {
            int selectedTab = TabCtrl_GetCurSel(g_tabControl);
            if (selectedTab == 0) {
                ShowWindow(g_newsContainer, SW_SHOW);
                ShowWindow(g_settingsContainer, SW_HIDE);
            } else {
                ShowWindow(g_newsContainer, SW_HIDE);
                ShowWindow(g_settingsContainer, SW_SHOW);
            }
            return 0;
        }
        break;
    }
    case WM_COMMAND:
        if (LOWORD(wParam) == 2) { // Play/Update button
            wchar_t buttonText[32] = {};
            GetWindowTextW(g_playButton, buttonText, 32);
            
            if (wcscmp(buttonText, L"UPDATE") == 0) {
                EnableWindow(g_playButton, FALSE);
                SetWindowTextW(g_statusText, L"Đang tải bản cập nhật...");
                SetWindowTextW(g_playButton, L"UPDATING...");
                
                if (g_updateThread.joinable()) {
                    g_updateThread.join();
                }
                g_updateThread = std::thread(UpdateProcessWorker, hwnd);
            } else if (wcscmp(buttonText, L"PLAY") == 0) {
                MessageBoxW(hwnd, L"Đang khởi chạy game Võ Lâm Truyền Kỳ! Chúc đại hiệp chơi game vui vẻ.", L"LauncherJX", MB_OK | MB_ICONINFORMATION);
                PostQuitMessage(0);
            }
        }
        return 0;
    case WM_USER_UPDATE_PROGRESS: {
        int progress = static_cast<int>(wParam);
        SendMessageW(g_progressBar, PBM_SETPOS, progress, 0);
        
        wchar_t statusBuffer[64] = {};
        swprintf_s(statusBuffer, L"Đang tải bản cập nhật: %d%%", progress);
        SetWindowTextW(g_statusText, statusBuffer);
        return 0;
    }
    case WM_USER_UPDATE_COMPLETE: {
        SetWindowTextW(g_statusText, L"Cập nhật hoàn tất! Hệ thống đã sẵn sàng.");
        SetWindowTextW(g_playButton, L"PLAY");
        EnableWindow(g_playButton, TRUE);
        return 0;
    }
    case WM_CTLCOLORDLG: {
        static HBRUSH hbrTeal = CreateSolidBrush(RGB(0, 128, 128)); // Màu nền chính Teal
        return reinterpret_cast<LRESULT>(hbrTeal);
    }
    case WM_CTLCOLORSTATIC: {
        HDC hdc = reinterpret_cast<HDC>(wParam);
        HWND hwndStatic = reinterpret_cast<HWND>(lParam);
        
        if (hwndStatic == g_statusText) {
            // Chữ trạng thái màu trắng, nền trong suốt đè lên Teal
            SetTextColor(hdc, RGB(255, 255, 255));
            SetBkMode(hdc, TRANSPARENT);
            static HBRUSH hbrTeal = CreateSolidBrush(RGB(0, 128, 128));
            return reinterpret_cast<LRESULT>(hbrTeal);
        }
        
        SetBkColor(hdc, GetSysColor(COLOR_BTNFACE));
        return reinterpret_cast<LRESULT>(GetSysColorBrush(COLOR_BTNFACE));
    }
    case WM_DESTROY:
        g_appRunning = false;
        if (g_updateThread.joinable()) {
            g_updateThread.join();
        }
        if (g_defaultFont) {
            DeleteObject(g_defaultFont);
        }
        PostQuitMessage(0);
        return 0;
    default:
        return DefWindowProcW(hwnd, msg, wParam, lParam);
    }
    return DefWindowProcW(hwnd, msg, wParam, lParam);
}

}  // namespace

bool CreateLauncherWindow(HINSTANCE instance, int showCommand) {
    WNDCLASSEXW wc = {};
    wc.cbSize = sizeof(wc);
    wc.style = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc = WndProc;
    wc.hInstance = instance;
    wc.hCursor = LoadCursorW(nullptr, IDC_ARROW);
    wc.hbrBackground = reinterpret_cast<HBRUSH>(COLOR_BTNFACE + 1);
    wc.lpszClassName = kWindowClassName;

    if (!RegisterClassExW(&wc)) {
        return false;
    }

    // Đăng ký các class container phụ
    WNDCLASSEXW wcNews = {};
    wcNews.cbSize = sizeof(wcNews);
    wcNews.style = CS_HREDRAW | CS_VREDRAW;
    wcNews.lpfnWndProc = WndProcNews;
    wcNews.hInstance = instance;
    wcNews.hCursor = LoadCursorW(nullptr, IDC_ARROW);
    wcNews.hbrBackground = reinterpret_cast<HBRUSH>(COLOR_BTNFACE + 1);
    wcNews.lpszClassName = kNewsContainerClassName;
    RegisterClassExW(&wcNews);

    WNDCLASSEXW wcSettings = {};
    wcSettings.cbSize = sizeof(wcSettings);
    wcSettings.style = CS_HREDRAW | CS_VREDRAW;
    wcSettings.lpfnWndProc = WndProcSettings;
    wcSettings.hInstance = instance;
    wcSettings.hCursor = LoadCursorW(nullptr, IDC_ARROW);
    wcSettings.hbrBackground = reinterpret_cast<HBRUSH>(COLOR_BTNFACE + 1);
    wcSettings.lpszClassName = kSettingsContainerClassName;
    RegisterClassExW(&wcSettings);

    g_mainWindow = CreateWindowExW(
        WS_EX_CLIENTEDGE,
        kWindowClassName,
        kWindowTitle,
        WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX,
        CW_USEDEFAULT, CW_USEDEFAULT, 640, 420,
        nullptr, nullptr, instance, nullptr);

    if (!g_mainWindow) {
        return false;
    }

    // Load và set icon cửa sổ từ app_icon.png thông qua GDI+
    Gdiplus::Bitmap bitmap(L"app_icon.png");
    HICON hIcon = nullptr;
    if (bitmap.GetLastStatus() == Gdiplus::Ok) {
        bitmap.GetHICON(&hIcon);
        if (hIcon) {
            SendMessageW(g_mainWindow, WM_SETICON, ICON_BIG, reinterpret_cast<LPARAM>(hIcon));
            SendMessageW(g_mainWindow, WM_SETICON, ICON_SMALL, reinterpret_cast<LPARAM>(hIcon));
        }
    }

    ShowWindow(g_mainWindow, showCommand);
    UpdateWindow(g_mainWindow);
    return true;
}

HWND GetMainWindow() {
    return g_mainWindow;
}
