#include <windows.h>
#include <gdiplus.h>

#include "ui.h"

int WINAPI WinMain(HINSTANCE instance, HINSTANCE, LPSTR, int showCommand) {
    // Khoi tao GDI+
    Gdiplus::GdiplusStartupInput gdiplusStartupInput;
    ULONG_PTR gdiplusToken;
    Gdiplus::GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, nullptr);

    if (!CreateLauncherWindow(instance, showCommand)) {
        MessageBoxW(nullptr, L"Khong the khoi tao launcher.", L"LauncherJX", MB_OK | MB_ICONERROR);
        Gdiplus::GdiplusShutdown(gdiplusToken);
        return 1;
    }

    MSG message = {};
    while (GetMessageW(&message, nullptr, 0, 0)) {
        TranslateMessage(&message);
        DispatchMessageW(&message);
    }

    // Don dep GDI+
    Gdiplus::GdiplusShutdown(gdiplusToken);

    return static_cast<int>(message.wParam);
}
