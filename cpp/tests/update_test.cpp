#include "update.h"
#include <iostream>
#include <cassert>
#include <string>

void TestCompareSemanticVersion() {
    using namespace launcher::update;

    // Bằng nhau
    assert(CompareSemanticVersion("v1.0.0", "1.0.0") == 0);
    assert(CompareSemanticVersion("v1.0.0", "v1.0.0") == 0);
    assert(CompareSemanticVersion("1.0", "1.0.0") == 0);
    assert(CompareSemanticVersion("v2.5", "2.5.0.0") == 0);

    // Lớn hơn
    assert(CompareSemanticVersion("v1.0.1", "1.0.0") == 1);
    assert(CompareSemanticVersion("v1.1.0", "v1.0.9") == 1);
    assert(CompareSemanticVersion("2.0.0", "v1.9.9") == 1);
    assert(CompareSemanticVersion("v1.0.0.1", "1.0.0") == 1);
    assert(CompareSemanticVersion("v1.0.1-alpha", "1.0.0") == 1);

    // Nhỏ hơn
    assert(CompareSemanticVersion("v1.0.0", "1.0.1") == -1);
    assert(CompareSemanticVersion("v1.0.9", "v1.1.0") == -1);
    assert(CompareSemanticVersion("1.9.9", "v2.0.0") == -1);
    assert(CompareSemanticVersion("1.0.0", "v1.0.0.1") == -1);

    std::cout << "All Semantic Version tests passed successfully!" << std::endl;
}

void TestUrlEncode() {
    using namespace launcher::update;

    assert(UrlEncode("script/a.lua") == "script/a.lua");
    assert(UrlEncode("data-txt_1.0.txt") == "data-txt_1.0.txt");
    assert(UrlEncode("script/½ð.lua") == "script/%C2%BD%C3%B0.lua");
    assert(UrlEncode("script/skill/gaibang/½ðÎÚÓ³Ñ©.lua") == "script/skill/gaibang/%C2%BD%C3%B0%C3%8E%C3%9A%C3%93%C2%B3%C3%91%C2%A9.lua");

    std::cout << "All UrlEncode tests passed successfully!" << std::endl;
}

int main() {
    try {
        TestCompareSemanticVersion();
        TestUrlEncode();
    } catch (const std::exception& e) {
        std::cerr << "Test failed with exception: " << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "Test failed with unknown error" << std::endl;
        return 1;
    }
    return 0;
}
