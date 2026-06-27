add_executable(LauncherJX WIN32
    src/main.cpp
    src/ui.cpp
    resources/app.rc
)

target_include_directories(LauncherJX
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(LauncherJX
    PRIVATE
        common_lib
        comctl32
        user32
        gdi32
)

target_link_options(LauncherJX PRIVATE "/MANIFEST:NO")

target_compile_definitions(LauncherJX PRIVATE UNICODE _UNICODE)
