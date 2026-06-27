cmake_minimum_required(VERSION 3.20)

project(LauncherJX_cpp LANGUAGES CXX)

include(FetchContent)

# Tai ImGui tu GitHub
FetchContent_Declare(
  imgui
  GIT_REPOSITORY https://github.com/ocornut/imgui.git
  GIT_TAG        v1.90.8
)

FetchContent_MakeAvailable(imgui)

# Duong dan nguon ImGui
set(IMGUI_DIR ${imgui_SOURCE_DIR})

# Thiet lap target executable voi file nguon ImGui
add_executable(LauncherJX WIN32
    src/main.cpp
    src/ui.cpp
    resources/app.rc
    ${IMGUI_DIR}/imgui.cpp
    ${IMGUI_DIR}/imgui_draw.cpp
    ${IMGUI_DIR}/imgui_widgets.cpp
    ${IMGUI_DIR}/imgui_tables.cpp
    ${IMGUI_DIR}/backends/imgui_impl_win32.cpp
    ${IMGUI_DIR}/backends/imgui_impl_dx11.cpp
)

target_include_directories(LauncherJX
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${IMGUI_DIR}
        ${IMGUI_DIR}/backends
)

target_link_libraries(LauncherJX
    PRIVATE
        common_lib
        comctl32
        user32
        gdi32
        gdiplus
        d3d11
        d3dcompiler
)

# Sao chep file anh resources vao cac thu muc build
file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/resources/wuxia_banner.png"
          "${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon.png"
     DESTINATION "${CMAKE_BINARY_DIR}/bin")
file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/resources/wuxia_banner.png"
          "${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon.png"
     DESTINATION "${CMAKE_BINARY_DIR}/bin/Debug")
file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/resources/wuxia_banner.png"
          "${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon.png"
     DESTINATION "${CMAKE_BINARY_DIR}/bin/Release")

target_link_options(LauncherJX PRIVATE "/MANIFEST:NO")

target_compile_options(LauncherJX PRIVATE "/utf-8")

target_compile_definitions(LauncherJX PRIVATE UNICODE _UNICODE)
