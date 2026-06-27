#pragma once

#include <string>

namespace common {

std::wstring Utf8ToWide(const std::string& text);
std::string WideToUtf8(const std::wstring& text);

}  // namespace common
