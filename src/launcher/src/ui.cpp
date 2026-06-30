#include "ui.h"

#include "launcher_app.h"

#include "imgui.h"
#include "imgui_impl_dx11.h"
#include "imgui_impl_win32.h"

#include <d3d11.h>
#include <gdiplus.h>
#include <sstream>
#include <shellapi.h>
#include <algorithm>

namespace {

ID3D11Device* g_pd3dDevice = nullptr;
ID3D11DeviceContext* g_pd3dDeviceContext = nullptr;
HWND g_hWnd = nullptr;

bool IsValidIPv4(const std::string& ip) {
    if (ip.empty()) return false;
    
    int num_dots = 0;
    for (char c : ip) {
        if (c == '.') num_dots++;
        else if (c < '0' || c > '9') return false;
    }
    if (num_dots != 3) return false;
    
    std::stringstream ss(ip);
    std::string segment;
    int seg_count = 0;
    while (std::getline(ss, segment, '.')) {
        seg_count++;
        if (segment.empty() || segment.length() > 3) return false;
        try {
            int val = std::stoi(segment);
            if (val < 0 || val > 255) return false;
        } catch (...) {
            return false;
        }
    }
    return seg_count == 4;
}

std::string ValidateServerList(const std::vector<ServerInfo>& servers) {
    if (servers.empty()) {
        return "Danh sách máy chủ không được để trống!";
    }
    
    for (size_t i = 0; i < servers.size(); ++i) {
        if (servers[i].title.empty()) {
            return "Tên máy chủ ở dòng " + std::to_string(i + 1) + " không được để trống!";
        }
        if (servers[i].address.empty()) {
            return "Địa chỉ IP ở dòng " + std::to_string(i + 1) + " không được để trống!";
        }
        if (!IsValidIPv4(servers[i].address)) {
            return "Địa chỉ IP '" + servers[i].address + "' ở dòng " + std::to_string(i + 1) + " không đúng định dạng IPv4 (A.B.C.D)!";
        }
        
        for (size_t j = i + 1; j < servers.size(); ++j) {
            std::string title_i_lower = servers[i].title;
            std::string title_j_lower = servers[j].title;
            std::transform(title_i_lower.begin(), title_i_lower.end(), title_i_lower.begin(), ::tolower);
            std::transform(title_j_lower.begin(), title_j_lower.end(), title_j_lower.begin(), ::tolower);
            
            if (title_i_lower == title_j_lower) {
                return "Trùng tên máy chủ: '" + servers[i].title + "' xuất hiện nhiều lần!";
            }
            if (servers[i].address == servers[j].address) {
                return "Trùng địa chỉ IP: '" + servers[i].address + "' xuất hiện nhiều lần!";
            }
        }
    }
    return "";
}

}  // namespace

void InitUI(ID3D11Device* device, ID3D11DeviceContext* context, HWND hWnd) {
    g_pd3dDevice = device;
    g_pd3dDeviceContext = context;
    g_hWnd = hWnd;

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

HWND GetMainWindowHandle() {
    return g_hWnd;
}

void RenderUI(LauncherApp& app) {
    ImGui::SetNextWindowPos(ImVec2(0, 0));
    ImGui::SetNextWindowSize(ImVec2(960, 600));

    ImGuiWindowFlags windowFlags = ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize |
                                   ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoCollapse |
                                   ImGuiWindowFlags_NoSavedSettings;

    ImGui::Begin("MainLauncher", nullptr, windowFlags);

    ImGui::SetCursorPos(ImVec2(12, 10));
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

            const std::string& changelog = app.ChangelogContent();
            std::vector<char> text_buf(changelog.begin(), changelog.end());
            text_buf.push_back('\0');

            ImGui::PushStyleColor(ImGuiCol_FrameBg, ImVec4(0.00f, 0.12f, 0.12f, 0.50f));
            ImGui::InputTextMultiline("##changelog_box", text_buf.data(), text_buf.size(), ImVec2(936, 414), ImGuiInputTextFlags_ReadOnly);
            ImGui::PopStyleColor();

            ImGui::EndTabItem();
        }

        if (ImGui::BeginTabItem("Cài đặt")) {
            ImGui::Spacing();
            ImGui::BeginChild("SettingsArea", ImVec2(936, 434), true);

            if (ImGui::BeginTable("SettingsLayoutTable", 2, ImGuiTableFlags_None)) {
                ImGui::TableSetupColumn("LeftCol", ImGuiTableColumnFlags_WidthFixed, 450.0f);
                ImGui::TableSetupColumn("RightCol", ImGuiTableColumnFlags_WidthStretch);
                ImGui::TableNextRow();
                ImGui::TableNextColumn();

            // ================= COL 1: Cài đặt Độ phân giải và hiển thị =================
            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 1.0f, 1.0f));
            ImGui::Text("== Độ phân giải Game ==");
            ImGui::PopStyleColor();
            ImGui::Separator();
            ImGui::Spacing();

            ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.2f, 1.0f), "Chọn độ phân giải phù hợp:");
            ImGui::Spacing();

            int currentRes = app.GameResolution();
            bool sel800  = (currentRes == 800);
            bool sel1024 = (currentRes == 1024);

            if (ImGui::RadioButton("800 x 600  (tiết kiệm tài nguyên)", sel800)) {
                app.SetGameResolution(800);
            }
            if (ImGui::IsItemHovered())
                ImGui::SetTooltip("CẢNH BÁO: Bạn cần cài đặt thư viện Visual C++ Runtime (VCRedist) để game hoạt động đúng độ phân giải mong muốn!\n(Đường dẫn tải ở phía dưới)");
            ImGui::Spacing();
            if (ImGui::RadioButton("1024 x 768 (đồ họa cao hơn)", sel1024)) {
                app.SetGameResolution(1024);
            }
            if (ImGui::IsItemHovered())
                ImGui::SetTooltip("CẢNH BÁO: Bạn cần cài đặt thư viện Visual C++ Runtime (VCRedist) để game hoạt động đúng độ phân giải mong muốn!\n(Đường dẫn tải ở phía dưới)");

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
            ImGui::TextWrapped("* Thay đổi được lưu vào config.ini và package.ini.");
            ImGui::TextWrapped("* Cần khởi động lại game để áp dụng.");
            ImGui::TextWrapped("* Link cài đặt Visual C++ Runtime:");
            static char link_buf[] = "https://github.com/abbodi1406/vcredist";
            ImGui::SetNextItemWidth(400.0f);
            ImGui::InputText("##vcredist_link", link_buf, sizeof(link_buf), ImGuiInputTextFlags_ReadOnly);
            if (ImGui::IsItemHovered()) {
                ImGui::SetTooltip("CẢNH BÁO: Thiếu thư viện Visual C++ Runtime (VCRedist) sẽ khiến game không hoạt động đúng độ phân giải mong muốn!");
            }
            ImGui::PopStyleColor();

            // ================= COL 2: Trình chỉnh sửa ServerList =================
            ImGui::TableNextColumn();

            ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 1.0f, 1.0f));
            ImGui::Text("== Máy chủ tự chỉnh (Region_2) ==");
            ImGui::PopStyleColor();
            ImGui::Separator();
            ImGui::Spacing();

            static std::vector<ServerInfo> temp_servers;
            static bool temp_servers_loaded = false;
            if (!temp_servers_loaded) {
                temp_servers = app.GetServerList();
                temp_servers_loaded = true;
            }

            bool restore_overwrite = false;
            bool restore_merge = false;
            bool do_save = false;

            static std::string popup_message = "";
            static bool show_popup = false;

            // Bảng danh sách máy chủ cuộn cuộn
            ImGui::BeginChild("ServerListScroll", ImVec2(0, 310), true);
            if (ImGui::BeginTable("ServerListTable", 3, ImGuiTableFlags_Borders | ImGuiTableFlags_RowBg | ImGuiTableFlags_Resizable)) {
                ImGui::TableSetupColumn("Tên máy chủ", ImGuiTableColumnFlags_WidthStretch, 0.5f);
                ImGui::TableSetupColumn("Địa chỉ IP", ImGuiTableColumnFlags_WidthStretch, 0.4f);
                ImGui::TableSetupColumn("Xóa", ImGuiTableColumnFlags_WidthFixed, 30.0f);
                ImGui::TableHeadersRow();

                for (size_t i = 0; i < temp_servers.size(); ++i) {
                    ImGui::PushID(static_cast<int>(i));
                    ImGui::TableNextRow();
                    
                    // Cột 1: Tên máy chủ
                    ImGui::TableNextColumn();
                    char title_buf[128];
                    strncpy_s(title_buf, temp_servers[i].title.c_str(), _TRUNCATE);
                    ImGui::SetNextItemWidth(-1.0f);
                    if (ImGui::InputText("##title", title_buf, sizeof(title_buf))) {
                        temp_servers[i].title = title_buf;
                    }

                    // Cột 2: Địa chỉ IP
                    ImGui::TableNextColumn();
                    char addr_buf[128];
                    strncpy_s(addr_buf, temp_servers[i].address.c_str(), _TRUNCATE);
                    ImGui::SetNextItemWidth(-1.0f);
                    if (ImGui::InputText("##addr", addr_buf, sizeof(addr_buf))) {
                        temp_servers[i].address = addr_buf;
                    }

                    // Cột 3: Nút xóa
                    ImGui::TableNextColumn();
                    if (ImGui::Button("X", ImVec2(-1.0f, 0.0f))) {
                        temp_servers.erase(temp_servers.begin() + i);
                        i--;
                    }
                    if (ImGui::IsItemHovered()) {
                        ImGui::SetTooltip("Xóa máy chủ này khỏi danh sách");
                    }

                    ImGui::PopID();
                }
                ImGui::EndTable();
            }
            ImGui::EndChild();

            ImGui::Spacing();
            
            // Nút điều khiển
            if (ImGui::Button("Thêm máy chủ mới")) {
                ServerInfo new_server;
                new_server.title = "May chu moi";
                new_server.address = "127.0.0.1";
                temp_servers.push_back(new_server);
            }
            ImGui::SameLine();
            if (ImGui::Button("Lưu thay đổi")) {
                do_save = true;
            }
            if (ImGui::IsItemHovered()) {
                ImGui::SetTooltip("Lưu các chỉnh sửa vào [Region_2] trong serverlist.ini");
            }

            if (do_save) {
                std::string err = ValidateServerList(temp_servers);
                if (err.empty()) {
                    app.SaveServerList(temp_servers);
                    popup_message = "Lưu danh sách máy chủ thành công!";
                    show_popup = true;
                } else {
                    popup_message = "Lưu thất bại!\n\n" + err;
                    show_popup = true;
                }
            }

            if (show_popup) {
                ImGui::OpenPopup("Thông báo Cài đặt");
                show_popup = false;
            }

            if (ImGui::BeginPopupModal("Thông báo Cài đặt", nullptr, ImGuiWindowFlags_AlwaysAutoResize)) {
                ImGui::Text("%s", popup_message.c_str());
                ImGui::Spacing();
                ImGui::Separator();
                ImGui::Spacing();
                if (ImGui::Button("OK", ImVec2(120, 0))) {
                    ImGui::CloseCurrentPopup();
                }
                ImGui::EndPopup();
            }

            ImGui::EndTable();
            }

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
            
            {
                ImGui::Text("Liên trảm:");
                ImGui::SameLine();
                ImGui::SetNextItemWidth(150.0f);
                const char* items[] = { "Tắt", "Người", "Tất cả" };
                int v = s.lien_tram;
                if (v < 0 || v > 2) v = 0;
                if (ImGui::Combo("##LienTramCombo", &v, items, 3)) {
                    s.lien_tram = v;
                    app.WriteJx1ModKey(L"ChucNang", L"LienTram", v);
                }
                if (ImGui::IsItemHovered()) {
                    ImGui::SetTooltip("Chế độ liên trảm:\n- Tắt (0): Không sử dụng.\n- Người (1): Chỉ áp dụng với người chơi.\n- Tất cả (2): Áp dụng cho cả người và NPC/quái.\n[ChucNang] LienTram");
                }
            }

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
    } else if (snapshot.phase == launcher::update::UpdatePhase::SelfUpdating) {
        display_msg = "Đang tự động cập nhật launcher...";
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
    } else if (snapshot.phase == launcher::update::UpdatePhase::Checking || 
               snapshot.phase == launcher::update::UpdatePhase::Downloading ||
               snapshot.phase == launcher::update::UpdatePhase::SelfUpdating) {
        ImGui::BeginDisabled();
        ImGui::Button("ĐANG CẬP NHẬT...", ImVec2(120, 36));
        ImGui::EndDisabled();
    } else if (snapshot.phase == launcher::update::UpdatePhase::Done) {

        if (ImGui::Button("VÀO GAME", ImVec2(120, 36))) {
            std::wstring gamePath = app.ExecutableDir() + L"\\game.exe";
            HINSTANCE hInst = ShellExecuteW(
                g_hWnd,
                L"runas",        // Chạy dưới quyền Administrator
                gamePath.c_str(),
                nullptr,
                app.ExecutableDir().c_str(), // Thư mục làm việc là thư mục chứa game
                SW_SHOWNORMAL
            );

            if ((INT_PTR)hInst <= 32) {
                // Khởi chạy thất bại
                DWORD err = GetLastError();
                if (err == ERROR_CANCELLED) {
                    MessageBoxW(g_hWnd, L"Bạn đã từ chối cấp quyền Administrator để khởi chạy game.", L"Cảnh báo", MB_OK | MB_ICONWARNING);
                } else {
                    std::wstring errMsg = L"Không thể khởi chạy game.exe (Mã lỗi: " + std::to_wstring(err) + L").\nVui lòng kiểm tra xem tệp game.exe có tồn tại trong thư mục game hay không.";
                    MessageBoxW(g_hWnd, errMsg.c_str(), L"Lỗi khởi chạy", MB_OK | MB_ICONERROR);
                }
            } else {
                // Thành công, đóng launcher
                PostQuitMessage(0);
            }
        }
    }

    ImGui::End();
}

void CleanupUI() {
}
