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
        gdiplus
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
