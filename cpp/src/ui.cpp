#include "ui.h"
#include "update.h"
#include "imgui.h"
#include "imgui_impl_win32.h"
#include "imgui_impl_dx11.h"

#include <atomic>
#include <chrono>
#include <fstream>
#include <iterator>
#include <mutex>
#include <string>
#include <thread>

#include <d3d11.h>
#include <gdiplus.h>

namespace {

ID3D11Device* g_pd3dDevice = nullptr;
ID3D11DeviceContext* g_pd3dDeviceContext = nullptr;
HWND g_hWnd = nullptr;

ID3D11ShaderResourceView* g_bannerTexture = nullptr;
ID3D11ShaderResourceView* g_logoTexture = nullptr;
int g_bannerWidth = 0;
int g_bannerHeight = 0;
int g_logoWidth = 0;
int g_logoHeight = 0;

std::string g_versionString = "v1.0.0";
launcher::update::UpdateSnapshot g_updateSnapshot;
std::mutex g_updateSnapshotMutex;
std::atomic<bool> g_appRunning{true};
std::thread g_updateThread;

std::wstring GetExecutablePath() {
    wchar_t buffer[MAX_PATH];
    GetModuleFileNameW(nullptr, buffer, MAX_PATH);
    std::wstring path(buffer);
    const size_t pos = path.find_last_of(L"\\/");
    if (pos != std::wstring::npos) {
        return path.substr(0, pos);
    }
    return L".";
}

launcher::update::UpdateSnapshot GetUpdateSnapshot() {
    std::lock_guard<std::mutex> lock(g_updateSnapshotMutex);
    return g_updateSnapshot;
}

void SetUpdateSnapshot(const launcher::update::UpdateSnapshot& snapshot) {
    std::lock_guard<std::mutex> lock(g_updateSnapshotMutex);
    g_updateSnapshot = snapshot;
}

void UpdateSnapshotProgress(float progress) {
    std::lock_guard<std::mutex> lock(g_updateSnapshotMutex);
    g_updateSnapshot.progress = progress;
}

void UpdateSnapshotPhase(launcher::update::UpdatePhase phase) {
    std::lock_guard<std::mutex> lock(g_updateSnapshotMutex);
    g_updateSnapshot.phase = phase;
}

void UpdateSnapshotMessage(const std::string& message) {
    std::lock_guard<std::mutex> lock(g_updateSnapshotMutex);
    g_updateSnapshot.message = message;
}

std::string ReadFileText(const std::wstring& path) {
    std::ifstream file(path, std::ios::binary);
    if (!file.is_open()) {
        return "";
    }

    return std::string(std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>());
}

bool LoadTextureFromImage(const wchar_t* filename, ID3D11ShaderResourceView** out_srv, int* out_width, int* out_height) {
    Gdiplus::Bitmap bitmap(filename);
    if (bitmap.GetLastStatus() != Gdiplus::Ok) {
        return false;
    }

    const UINT width = bitmap.GetWidth();
    const UINT height = bitmap.GetHeight();

    Gdiplus::BitmapData bitmapData;
    Gdiplus::Rect rect(0, 0, width, height);
    if (bitmap.LockBits(&rect, Gdiplus::ImageLockModeRead, PixelFormat32bppARGB, &bitmapData) != Gdiplus::Ok) {
        return false;
    }

    D3D11_TEXTURE2D_DESC desc;
    ZeroMemory(&desc, sizeof(desc));
    desc.Width = width;
    desc.Height = height;
    desc.MipLevels = 1;
    desc.ArraySize = 1;
    desc.Format = DXGI_FORMAT_B8G8R8A8_UNORM;
    desc.SampleDesc.Count = 1;
    desc.Usage = D3D11_USAGE_DEFAULT;
    desc.BindFlags = D3D11_BIND_SHADER_RESOURCE;

    D3D11_SUBRESOURCE_DATA subResource;
    ZeroMemory(&subResource, sizeof(subResource));
    subResource.pSysMem = bitmapData.Scan0;
    subResource.SysMemPitch = bitmapData.Stride;

    ID3D11Texture2D* pTexture = nullptr;
    HRESULT hr = g_pd3dDevice->CreateTexture2D(&desc, &subResource, &pTexture);
    bitmap.UnlockBits(&bitmapData);
    if (FAILED(hr)) {
        return false;
    }

    D3D11_SHADER_RESOURCE_VIEW_DESC srvDesc;
    ZeroMemory(&srvDesc, sizeof(srvDesc));
    srvDesc.Format = desc.Format;
    srvDesc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE2D;
    srvDesc.Texture2D.MipLevels = 1;

    hr = g_pd3dDevice->CreateShaderResourceView(pTexture, &srvDesc, out_srv);
    pTexture->Release();
    if (FAILED(hr)) {
        return false;
    }

    *out_width = static_cast<int>(width);
    *out_height = static_cast<int>(height);
    return true;
}

}  // namespace

void InitUI(ID3D11Device* device, ID3D11DeviceContext* context, HWND hWnd) {
    g_pd3dDevice = device;
    g_pd3dDeviceContext = context;
    g_hWnd = hWnd;

    const std::wstring exeDir = GetExecutablePath();
    const std::wstring bannerPath = exeDir + L"\\launcher_res\\wuxia_banner.png";
    const std::wstring logoPath = exeDir + L"\\launcher_res\\app_icon.png";

    LoadTextureFromImage(bannerPath.c_str(), &g_bannerTexture, &g_bannerWidth, &g_bannerHeight);
    LoadTextureFromImage(logoPath.c_str(), &g_logoTexture, &g_logoWidth, &g_logoHeight);

    const std::wstring versionPath = exeDir + L"\\launcher_res\\version.json";
    const std::string jsonContent = ReadFileText(versionPath);
    if (!jsonContent.empty()) {
        launcher::update::ManifestSource source;
        source.path = versionPath;
        source.content = jsonContent;

        launcher::update::Manifest manifest;
        std::string error;
        if (launcher::update::ParseManifest(source, &manifest, &error)) {
            g_versionString = manifest.version;
        } else {
            launcher::update::UpdateSnapshot snapshot;
            snapshot.phase = launcher::update::UpdatePhase::Error;
            snapshot.message = error;
            SetUpdateSnapshot(snapshot);
        }
    }

    ImGuiIO& io = ImGui::GetIO();
    io.Fonts->AddFontFromFileTTF("C:\\Windows\\Fonts\\segoeui.ttf", 18.0f, nullptr, io.Fonts->GetGlyphRangesVietnamese());

    ImGuiStyle& style = ImGui::GetStyle();
    style.WindowRounding = 8.0f;
    style.FrameRounding = 4.0f;
    style.PopupRounding = 6.0f;
    style.GrabRounding = 4.0f;
    style.WindowBorderSize = 1.0f;

    style.Colors[ImGuiCol_WindowBg] = ImVec4(0.00f, 0.07f, 0.07f, 0.95f);
    style.Colors[ImGuiCol_ChildBg] = ImVec4(0.00f, 0.12f, 0.12f, 0.50f);
    style.Colors[ImGuiCol_Border] = ImVec4(0.00f, 0.50f, 0.50f, 0.50f);
    style.Colors[ImGuiCol_FrameBg] = ImVec4(0.00f, 0.20f, 0.20f, 0.54f);
    style.Colors[ImGuiCol_FrameBgHovered] = ImVec4(0.00f, 0.40f, 0.40f, 0.40f);
    style.Colors[ImGuiCol_FrameBgActive] = ImVec4(0.00f, 0.50f, 0.50f, 0.67f);
    style.Colors[ImGuiCol_TitleBg] = ImVec4(0.00f, 0.20f, 0.20f, 1.00f);
    style.Colors[ImGuiCol_TitleBgActive] = ImVec4(0.00f, 0.30f, 0.30f, 1.00f);
    style.Colors[ImGuiCol_CheckMark] = ImVec4(0.00f, 1.00f, 1.00f, 1.00f);
    style.Colors[ImGuiCol_SliderGrab] = ImVec4(0.00f, 0.50f, 0.50f, 1.00f);
    style.Colors[ImGuiCol_SliderGrabActive] = ImVec4(0.00f, 0.80f, 0.80f, 1.00f);
    style.Colors[ImGuiCol_Button] = ImVec4(0.00f, 0.37f, 0.37f, 1.00f);
    style.Colors[ImGuiCol_ButtonHovered] = ImVec4(0.00f, 0.50f, 0.50f, 1.00f);
    style.Colors[ImGuiCol_ButtonActive] = ImVec4(0.00f, 0.70f, 0.70f, 1.00f);
    style.Colors[ImGuiCol_Header] = ImVec4(0.00f, 0.30f, 0.30f, 0.55f);
    style.Colors[ImGuiCol_HeaderHovered] = ImVec4(0.00f, 0.50f, 0.50f, 0.80f);
    style.Colors[ImGuiCol_HeaderActive] = ImVec4(0.00f, 0.60f, 0.60f, 1.00f);
    style.Colors[ImGuiCol_Tab] = ImVec4(0.00f, 0.25f, 0.25f, 0.86f);
    style.Colors[ImGuiCol_TabHovered] = ImVec4(0.00f, 0.50f, 0.50f, 0.80f);
    style.Colors[ImGuiCol_TabActive] = ImVec4(0.00f, 0.40f, 0.40f, 1.00f);
}

void RenderUI() {
    ImGui::SetNextWindowPos(ImVec2(0, 0));
    ImGui::SetNextWindowSize(ImVec2(960, 600));

    ImGuiWindowFlags windowFlags = ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize |
                                   ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoCollapse |
                                   ImGuiWindowFlags_NoSavedSettings;

    ImGui::Begin("MainLauncher", nullptr, windowFlags);

    ImGui::SetCursorPos(ImVec2(10, 8));
    if (g_logoTexture) {
        ImGui::Image(reinterpret_cast<void*>(g_logoTexture), ImVec2(24, 24));
    }
    ImGui::SameLine();
    ImGui::SetCursorPosY(10);
    const std::string titleText = "LauncherJX - " + g_versionString;
    ImGui::TextColored(ImVec4(0.0f, 1.0f, 1.0f, 1.0f), "%s", titleText.c_str());

    ImGui::SetCursorPos(ImVec2(890, 6));
    if (ImGui::Button("_", ImVec2(26, 26))) {
        ShowWindow(g_hWnd, SW_MINIMIZE);
    }
    ImGui::SameLine();
    ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0.8f, 0.1f, 0.1f, 1.0f));
    if (ImGui::Button("X", ImVec2(26, 26))) {
        PostQuitMessage(0);
    }
    ImGui::PopStyleColor();

    ImGui::Separator();

    ImGui::SetCursorPos(ImVec2(12, 45));
    if (ImGui::BeginTabBar("LauncherTabs")) {
        if (ImGui::BeginTabItem("Thong bao")) {
            ImGui::Spacing();
            if (g_bannerTexture) {
                ImGui::Image(reinterpret_cast<void*>(g_bannerTexture), ImVec2(936, 180));
            } else {
                ImGui::BeginChild("ErrorBanner", ImVec2(936, 180), true);
                ImGui::Text("Could not load wuxia_banner.png");
                ImGui::EndChild();
            }

            ImGui::Spacing();
            ImGui::BeginChild("NewsText", ImVec2(936, 220), true);
            ImGui::TextWrapped("=== JX NEWS ===");
            ImGui::Separator();
            ImGui::BulletText("Open test server on 2026-06-28.");
            ImGui::BulletText("Event: Sword Heroes contest incoming.");
            ImGui::BulletText("Launcher uses Dear ImGui + DX11.");
            ImGui::BulletText("Update flow checks local files before play.");
            ImGui::Spacing();
            ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.2f, 1.0f), "Good luck on the road.");
            ImGui::EndChild();

            ImGui::EndTabItem();
        }

        if (ImGui::BeginTabItem("Cai dat")) {
            ImGui::Spacing();
            ImGui::BeginChild("SettingsArea", ImVec2(936, 434), true);
            ImGui::Text("Graphics & audio");
            ImGui::Separator();
            ImGui::Spacing();

            static int selectedRes = 0;
            ImGui::Text("Game resolution:");
            ImGui::RadioButton("800 x 600 (Default)", &selectedRes, 0);
            ImGui::RadioButton("1024 x 768", &selectedRes, 1);
            ImGui::RadioButton("1280 x 720 (HD)", &selectedRes, 2);

            ImGui::Spacing();
            ImGui::Separator();
            ImGui::Spacing();

            static bool isWindowed = true;
            static bool enableSound = true;
            ImGui::Checkbox("Windowed mode", &isWindowed);
            ImGui::Checkbox("Enable in-game sound", &enableSound);

            ImGui::EndChild();
            ImGui::EndTabItem();
        }
        ImGui::EndTabBar();
    }

    const launcher::update::UpdateSnapshot snapshot = GetUpdateSnapshot();

    ImGui::SetCursorPos(ImVec2(12, 515));
    if (snapshot.phase == launcher::update::UpdatePhase::Idle) {
        ImGui::Text("He thong da san sang. Bam UPDATE de cap nhat game.");
    } else if (snapshot.phase == launcher::update::UpdatePhase::Checking) {
        ImGui::Text("Dang kiem tra ban cap nhat...");
    } else if (snapshot.phase == launcher::update::UpdatePhase::Downloading) {
        ImGui::Text("Dang tai ban cap nhat: %.0f%%", snapshot.progress * 100.0f);
    } else if (snapshot.phase == launcher::update::UpdatePhase::Done) {
        ImGui::TextColored(ImVec4(0.0f, 1.0f, 0.0f, 1.0f), "Cap nhat hoan tat! He thong da san sang.");
    } else if (snapshot.phase == launcher::update::UpdatePhase::Error) {
        ImGui::TextColored(ImVec4(1.0f, 0.4f, 0.2f, 1.0f), "%s", snapshot.message.c_str());
    }

    if (!snapshot.message.empty() && snapshot.phase != launcher::update::UpdatePhase::Error) {
        ImGui::TextWrapped("%s", snapshot.message.c_str());
    }

    ImGui::SetCursorPos(ImVec2(12, 545));
    ImGui::ProgressBar(snapshot.progress, ImVec2(800, 22));

    ImGui::SetCursorPos(ImVec2(828, 535));
    if (snapshot.phase == launcher::update::UpdatePhase::Idle || snapshot.phase == launcher::update::UpdatePhase::Error) {
        if (ImGui::Button("UPDATE", ImVec2(120, 36))) {
            if (g_updateThread.joinable()) {
                g_updateThread.join();
            }

            launcher::update::UpdateSnapshot startSnapshot;
            startSnapshot.progress = 0.0f;
            startSnapshot.phase = launcher::update::UpdatePhase::Checking;
            startSnapshot.message = "Dang kiem tra ban cap nhat...";
            SetUpdateSnapshot(startSnapshot);

            g_updateThread = std::thread([]() {
                const std::wstring exeDir = GetExecutablePath();
                const std::wstring versionPath = exeDir + L"\\launcher_res\\version.json";
                const std::string jsonContent = ReadFileText(versionPath);
                if (jsonContent.empty()) {
                    launcher::update::UpdateSnapshot errorSnapshot;
                    errorSnapshot.phase = launcher::update::UpdatePhase::Error;
                    errorSnapshot.message = "Khong mo duoc version.json";
                    SetUpdateSnapshot(errorSnapshot);
                    return;
                }

                launcher::update::ManifestSource source;
                source.path = versionPath;
                source.content = jsonContent;

                launcher::update::Manifest manifest;
                std::string error;
                if (!launcher::update::ParseManifest(source, &manifest, &error)) {
                    launcher::update::UpdateSnapshot errorSnapshot;
                    errorSnapshot.phase = launcher::update::UpdatePhase::Error;
                    errorSnapshot.message = error;
                    SetUpdateSnapshot(errorSnapshot);
                    return;
                }

                UpdateSnapshotMessage("Dang kiem tra cac file...");
                const auto filesToUpdate = launcher::update::CollectFilesToUpdate(exeDir, manifest);
                if (filesToUpdate.empty()) {
                    launcher::update::UpdateSnapshot doneSnapshot;
                    doneSnapshot.progress = 1.0f;
                    doneSnapshot.phase = launcher::update::UpdatePhase::Done;
                    doneSnapshot.message = "Cap nhat hoan tat! He thong da san sang.";
                    SetUpdateSnapshot(doneSnapshot);
                    return;
                }

                UpdateSnapshotPhase(launcher::update::UpdatePhase::Downloading);
                UpdateSnapshotMessage("Dang tai ban cap nhat...");

                for (size_t idx = 0; idx < filesToUpdate.size(); ++idx) {
                    if (!g_appRunning) {
                        break;
                    }

                    for (int i = 0; i <= 100; ++i) {
                        if (!g_appRunning) {
                            break;
                        }

                        const float progress = (static_cast<float>(idx) + static_cast<float>(i) / 100.0f) /
                                               static_cast<float>(filesToUpdate.size());
                        UpdateSnapshotProgress(progress);
                        std::this_thread::sleep_for(std::chrono::milliseconds(20));
                    }

                    std::ofstream outFile(filesToUpdate[idx], std::ios::binary);
                    if (outFile.is_open()) {
                        outFile << "Phien ban moi nhat da duoc tai xuong.";
                    }
                }

                if (g_appRunning) {
                    launcher::update::UpdateSnapshot doneSnapshot;
                    doneSnapshot.progress = 1.0f;
                    doneSnapshot.phase = launcher::update::UpdatePhase::Done;
                    doneSnapshot.message = "Cap nhat hoan tat! He thong da san sang.";
                    SetUpdateSnapshot(doneSnapshot);
                }
            });
        }
    } else if (snapshot.phase == launcher::update::UpdatePhase::Checking || snapshot.phase == launcher::update::UpdatePhase::Downloading) {
        ImGui::BeginDisabled();
        ImGui::Button("UPDATING...", ImVec2(120, 36));
        ImGui::EndDisabled();
    } else if (snapshot.phase == launcher::update::UpdatePhase::Done) {
        if (ImGui::Button("PLAY", ImVec2(120, 36))) {
            MessageBoxW(g_hWnd, L"Dang khoi chay game Vo Lam Truyen Ky! Chuc dai hiep choi game vui ve.", L"LauncherJX", MB_OK | MB_ICONINFORMATION);
            PostQuitMessage(0);
        }
    }

    ImGui::End();
}

void CleanupUI() {
    g_appRunning = false;
    if (g_updateThread.joinable()) {
        g_updateThread.join();
    }
    if (g_bannerTexture) {
        g_bannerTexture->Release();
        g_bannerTexture = nullptr;
    }
    if (g_logoTexture) {
        g_logoTexture->Release();
        g_logoTexture = nullptr;
    }
}
