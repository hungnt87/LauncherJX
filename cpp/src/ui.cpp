#include "ui.h"
#include "imgui.h"
#include "imgui_impl_win32.h"
#include "imgui_impl_dx11.h"
#include <gdiplus.h>
#include <atomic>
#include <thread>
#include <string>
#include <fstream>
#include <vector>
#include <wincrypt.h>
#include <iomanip>
#include <sstream>

namespace {

ID3D11Device*        g_pd3dDevice = nullptr;
ID3D11DeviceContext* g_pd3dDeviceContext = nullptr;
HWND                 g_hWnd = nullptr;

// Texture tai nguyen
ID3D11ShaderResourceView* g_bannerTexture = nullptr;
ID3D11ShaderResourceView* g_logoTexture = nullptr;
int g_bannerWidth = 0, g_bannerHeight = 0;
int g_logoWidth = 0, g_logoHeight = 0;

// Chuoi version doc tu file
std::string g_versionString = "v1.0.0";

// Cau truc file game va danh sach files can theo doi
struct GameFileConfig {
    std::string name;
    std::string hash;
};
std::vector<GameFileConfig> g_gameFilesList;

// Da luong cap nhat
std::atomic<float> g_updateProgress{0.0f};
std::atomic<int> g_updateState{0}; // 0: Chua cap nhat, 1: Dang cap nhat, 2: Hoan thanh
std::atomic<bool> g_appRunning{true};
std::thread g_updateThread;

// Ham lay duong dan den thu muc chua file .exe
std::wstring GetExecutablePath() {
    wchar_t buffer[MAX_PATH];
    GetModuleFileNameW(nullptr, buffer, MAX_PATH);
    std::wstring path(buffer);
    size_t pos = path.find_last_of(L"\\/");
    if (pos != std::wstring::npos) {
        return path.substr(0, pos);
    }
    return L".";
}

// Thuat toan tinh MD5 cua file su dung Win32 CryptoAPI
std::string CalculateMD5(const std::wstring& filePath) {
    HCRYPTPROV hProv = 0;
    HCRYPTHASH hHash = 0;
    std::string md5Result = "";

    std::ifstream file(filePath, std::ios::binary);
    if (!file.is_open()) return "";

    if (!CryptAcquireContextW(&hProv, nullptr, nullptr, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT)) {
        return "";
    }

    if (!CryptCreateHash(hProv, CALG_MD5, 0, 0, &hHash)) {
        CryptReleaseContext(hProv, 0);
        return "";
    }

    char buffer[4096];
    while (file.good()) {
        file.read(buffer, sizeof(buffer));
        std::streamsize bytesRead = file.gcount();
        if (bytesRead > 0) {
            if (!CryptHashData(hHash, reinterpret_cast<BYTE*>(buffer), static_cast<DWORD>(bytesRead), 0)) {
                CryptDestroyHash(hHash);
                CryptReleaseContext(hProv, 0);
                return "";
            }
        }
    }

    DWORD cbHashSize = 16;
    BYTE rgbHash[16];
    if (CryptGetHashParam(hHash, HP_HASHVAL, rgbHash, &cbHashSize, 0)) {
        std::ostringstream oss;
        for (DWORD i = 0; i < cbHashSize; i++) {
            oss << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(rgbHash[i]);
        }
        md5Result = oss.str();
    }

    CryptDestroyHash(hHash);
    CryptReleaseContext(hProv, 0);
    return md5Result;
}

std::string ParseJsonValue(const std::string& json, const std::string& key) {
    size_t keyPos = json.find("\"" + key + "\"");
    if (keyPos == std::string::npos) return "";
    
    size_t colonPos = json.find(":", keyPos);
    if (colonPos == std::string::npos) return "";
    
    size_t startQuote = json.find("\"", colonPos);
    if (startQuote == std::string::npos) return "";
    
    size_t endQuote = json.find("\"", startQuote + 1);
    if (endQuote == std::string::npos) return "";
    
    return json.substr(startQuote + 1, endQuote - startQuote - 1);
}

std::vector<GameFileConfig> ParseJsonFiles(const std::string& json) {
    std::vector<GameFileConfig> files;
    
    size_t arrayStart = json.find("\"files\"");
    if (arrayStart == std::string::npos) return files;
    
    size_t openBracket = json.find("[", arrayStart);
    size_t closeBracket = json.find("]", openBracket);
    if (openBracket == std::string::npos || closeBracket == std::string::npos) return files;
    
    std::string arrayContent = json.substr(openBracket + 1, closeBracket - openBracket - 1);
    
    size_t searchPos = 0;
    while (true) {
        size_t objStart = arrayContent.find("{", searchPos);
        if (objStart == std::string::npos) break;
        size_t objEnd = arrayContent.find("}", objStart);
        if (objEnd == std::string::npos) break;
        
        std::string objStr = arrayContent.substr(objStart, objEnd - objStart + 1);
        
        size_t nameKey = objStr.find("\"name\"");
        size_t hashKey = objStr.find("\"hash\"");
        
        if (nameKey != std::string::npos && hashKey != std::string::npos) {
            size_t nameColon = objStr.find(":", nameKey);
            size_t nameStartQuote = objStr.find("\"", nameColon);
            size_t nameEndQuote = objStr.find("\"", nameStartQuote + 1);
            
            size_t hashColon = objStr.find(":", hashKey);
            size_t hashStartQuote = objStr.find("\"", hashColon);
            size_t hashEndQuote = objStr.find("\"", hashStartQuote + 1);
            
            if (nameStartQuote != std::string::npos && nameEndQuote != std::string::npos &&
                hashStartQuote != std::string::npos && hashEndQuote != std::string::npos) {
                
                GameFileConfig cfg;
                cfg.name = objStr.substr(nameStartQuote + 1, nameEndQuote - nameStartQuote - 1);
                cfg.hash = objStr.substr(hashStartQuote + 1, hashEndQuote - hashStartQuote - 1);
                files.push_back(cfg);
            }
        }
        searchPos = objEnd + 1;
    }
    
    return files;
}

bool LoadTextureFromImage(const wchar_t* filename, ID3D11ShaderResourceView** out_srv, int* out_width, int* out_height) {
    // Tai anh bang GDI+
    Gdiplus::Bitmap bitmap(filename);
    if (bitmap.GetLastStatus() != Gdiplus::Ok) {
        return false;
    }

    UINT width = bitmap.GetWidth();
    UINT height = bitmap.GetHeight();

    // Khoa pixel de lay du lieu ARGB raw
    Gdiplus::BitmapData bitmapData;
    Gdiplus::Rect rect(0, 0, width, height);
    if (bitmap.LockBits(&rect, Gdiplus::ImageLockModeRead, PixelFormat32bppARGB, &bitmapData) != Gdiplus::Ok) {
        return false;
    }

    // Tao Texture 2D DirectX 11
    D3D11_TEXTURE2D_DESC desc;
    ZeroMemory(&desc, sizeof(desc));
    desc.Width = width;
    desc.Height = height;
    desc.MipLevels = 1;
    desc.ArraySize = 1;
    desc.Format = DXGI_FORMAT_B8G8R8A8_UNORM; // Phù hop voi PixelFormat32bppARGB cua GDI+
    desc.SampleDesc.Count = 1;
    desc.Usage = D3D11_USAGE_DEFAULT;
    desc.BindFlags = D3D11_BIND_SHADER_RESOURCE;

    D3D11_SUBRESOURCE_DATA subResource;
    ZeroMemory(&subResource, sizeof(subResource));
    subResource.pSysMem = bitmapData.Scan0;
    subResource.SysMemPitch = bitmapData.Stride;

    ID3D11Texture2D* pTexture = nullptr;
    HRESULT hr = g_pd3dDevice->CreateTexture2D(&desc, &subResource, &pTexture);
    
    // Mo khoa pixel
    bitmap.UnlockBits(&bitmapData);

    if (FAILED(hr)) {
        return false;
    }

    // Tao Shader Resource View tu Texture
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

} // namespace

void InitUI(ID3D11Device* device, ID3D11DeviceContext* context, HWND hWnd) {
    g_pd3dDevice = device;
    g_pd3dDeviceContext = context;
    g_hWnd = hWnd;

    // Load cac texture tu thu muc launcher_res nam cung thu muc file .exe
    std::wstring exeDir = GetExecutablePath();
    std::wstring bannerPath = exeDir + L"\\launcher_res\\wuxia_banner.png";
    std::wstring logoPath = exeDir + L"\\launcher_res\\app_icon.png";

    LoadTextureFromImage(bannerPath.c_str(), &g_bannerTexture, &g_bannerWidth, &g_bannerHeight);
    LoadTextureFromImage(logoPath.c_str(), &g_logoTexture, &g_logoWidth, &g_logoHeight);

    // Doc file version.json tu thu muc launcher_res
    std::wstring versionPath = exeDir + L"\\launcher_res\\version.json";
    std::ifstream versionFile(versionPath);
    if (versionFile.is_open()) {
        std::string jsonContent((std::istreambuf_iterator<char>(versionFile)),
                                 std::istreambuf_iterator<char>());
        std::string ver = ParseJsonValue(jsonContent, "version");
        if (!ver.empty()) {
            g_versionString = ver;
        }
        // Luu danh sach file game can check
        g_gameFilesList = ParseJsonFiles(jsonContent);
        versionFile.close();
    }

    // Cau hinh Font tieng Viet Segoe UI tu thu muc Fonts he thong voi co chu lon 18.0f
    ImGuiIO& io = ImGui::GetIO();
    io.Fonts->AddFontFromFileTTF("C:\\Windows\\Fonts\\segoeui.ttf", 18.0f, nullptr, io.Fonts->GetGlyphRangesVietnamese());

    // Thiet lap phong cach Custom Theme Teal toi & Neon Cyan
    ImGuiStyle& style = ImGui::GetStyle();
    style.WindowRounding = 8.0f;
    style.FrameRounding = 4.0f;
    style.PopupRounding = 6.0f;
    style.GrabRounding = 4.0f;
    style.WindowBorderSize = 1.0f;

    style.Colors[ImGuiCol_WindowBg]             = ImVec4(0.00f, 0.07f, 0.07f, 0.95f); // Teal cực toi
    style.Colors[ImGuiCol_ChildBg]              = ImVec4(0.00f, 0.12f, 0.12f, 0.50f); // Grey-Teal toi
    style.Colors[ImGuiCol_Border]               = ImVec4(0.00f, 0.50f, 0.50f, 0.50f); // Vien Teal trung tinh
    style.Colors[ImGuiCol_FrameBg]              = ImVec4(0.00f, 0.20f, 0.20f, 0.54f);
    style.Colors[ImGuiCol_FrameBgHovered]       = ImVec4(0.00f, 0.40f, 0.40f, 0.40f);
    style.Colors[ImGuiCol_FrameBgActive]        = ImVec4(0.00f, 0.50f, 0.50f, 0.67f);
    style.Colors[ImGuiCol_TitleBg]              = ImVec4(0.00f, 0.20f, 0.20f, 1.00f);
    style.Colors[ImGuiCol_TitleBgActive]        = ImVec4(0.00f, 0.30f, 0.30f, 1.00f);
    style.Colors[ImGuiCol_CheckMark]            = ImVec4(0.00f, 1.00f, 1.00f, 1.00f); // Neon Cyan check
    style.Colors[ImGuiCol_SliderGrab]           = ImVec4(0.00f, 0.50f, 0.50f, 1.00f);
    style.Colors[ImGuiCol_SliderGrabActive]     = ImVec4(0.00f, 0.80f, 0.80f, 1.00f);
    style.Colors[ImGuiCol_Button]               = ImVec4(0.00f, 0.37f, 0.37f, 1.00f); // Teal sang
    style.Colors[ImGuiCol_ButtonHovered]        = ImVec4(0.00f, 0.50f, 0.50f, 1.00f); // Neon Cyan hover
    style.Colors[ImGuiCol_ButtonActive]         = ImVec4(0.00f, 0.70f, 0.70f, 1.00f);
    style.Colors[ImGuiCol_Header]               = ImVec4(0.00f, 0.30f, 0.30f, 0.55f);
    style.Colors[ImGuiCol_HeaderHovered]        = ImVec4(0.00f, 0.50f, 0.50f, 0.80f);
    style.Colors[ImGuiCol_HeaderActive]         = ImVec4(0.00f, 0.60f, 0.60f, 1.00f);
    style.Colors[ImGuiCol_Tab]                  = ImVec4(0.00f, 0.25f, 0.25f, 0.86f);
    style.Colors[ImGuiCol_TabHovered]           = ImVec4(0.00f, 0.50f, 0.50f, 0.80f);
    style.Colors[ImGuiCol_TabActive]            = ImVec4(0.00f, 0.40f, 0.40f, 1.00f);
}

void RenderUI() {
    // Dat vi tri cua so ImGui khop khit 960x600
    ImGui::SetNextWindowPos(ImVec2(0, 0));
    ImGui::SetNextWindowSize(ImVec2(960, 600));
    
    ImGuiWindowFlags windowFlags = ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | 
                                   ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoCollapse | 
                                   ImGuiWindowFlags_NoSavedSettings;
                                   
    ImGui::Begin("MainLauncher", nullptr, windowFlags);

    // 1. Tu thiet ke Custom Title Bar (Vung tieu de cao 40px)
    ImGui::SetCursorPos(ImVec2(10, 8));
    if (g_logoTexture) {
        ImGui::Image(reinterpret_cast<void*>(g_logoTexture), ImVec2(24, 24));
    }
    ImGui::SameLine();
    ImGui::SetCursorPosY(10);
    std::string titleText = "LauncherJX - " + g_versionString;
    ImGui::TextColored(ImVec4(0.0f, 1.0f, 1.0f, 1.0f), titleText.c_str()); // Chu Neon Cyan

    // Nut Minimize va Close o goc tren ben phai (960 - 70 = 890px)
    ImGui::SetCursorPos(ImVec2(890, 6));
    if (ImGui::Button("_", ImVec2(26, 26))) {
        ShowWindow(g_hWnd, SW_MINIMIZE);
    }
    ImGui::SameLine();
    ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0.8f, 0.1f, 0.1f, 1.0f)); // Hover dong mau do
    if (ImGui::Button("X", ImVec2(26, 26))) {
        PostQuitMessage(0);
    }
    ImGui::PopStyleColor();

    ImGui::Separator();

    // 2. Tao he thong Tab (Thong bao & Cai dat)
    ImGui::SetCursorPos(ImVec2(12, 45));
    if (ImGui::BeginTabBar("LauncherTabs")) {
        // --- TAB THÔNG BÁO ---
        if (ImGui::BeginTabItem("Thông báo")) {
            ImGui::Spacing();
            // Ve anh banner (kích thước 936x180)
            if (g_bannerTexture) {
                ImGui::Image(reinterpret_cast<void*>(g_bannerTexture), ImVec2(936, 180));
            } else {
                // Ve khong gian trong neu anh loi
                ImGui::BeginChild("ErrorBanner", ImVec2(936, 180), true);
                ImGui::Text("Không thể tải ảnh wuxia_banner.png");
                ImGui::EndChild();
            }
            ImGui::Spacing();
            
            // Text box tin tuc cuon (kích thước 936x220)
            ImGui::BeginChild("NewsText", ImVec2(936, 220), true);
            ImGui::TextWrapped("=== TIN TỨC VÕ LÂM JX ===");
            ImGui::Separator();
            ImGui::BulletText("Khai mở máy chủ thử nghiệm Thái Sơn vào ngày 28/06/2026.");
            ImGui::BulletText("Sự kiện 'Kiếm Hiệp Tranh Hùng' nhận kỳ trân dị bảo cực hot.");
            ImGui::BulletText("Hệ thống launcher Dear ImGui + DX11 thế hệ mới chạy siêu mượt.");
            ImGui::BulletText("Tự động cập nhật patch mới nhất chỉ với 1 cú click chuột.");
            ImGui::Spacing();
            ImGui::TextColored(ImVec4(1.0f, 0.8f, 0.2f, 1.0f), "Chúc các đại hiệp hành tẩu giang hồ gặp nhiều may mắn!");
            ImGui::EndChild();
            
            ImGui::EndTabItem();
        }

        // --- TAB CÀI ĐẶT ---
        if (ImGui::BeginTabItem("Cài đặt")) {
            ImGui::Spacing();
            ImGui::BeginChild("SettingsArea", ImVec2(936, 434), true);
            ImGui::Text("Cấu hình đồ họa & Âm thanh");
            ImGui::Separator();
            ImGui::Spacing();

            // Lua chon do phan gia
            static int selectedRes = 0;
            ImGui::Text("Độ phân giải game:");
            ImGui::RadioButton("800 x 600 (Mặc định)", &selectedRes, 0);
            ImGui::RadioButton("1024 x 768", &selectedRes, 1);
            ImGui::RadioButton("1280 x 720 (HD)", &selectedRes, 2);

            ImGui::Spacing();
            ImGui::Separator();
            ImGui::Spacing();

            // Checkbox che do cua so & am thanh
            static bool isWindowed = true;
            static bool enableSound = true;
            ImGui::Checkbox("Chế độ cửa sổ (Windowed)", &isWindowed);
            ImGui::Checkbox("Bật âm thanh trong game", &enableSound);

            ImGui::EndChild();
            ImGui::EndTabItem();
        }
        ImGui::EndTabBar();
    }

    // 3. Vung chan trang Footer (dat o Y = 515px)
    ImGui::SetCursorPos(ImVec2(12, 515));
    
    // Status text
    if (g_updateState == 0) {
        ImGui::Text("Hệ thống đã sẵn sàng. Vui lòng bấm UPDATE để cập nhật game.");
    } else if (g_updateState == 1) {
        ImGui::Text("Đang tải bản cập nhật: %.0f%%", g_updateProgress * 100.0f);
    } else if (g_updateState == 2) {
        ImGui::TextColored(ImVec4(0.0f, 1.0f, 0.0f, 1.0f), "Cập nhật hoàn tất! Hệ thống đã sẵn sàng.");
    }

    // Progress bar (dat o Y = 545px, rộng 800px)
    ImGui::SetCursorPos(ImVec2(12, 545));
    ImGui::ProgressBar(g_updateProgress, ImVec2(800, 22));

    // Nut UPDATE/PLAY lon o goc duoi ben phai (960 - 12 - 120 = 828px, Y = 535px)
    ImGui::SetCursorPos(ImVec2(828, 535));
    
    if (g_updateState == 0) {
        if (ImGui::Button("UPDATE", ImVec2(120, 36))) {
            g_updateState = 1;
            if (g_updateThread.joinable()) {
                g_updateThread.join();
            }
            g_updateThread = std::thread([]() {
                std::wstring exeDir = GetExecutablePath();
                std::vector<std::wstring> filesToUpdate;

                // 1. Quet va so khop MD5 cua cac file game
                for (const auto& fileCfg : g_gameFilesList) {
                    if (!g_appRunning) break;
                    
                    std::wstring wFileName(fileCfg.name.begin(), fileCfg.name.end());
                    std::wstring localPath = exeDir + L"\\launcher_res\\" + wFileName;
                    
                    std::string localHash = CalculateMD5(localPath);
                    
                    // Neu file sai hash hoac chua ton tai -> Dua vao list update
                    if (localHash != fileCfg.hash) {
                        filesToUpdate.push_back(localPath);
                    }
                }

                if (filesToUpdate.empty()) {
                    g_updateProgress = 1.0f;
                    std::this_thread::sleep_for(std::chrono::milliseconds(500));
                    if (g_appRunning) {
                        g_updateState = 2;
                    }
                    return;
                }

                // 2. Tai mo phong các file can cap nhat
                for (size_t idx = 0; idx < filesToUpdate.size(); ++idx) {
                    if (!g_appRunning) break;
                    
                    const auto& path = filesToUpdate[idx];
                    
                    // Giả lập tải file (chạy progress bar)
                    for (int i = 0; i <= 100; ++i) {
                        if (!g_appRunning) break;
                        g_updateProgress = static_cast<float>(i) / 100.0f;
                        std::this_thread::sleep_for(std::chrono::milliseconds(20));
                    }

                    // Ghi de/tao moi file chuan
                    std::ofstream outFile(path);
                    if (outFile.is_open()) {
                        outFile << "Phien ban moi nhat v1.0.0. Hoat dong tot!";
                        outFile.close();
                    }
                }

                if (g_appRunning) {
                    g_updateProgress = 1.0f;
                    g_updateState = 2;
                }
            });
        }
    } else if (g_updateState == 1) {
        ImGui::BeginDisabled();
        ImGui::Button("UPDATING...", ImVec2(120, 36));
        ImGui::EndDisabled();
    } else if (g_updateState == 2) {
        if (ImGui::Button("PLAY", ImVec2(120, 36))) {
            MessageBoxW(g_hWnd, L"Đang khởi chạy game Võ Lâm Truyền Kỳ! Chúc đại hiệp chơi game vui vẻ.", L"LauncherJX", MB_OK | MB_ICONINFORMATION);
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
    if (g_bannerTexture) { g_bannerTexture->Release(); g_bannerTexture = nullptr; }
    if (g_logoTexture) { g_logoTexture->Release(); g_logoTexture = nullptr; }
}
