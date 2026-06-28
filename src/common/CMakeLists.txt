add_library(common_lib STATIC
    src/common.cpp
)

target_include_directories(common_lib
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_compile_definitions(common_lib PRIVATE UNICODE _UNICODE)
