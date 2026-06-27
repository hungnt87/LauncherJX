#include "ui.h"

#include <commctrl.h>
#include <string>

namespace {

constexpr wchar_t kWindowClassName[] = L"LauncherJXWindowClass";
constexpr wchar_t kWindowTitle[] = L"Aetheris Launcher";

constexpr UINT_PTR kTabNews = 1001;
constexpr UINT_PTR kTabSettings = 1002;

HWND g_mainWindow = nullptr;
HWND g_tabControl = nullptr;
HWND g_statusText = nullptr;
HWND g_progressBar = nullptr;
HWND g_playButton = nullptr;
HWND g_bannerBox = nullptr;
HWND g_infoText = nullptr;

void ApplyClassicLook(HWND hwnd) {
    SendMessageW(g_progressBar, PBM_SETRANGE, 0, MAKELPARAM(0, 100));
    SendMessageW(g_progressBar, PBM_SETPOS, 15, 0);
    SetWindowTextW(g_statusText, L"Dang kiem tra cap nhat...");
    EnableWindow(g_playButton, FALSE);
}

void LayoutChildren(HWND hwnd) {
    RECT rc = {};
    GetClientRect(hwnd, &rc);

    const int margin = 12;
    const int top = margin;
    const int fullWidth = rc.right - rc.left - (margin * 2);
    const int tabHeight = 28;
    const int bannerHeight = 120;
    const int infoHeight = 54;
    const int statusHeight = 22;
    const int progressHeight = 24;
    const int buttonWidth = 120;
    const int buttonHeight = 34;

    MoveWindow(g_tabControl, margin, top, fullWidth, tabHeight, TRUE);
    MoveWindow(g_bannerBox, margin, top + tabHeight + 10, fullWidth, bannerHeight, TRUE);
    MoveWindow(g_infoText, margin, top + tabHeight + 10 + bannerHeight + 8, fullWidth, infoHeight, TRUE);
    MoveWindow(g_statusText, margin, rc.bottom - margin - statusHeight - progressHeight - 10, fullWidth, statusHeight, TRUE);
    MoveWindow(g_progressBar, margin, rc.bottom - margin - progressHeight - 4, fullWidth - buttonWidth - 14, progressHeight, TRUE);
    MoveWindow(g_playButton, rc.right - margin - buttonWidth, rc.bottom - margin - buttonHeight, buttonWidth, buttonHeight, TRUE);
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
    case WM_CREATE: {
        INITCOMMONCONTROLSEX icc = { sizeof(icc), ICC_TAB_CLASSES | ICC_PROGRESS_CLASS };
        InitCommonControlsEx(&icc);

        g_tabControl = CreateWindowExW(
            0, WC_TABCONTROLW, nullptr,
            WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS,
            0, 0, 0, 0,
            hwnd, reinterpret_cast<HMENU>(1), GetModuleHandleW(nullptr), nullptr);

        TCITEMW tabItem = {};
        tabItem.mask = TCIF_TEXT;
        tabItem.pszText = const_cast<LPWSTR>(L"Thong bao");
        TabCtrl_InsertItem(g_tabControl, 0, &tabItem);
        tabItem.pszText = const_cast<LPWSTR>(L"Cai dat");
        TabCtrl_InsertItem(g_tabControl, 1, &tabItem);

        g_bannerBox = CreateWindowExW(
            WS_EX_CLIENTEDGE, L"STATIC",
            L"Banner / event image placeholder",
            WS_CHILD | WS_VISIBLE | SS_CENTER,
            0, 0, 0, 0,
            hwnd, nullptr, GetModuleHandleW(nullptr), nullptr);

        g_infoText = CreateWindowExW(
            WS_EX_CLIENTEDGE, L"STATIC",
            L"Node: -- | Ping: -- ms | Online: --",
            WS_CHILD | WS_VISIBLE | SS_CENTERIMAGE,
            0, 0, 0, 0,
            hwnd, nullptr, GetModuleHandleW(nullptr), nullptr);

        g_statusText = CreateWindowExW(
            0, L"STATIC",
            L"Dang khoi tao...",
            WS_CHILD | WS_VISIBLE,
            0, 0, 0, 0,
            hwnd, nullptr, GetModuleHandleW(nullptr), nullptr);

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

        ApplyClassicLook(hwnd);
        LayoutChildren(hwnd);
        return 0;
    }
    case WM_SIZE:
        LayoutChildren(hwnd);
        return 0;
    case WM_COMMAND:
        if (LOWORD(wParam) == 2) {
            MessageBoxW(hwnd, L"Chuc nang update se gan sau scaffold.", L"LauncherJX", MB_OK | MB_ICONINFORMATION);
        }
        return 0;
    case WM_CTLCOLORSTATIC: {
        HDC hdc = reinterpret_cast<HDC>(wParam);
        SetBkMode(hdc, TRANSPARENT);
        return reinterpret_cast<LRESULT>(GetSysColorBrush(COLOR_BTNFACE));
    }
    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;
    default:
        return DefWindowProcW(hwnd, msg, wParam, lParam);
    }
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

    ShowWindow(g_mainWindow, showCommand);
    UpdateWindow(g_mainWindow);
    return true;
}

HWND GetMainWindow() {
    return g_mainWindow;
}
