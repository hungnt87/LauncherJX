#include "ui.h"

#include "launcher_app.h"

#include "imgui.h"
#include "imgui_impl_dx11.h"
#include "imgui_impl_win32.h"

#include <d3d11.h>
#include <gdiplus.h>
#include <sstream>

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

void RenderUI(LauncherApp& app) {
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
    const std::string titleText = "LauncherJX - " + app.VersionString();
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
            static float copyFeedbackTime = 0.0f;
            char copyBtnLabel[64] = "Sao chep thong bao (Copy)";
            if (copyFeedbackTime > 0.0f) {
                copyFeedbackTime -= ImGui::GetIO().DeltaTime;
                strcpy_s(copyBtnLabel, "Da sao chep! (Copied)");
            }

            if (ImGui::Button(copyBtnLabel, ImVec2(220, 26))) {
                ImGui::SetClipboardText(app.ChangelogContent().c_str());
                copyFeedbackTime = 2.0f;
            }
            ImGui::Spacing();

            ImGui::BeginChild("NewsText", ImVec2(936, 184), true); // Điều chỉnh chiều cao từ 220 xuống 184 để nhường chỗ cho nút bấm
            std::istringstream stream(app.ChangelogContent());
            std::string line;
            while (std::getline(stream, line)) {
                if (!line.empty() && line.back() == '\r') {
                    line.pop_back();
                }

                if (line.rfind("## ", 0) == 0) {
                    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 1.0f, 1.0f)); // Màu xanh ngọc (Cyan) cho tiêu đề phiên bản
                    ImGui::TextUnformatted(line.c_str());
                    ImGui::PopStyleColor();
                }
                else if (line.rfind("### ", 0) == 0) {
                    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.8f, 0.2f, 1.0f)); // Màu vàng cam (Gold) cho tiêu đề danh mục
                    ImGui::TextUnformatted(line.c_str());
                    ImGui::PopStyleColor();
                }
                else if (line.rfind("- ", 0) == 0 || line.rfind("* ", 0) == 0) {
                    ImGui::BulletText("%s", line.substr(2).c_str());
                }
                else {
                    ImGui::TextUnformatted(line.c_str());
                }
            }
            ImGui::EndChild();

            ImGui::EndTabItem();
        }

        if (ImGui::BeginTabItem("Cai dat")) {
            ImGui::Spacing();
            ImGui::BeginChild("SettingsArea", ImVec2(936, 434), true);
            
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 1.0f, 1.0f));
            ImGui::Text("== Do phan giai Game (Game Resolution) ==");
            ImGui::PopStyleColor();
            ImGui::Separator();
            ImGui::Spacing();

            ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.2f, 1.0f), "Chon do phan giai phu hop voi may tinh cua ban:");
            ImGui::Spacing();

            int currentRes = app.GameResolution();

            bool sel800  = (currentRes == 800);
            bool sel1024 = (currentRes == 1024);

            if (ImGui::RadioButton("800 x 600  (tiet kiem tai nguyen, may cu)", sel800)) {
                app.SetGameResolution(800);
            }
            ImGui::Spacing();
            if (ImGui::RadioButton("1024 x 768 (do hoa cao hon, may tot)", sel1024)) {
                app.SetGameResolution(1024);
            }

            ImGui::Spacing();
            ImGui::Separator();
            ImGui::Spacing();

            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 1.0f, 1.0f));
            ImGui::Text("== Hien thi (Display Mode) ==");
            ImGui::PopStyleColor();
            ImGui::Separator();
            ImGui::Spacing();

            ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.2f, 1.0f), "Che do hien thi:");
            ImGui::Spacing();

            bool isFS = app.IsFullScreen();
            bool selWindow     = !isFS;
            bool selFullscreen =  isFS;

            if (ImGui::RadioButton("Cua so (Windowed)", selWindow)) {
                app.SetFullScreen(false);
            }
            ImGui::Spacing();
            if (ImGui::RadioButton("Toan man hinh (FullScreen)", selFullscreen)) {
                app.SetFullScreen(true);
            }

            ImGui::Spacing();
            ImGui::Separator();
            ImGui::Spacing();
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.6f, 0.6f, 0.6f, 1.0f));
            ImGui::TextWrapped("* Thay doi duoc ap dung va luu ngay lap tuc vao config.ini (Theme, FullScreen) va package.ini (0=xxx.pak).");
            ImGui::TextWrapped("* Ban can khoi dong lai game de ap dung cai dat moi.");
            ImGui::PopStyleColor();

            ImGui::EndChild();
            ImGui::EndTabItem();
        }

        if (ImGui::BeginTabItem("JX1Mod")) {
            ImGui::Spacing();
            ImGui::BeginChild("JX1ModArea", ImVec2(936, 434), true);

            auto& s = app.Jx1ModSettings();
            // Helper macro giúp tao checkbox + ghi file ngay khi click
            #define JX1_TOGGLE(label, field, sec, key) \
                { bool v = s.field; if (ImGui::Checkbox(label, &v)) { s.field = v; app.WriteJx1ModKey(L##sec, L##key, v); } }

            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 1.0f, 1.0f));
            ImGui::Text("== Chuc nang chinh [ChucNang] ==");
            ImGui::PopStyleColor();
            ImGui::Separator();
            ImGui::Spacing();

            ImGui::Columns(2, "jx1mod_cols", false);

            JX1_TOGGLE("Hoi sinh tron (TrungSinh)",        trung_sinh,          "ChucNang", "TrungSinh");
            JX1_TOGGLE("An nu Kim/Nam/Thuy (AnNuKimNamThuy)", an_nu_kim_nam_thuy, "ChucNang", "AnNuKimNamThuy");
            JX1_TOGGLE("Hoan doi gioi tinh (NamThuyNuKim)", nam_thuy_nu_kim,     "ChucNang", "NamThuyNuKim");
            JX1_TOGGLE("So sanh trang bi (SoSanhTrangBi)",  so_sanh_trang_bi,    "ChucNang", "SoSanhTrangBi");
            JX1_TOGGLE("Thong so trang bi (ThongSoTrangBi)",thong_so_trang_bi,   "ChucNang", "ThongSoTrangBi");

            ImGui::NextColumn();

            JX1_TOGGLE("Hien thi thanh mau (HienThiThanhMau)", hien_thi_thanh_mau, "ChucNang", "HienThiThanhMau");
            JX1_TOGGLE("Xep hang tren dau (XepHangTrenDau)", xep_hang_tren_dau, "ChucNang", "XepHangTrenDau");
            JX1_TOGGLE("Lien tram (LienTram)",                lien_tram,         "ChucNang", "LienTram");
            JX1_TOGGLE("Thong tin giao dich (TradeInfo)",     trade_info,        "ChucNang", "TradeInfo");

            ImGui::Columns(1);
            ImGui::Spacing();

            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 1.0f, 1.0f));
            ImGui::Text("== Cac module mo rong ==");
            ImGui::PopStyleColor();
            ImGui::Separator();
            ImGui::Spacing();

            ImGui::Columns(2, "jx1mod_cols2", false);

            JX1_TOGGLE("Duong mau Boss (ThanhMauBoss)",      thanh_mau_boss,      "ThanhMauBoss",       "Enabled");
            JX1_TOGGLE("Duong mau NPC (ThanhMauNPC)",        thanh_mau_npc,       "ThanhMauNPC",        "Enabled");
            JX1_TOGGLE("Gop bang F3 (F3Merge)",              f3_merge,            "F3Merge",            "Enabled");
            JX1_TOGGLE("Hieu ung xung quanh NV",             hieu_ung_xung_quanh, "HieuUngXungQuanhNV", "Enabled");

            ImGui::NextColumn();

            JX1_TOGGLE("Xep hang trong F3 (XepHangF3)",      xep_hang_f3,         "XepHangF3",          "Enabled");
            JX1_TOGGLE("Thong bao PK (ThongBaoPK)",          thong_bao_pk,        "ThongBaoPK",         "Enable");
            JX1_TOGGLE("Popup cong diem (AddPointPopup)",    add_point_popup,     "AddPointPopup",      "Enabled");

            ImGui::Columns(1);
            ImGui::Spacing();

            #undef JX1_TOGGLE

            ImGui::Separator();
            ImGui::Spacing();
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.6f, 0.6f, 0.6f, 1.0f));
            ImGui::TextWrapped("* Thay doi duoc luu ngay lap tuc vao JX1Mod.ini. Khoi dong lai game de ap dung.");
            ImGui::PopStyleColor();

            ImGui::EndChild();
            ImGui::EndTabItem();
        }
        ImGui::EndTabBar();
    }

    const launcher::update::UpdateSnapshot snapshot = app.Snapshot();

    ImGui::SetCursorPos(ImVec2(12, 485));
    char log_buf[1024] = "";
    std::string display_msg;

    if (snapshot.phase == launcher::update::UpdatePhase::Idle) {
        display_msg = "He thong da san sang. Bam UPDATE de cap nhat game.";
    } else if (snapshot.phase == launcher::update::UpdatePhase::Checking) {
        display_msg = "Dang kiem tra ban cap nhat...";
    } else if (snapshot.phase == launcher::update::UpdatePhase::Done) {
        display_msg = "Cap nhat hoan tat! He thong da san sang.";
    } else if (snapshot.phase == launcher::update::UpdatePhase::Error) {
        display_msg = snapshot.message;
    }

    if (!snapshot.message.empty() && snapshot.phase != launcher::update::UpdatePhase::Error) {
        display_msg = snapshot.message;
    }

    strncpy_s(log_buf, display_msg.c_str(), sizeof(log_buf) - 1);
    log_buf[sizeof(log_buf) - 1] = '\0';

    if (snapshot.phase == launcher::update::UpdatePhase::Error) {
        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.4f, 0.2f, 1.0f)); // Màu cam cho lỗi
    } else if (snapshot.phase == launcher::update::UpdatePhase::Done) {
        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 0.0f, 1.0f)); // Màu xanh lá cho thành công
    } else {
        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 1.0f, 1.0f)); // Màu xanh ngọc cho bình thường
    }

    ImGui::InputTextMultiline("##status_log", log_buf, sizeof(log_buf), ImVec2(800, 50), ImGuiInputTextFlags_ReadOnly);
    ImGui::PopStyleColor();

    ImGui::SetCursorPos(ImVec2(12, 545));
    ImGui::ProgressBar(snapshot.progress, ImVec2(800, 22));

    ImGui::SetCursorPos(ImVec2(828, 535));
    if (snapshot.phase == launcher::update::UpdatePhase::Idle || snapshot.phase == launcher::update::UpdatePhase::Error) {
        if (ImGui::Button("UPDATE", ImVec2(120, 36))) {
            app.StartUpdate();
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
    if (g_bannerTexture) {
        g_bannerTexture->Release();
        g_bannerTexture = nullptr;
    }
    if (g_logoTexture) {
        g_logoTexture->Release();
        g_logoTexture = nullptr;
    }
}
