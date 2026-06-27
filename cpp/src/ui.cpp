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
        if (ImGui::BeginTabItem("Thông báo")) {
            ImGui::Spacing();
            if (g_bannerTexture) {
                ImGui::Image(reinterpret_cast<void*>(g_bannerTexture), ImVec2(936, 180));
            } else {
                ImGui::BeginChild("ErrorBanner", ImVec2(936, 180), true);
                ImGui::Text("Không thể tải ảnh wuxia_banner.png");
                ImGui::EndChild();
            }

            ImGui::Spacing();
            static float copyFeedbackTime = 0.0f;
            char copyBtnLabel[64] = "Sao chép thông báo (Copy)";
            if (copyFeedbackTime > 0.0f) {
                copyFeedbackTime -= ImGui::GetIO().DeltaTime;
                strcpy_s(copyBtnLabel, "Đã sao chép! (Copied)");
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

        if (ImGui::BeginTabItem("Cài đặt")) {
            ImGui::Spacing();
            ImGui::BeginChild("SettingsArea", ImVec2(936, 434), true);

            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 1.0f, 1.0f));
            ImGui::Text("== Độ phân giải Game ==");
            ImGui::PopStyleColor();
            ImGui::Separator();
            ImGui::Spacing();

            ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.2f, 1.0f), "Chọn độ phân giải phù hợp với máy tính của bạn:");
            ImGui::Spacing();

            int currentRes = app.GameResolution();
            bool sel800  = (currentRes == 800);
            bool sel1024 = (currentRes == 1024);

            if (ImGui::RadioButton("800 x 600  (tiết kiệm tài nguyên, máy cũ)", sel800)) {
                app.SetGameResolution(800);
            }
            if (ImGui::IsItemHovered())
                ImGui::SetTooltip("Ghi Theme=800 vào config.ini\nvà 0=800.pak vào package.ini");
            ImGui::Spacing();
            if (ImGui::RadioButton("1024 x 768 (đồ họa cao hơn, máy tốt)", sel1024)) {
                app.SetGameResolution(1024);
            }
            if (ImGui::IsItemHovered())
                ImGui::SetTooltip("Ghi Theme=1024 vào config.ini\nvà 0=1024.pak vào package.ini");

            ImGui::Spacing();
            ImGui::Separator();
            ImGui::Spacing();

            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 1.0f, 1.0f));
            ImGui::Text("== Chế độ hiển thị ==");
            ImGui::PopStyleColor();
            ImGui::Separator();
            ImGui::Spacing();

            ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.2f, 1.0f), "Chọn chế độ cửa sổ:");
            ImGui::Spacing();

            bool isFS = app.IsFullScreen();
            bool selWindow     = !isFS;
            bool selFullscreen =  isFS;

            if (ImGui::RadioButton("Cửa sổ (Windowed)", selWindow)) {
                app.SetFullScreen(false);
            }
            if (ImGui::IsItemHovered())
                ImGui::SetTooltip("Ghi FullScreen=0 vào config.ini\nGame chạy trong cửa sổ thông thường");
            ImGui::Spacing();
            if (ImGui::RadioButton("Toàn màn hình (FullScreen)", selFullscreen)) {
                app.SetFullScreen(true);
            }
            if (ImGui::IsItemHovered())
                ImGui::SetTooltip("Ghi FullScreen=1 vào config.ini\nGame chạy toàn màn hình");

            ImGui::Spacing();
            ImGui::Separator();
            ImGui::Spacing();
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.6f, 0.6f, 0.6f, 1.0f));
            ImGui::TextWrapped("* Thay đổi được lưu ngay lập tức vào config.ini và package.ini.");
            ImGui::TextWrapped("* Cần khởi động lại game để áp dụng cài đặt mới.");
            ImGui::PopStyleColor();

            ImGui::EndChild();
            ImGui::EndTabItem();
        }

        if (ImGui::BeginTabItem("JX1Mod")) {
            ImGui::Spacing();
            ImGui::BeginChild("JX1ModArea", ImVec2(936, 434), true);

            auto& s = app.Jx1ModSettings();

            // Macro: checkbox + lưu file + tooltip khi hover
            #define JX1_TOGGLE(label, tip, field, sec, key) \
                { bool v = s.field; \
                  if (ImGui::Checkbox(label, &v)) { s.field = v; app.WriteJx1ModKey(L##sec, L##key, v); } \
                  if (ImGui::IsItemHovered() && (tip)[0] != '\0') ImGui::SetTooltip("%s", tip); }

            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 1.0f, 1.0f));
            ImGui::Text("== Chức năng chính [ChucNang] ==");
            ImGui::PopStyleColor();
            ImGui::Separator();
            ImGui::Spacing();

            ImGui::Columns(2, "jx1cols", false);

            JX1_TOGGLE("Hồi sinh trọn",
                "Cho phép hồi sinh toàn bộ kỹ năng/buff khi nhân vật được hồi sinh.\n[ChucNang] TrungSinh",
                trung_sinh, "ChucNang", "TrungSinh");
            JX1_TOGGLE("Ẩn nữ Kim/Nam/Thủy",
                "Ẩn nhân vật nữ môn phái Kim Cương, Nam Thủy ra khỏi màn hình.\n[ChucNang] AnNuKimNamThuy",
                an_nu_kim_nam_thuy, "ChucNang", "AnNuKimNamThuy");
            JX1_TOGGLE("Hoán đổi giới tính",
                "Hiển thị nhân vật Nam Thủy với hình nữ và ngược lại.\n[ChucNang] NamThuyNuKim",
                nam_thuy_nu_kim, "ChucNang", "NamThuyNuKim");
            JX1_TOGGLE("So sánh trang bị",
                "Hiển thị bảng so sánh trang bị đang mặc khi di chuột vào item.\n[ChucNang] SoSanhTrangBi",
                so_sanh_trang_bi, "ChucNang", "SoSanhTrangBi");
            JX1_TOGGLE("Thông số trang bị",
                "Hiển thị thêm thông số chi tiết (giá trị thuộc tính) của trang bị.\n[ChucNang] ThongSoTrangBi",
                thong_so_trang_bi, "ChucNang", "ThongSoTrangBi");

            ImGui::NextColumn();

            JX1_TOGGLE("Hiển thị thanh máu",
                "Hiển thị thanh máu trực quan trên đầu nhân vật.\n[ChucNang] HienThiThanhMau",
                hien_thi_thanh_mau, "ChucNang", "HienThiThanhMau");
            JX1_TOGGLE("Xếp hạng trên đầu",
                "Hiển thị thứ hạng xếp hạng ngay trên đầu nhân vật trong game.\n[ChucNang] XepHangTrenDau",
                xep_hang_tren_dau, "ChucNang", "XepHangTrenDau");
            JX1_TOGGLE("Liên trạm",
                "Bật chức năng liên trạm - dịch chuyển nhanh giữa các bản đồ.\nReset sau N giây (cấu hình trong [LienTram] ResetTimeout).\n[ChucNang] LienTram",
                lien_tram, "ChucNang", "LienTram");
            JX1_TOGGLE("Thông tin giao dịch",
                "Hiển thị thông tin chi tiết khi giao dịch với người chơi khác.\n[ChucNang] TradeInfo",
                trade_info, "ChucNang", "TradeInfo");

            ImGui::Columns(1);
            ImGui::Spacing();

            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 1.0f, 1.0f));
            ImGui::Text("== Các module mở rộng ==");
            ImGui::PopStyleColor();
            ImGui::Separator();
            ImGui::Spacing();

            ImGui::Columns(2, "jx1cols2", false);

            JX1_TOGGLE("Đường máu Boss",
                "Hiển thị thanh máu Boss khi chiến đấu.\nChỉ hiện khi máu Boss > 100,000.\n[ThanhMauBoss] Enabled",
                thanh_mau_boss, "ThanhMauBoss", "Enabled");
            JX1_TOGGLE("Đường máu NPC",
                "Hiển thị thanh máu NPC thông thường khi chiến đấu.\nTắt hiển thị theo map cấu hình trong [ThanhMauNPC] DisabledMaps.\n[ThanhMauNPC] Enabled",
                thanh_mau_npc, "ThanhMauNPC", "Enabled");
            JX1_TOGGLE("Gộp bảng F3",
                "Gộp tab Tin tức + Thuộc tính lại khi xem bảng F3 nhân vật.\n[F3Merge] Enabled",
                f3_merge, "F3Merge", "Enabled");
            JX1_TOGGLE("Hiệu ứng xung quanh nhân vật",
                "Bật/tắt hiệu ứng hào quang, aura xung quanh nhân vật.\n[HieuUngXungQuanhNV] Enabled",
                hieu_ung_xung_quanh, "HieuUngXungQuanhNV", "Enabled");

            ImGui::NextColumn();

            JX1_TOGGLE("Xếp hạng trong F3",
                "Hiển thị thứ hạng trong F3/Tin tức nhân vật (đọc từ expranking.txt).\nĐộc lập với 'Xếp hạng trên đầu'.\n[XepHangF3] Enabled",
                xep_hang_f3, "XepHangF3", "Enabled");
            JX1_TOGGLE("Thông báo PK",
                "Hiển thị thông báo cuộn khi tiêu diệt hoặc bị tiêu diệt bởi người chơi.\nCấu hình màu, font, định dạng trong [ThongBaoPK].\n[ThongBaoPK] Enable",
                thong_bao_pk, "ThongBaoPK", "Enable");
            JX1_TOGGLE("Popup cộng điểm",
                "Đổi vị trí popup 'Tăng số điểm' khi Ctrl+click nút cộng điểm nhân vật.\nCấu hình OffsetX/OffsetY trong [AddPointPopup].\n[AddPointPopup] Enabled",
                add_point_popup, "AddPointPopup", "Enabled");

            ImGui::Columns(1);
            ImGui::Spacing();

            #undef JX1_TOGGLE

            ImGui::Separator();
            ImGui::Spacing();
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.6f, 0.6f, 0.6f, 1.0f));
            ImGui::TextWrapped("* Thay đổi được lưu ngay lập tức vào JX1Mod.ini. Di chuột vào mỗi tùy chọn để xem mô tả.");
            ImGui::TextWrapped("* Cần khởi động lại game để áp dụng.");
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
        display_msg = "Hệ thống đã sẵn sàng. Bấm CẬP NHẬT để cập nhật game.";
    } else if (snapshot.phase == launcher::update::UpdatePhase::Checking) {
        display_msg = "Đang kiểm tra bản cập nhật...";
    } else if (snapshot.phase == launcher::update::UpdatePhase::Done) {
        display_msg = "Cập nhật hoàn tất! Hệ thống đã sẵn sàng.";
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
        if (ImGui::Button("CẬP NHẬT", ImVec2(120, 36))) {
            app.StartUpdate();
        }
    } else if (snapshot.phase == launcher::update::UpdatePhase::Checking || snapshot.phase == launcher::update::UpdatePhase::Downloading) {
        ImGui::BeginDisabled();
        ImGui::Button("ĐANG CẬP NHẬT...", ImVec2(120, 36));
        ImGui::EndDisabled();
    } else if (snapshot.phase == launcher::update::UpdatePhase::Done) {
        if (ImGui::Button("VÀO GAME", ImVec2(120, 36))) {
            MessageBoxW(g_hWnd, L"Đang khởi chạy game Võ Lâm Truyền Kỳ! Chúc đại hiệp chơi game vui vẻ.", L"LauncherJX", MB_OK | MB_ICONINFORMATION);
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
