cmake_minimum_required(VERSION 3.20)

project(LauncherJX_updater LANGUAGES CXX)

add_executable(updater WIN32
    src/main.cpp
    src/updater.cpp
)

target_include_directories(updater
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${PROJECT_SOURCE_DIR}/src/common/include
)

target_link_libraries(updater
    PRIVATE
        common_lib
        advapi32
)

target_compile_options(updater PRIVATE "/utf-8")
target_compile_definitions(updater PRIVATE UNICODE _UNICODE)

# Target test cho updater
add_executable(updater_tests
    tests/updater_test.cpp
    src/updater.cpp
)

target_include_directories(updater_tests
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${PROJECT_SOURCE_DIR}/src/common/include
)

target_link_libraries(updater_tests
    PRIVATE
        common_lib
        advapi32
)

target_compile_options(updater_tests PRIVATE "/utf-8")
target_compile_definitions(updater_tests PRIVATE UNICODE _UNICODE)
