#pragma once

#include <windows.h>
#include <d3d11.h>

class LauncherApp;

void InitUI(ID3D11Device* device, ID3D11DeviceContext* context, HWND hWnd);
void RenderUI(LauncherApp& app);
void CleanupUI();
