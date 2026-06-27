#include <windows.h>

#include "ui.h"

int WINAPI WinMain(HINSTANCE instance, HINSTANCE, LPSTR, int showCommand) {
    if (!CreateLauncherWindow(instance, showCommand)) {
        MessageBoxW(nullptr, L"Khong the khoi tao launcher.", L"LauncherJX", MB_OK | MB_ICONERROR);
        return 1;
    }

    MSG message = {};
    while (GetMessageW(&message, nullptr, 0, 0)) {
        TranslateMessage(&message);
        DispatchMessageW(&message);
    }

    return static_cast<int>(message.wParam);
}
