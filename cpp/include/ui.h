#pragma once

#include <windows.h>
#include <d3d11.h>

class LauncherApp;

void InitUI(ID3D11Device* device, ID3D11DeviceContext* context, HWND hWnd);
HWND GetMainWindowHandle();
void RenderUI(LauncherApp& app);
void CleanupUI();
