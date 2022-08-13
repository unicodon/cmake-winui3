include(ExternalProject)

ExternalProject_Add(
  CsWinRTBuild
  URL "https://github.com/microsoft/CsWinRT/releases/download/1.6.4.220527.1/Microsoft.Windows.CsWinRT.1.6.4.nupkg"
  URL_HASH "SHA256=f335933975f23dda0ae70b495a028aa3d000fe20ae982bcb20b560f3d7c27f73"

  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""

  EXCLUDE_FROM_ALL
)

ExternalProject_Get_Property(CsWinRTBuild SOURCE_DIR)

add_executable(CsWinRT IMPORTED GLOBAL)
add_dependencies(CsWinRT CsWinRTBuild)
set_target_properties(CsWinRT PROPERTIES IMPORTED_LOCATION "${SOURCE_DIR}/cswinrt.exe")

set(CSWINRT_DIR "${SOURCE_DIR}")
set(CSWINRT_DIR "${CSWINRT_DIR}" PARENT_SCOPE)
