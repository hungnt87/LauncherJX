cmake_minimum_required(VERSION 3.20)

project(LauncherJX_cpp LANGUAGES CXX)

include(FetchContent)

FetchContent_Declare(
  imgui
  GIT_REPOSITORY https://github.com/ocornut/imgui.git
  GIT_TAG        v1.90.8
)

FetchContent_MakeAvailable(imgui)

set(IMGUI_DIR ${imgui_SOURCE_DIR})
set(IMGUI_BACKENDS_DIR ${IMGUI_DIR}/backends)

add_library(launcher_resources INTERFACE)
target_include_directories(launcher_resources INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/include)

add_library(imgui_objects OBJECT)
target_sources(imgui_objects
    PRIVATE
        ${IMGUI_DIR}/imgui.cpp
        ${IMGUI_DIR}/imgui_draw.cpp
        ${IMGUI_DIR}/imgui_widgets.cpp
        ${IMGUI_DIR}/imgui_tables.cpp
        ${IMGUI_BACKENDS_DIR}/imgui_impl_win32.cpp
        ${IMGUI_BACKENDS_DIR}/imgui_impl_dx11.cpp
)
target_include_directories(imgui_objects
    PUBLIC
        ${IMGUI_DIR}
        ${IMGUI_BACKENDS_DIR}
)

add_executable(LauncherJX WIN32)
target_sources(LauncherJX
    PRIVATE
        src/main.cpp
        src/ui.cpp
        src/update.cpp
        src/launcher_app.cpp
        resources/app.rc
        $<TARGET_OBJECTS:imgui_objects>
)

target_link_libraries(LauncherJX
    PRIVATE
        launcher_resources
        common_lib
        comctl32
        user32
        gdi32
        gdiplus
        d3d11
        d3dcompiler
        advapi32
        wininet
)

target_include_directories(LauncherJX
    PRIVATE
        ${IMGUI_DIR}
        ${IMGUI_BACKENDS_DIR}
)

target_link_options(LauncherJX PRIVATE "/MANIFEST:NO")
target_compile_options(LauncherJX PRIVATE "/utf-8")
target_compile_definitions(LauncherJX PRIVATE UNICODE _UNICODE)


# Thêm target test cho logic update
add_executable(update_tests
    tests/update_test.cpp
    src/update.cpp
)

target_link_libraries(update_tests
    PRIVATE
        launcher_resources
        common_lib
        advapi32
        wininet
)

target_compile_options(update_tests PRIVATE "/utf-8")
target_compile_definitions(update_tests PRIVATE UNICODE _UNICODE)
