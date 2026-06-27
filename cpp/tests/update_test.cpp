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

int main() {
    try {
        TestCompareSemanticVersion();
    } catch (const std::exception& e) {
        std::cerr << "Test failed with exception: " << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "Test failed with unknown error" << std::endl;
        return 1;
    }
    return 0;
}
