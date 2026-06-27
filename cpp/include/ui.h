#pragma once

#include <windows.h>
#include <d3d11.h>

void InitUI(ID3D11Device* device, ID3D11DeviceContext* context, HWND hWnd);
void RenderUI();
void CleanupUI();
