include(ExternalProject)

ExternalProject_Add(
  WindowsAppSDK
  URL "https://www.nuget.org/api/v2/package/Microsoft.WindowsAppSDK/1.1.3"
  URL_HASH "SHA256=af4cb0f345524aff626910e70c990cae74ef08de216869f2226be467839f50a9"

  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""

  EXCLUDE_FROM_ALL
)

ExternalProject_Get_Property(WindowsAppSDK SOURCE_DIR)

set(WINDOWS_APP_SDK_DIR "${SOURCE_DIR}")
set(WINDOWS_APP_SDK_DIR "${WINDOWS_APP_SDK_DIR}" PARENT_SCOPE)
