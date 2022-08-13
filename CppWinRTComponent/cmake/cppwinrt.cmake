include(ExternalProject)

ExternalProject_Add(
  CppWinRTBuild
  URL "https://github.com/microsoft/cppwinrt/releases/download/2.0.220131.2/Microsoft.Windows.CppWinRT.2.0.220131.2.nupkg"
  URL_HASH "SHA256=899c1c676c72404aea4c07ebd7e3314c245867f95918c79fc122642df85e168c"

  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""

  EXCLUDE_FROM_ALL
)

ExternalProject_Get_Property(CppWinRTBuild SOURCE_DIR)

add_executable(CppWinRT IMPORTED GLOBAL)
add_dependencies(CppWinRT CppWinRTBuild)
set_target_properties(CppWinRT PROPERTIES IMPORTED_LOCATION "${SOURCE_DIR}/bin/cppwinrt.exe")
