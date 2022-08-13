include(ExternalProject)

ExternalProject_Add(
  NugetBuild
  URL "https://www.nuget.org/api/v2/package/NuGet.exe/3.4.3"
  URL_HASH "SHA256=2d4d38666e5c7d27ee487c60c9637bd9dd63795a117f0e0edc68c55ee6dfb71f"

  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""

  EXCLUDE_FROM_ALL
)

ExternalProject_Get_Property(NugetBuild SOURCE_DIR)

add_executable(NuGet IMPORTED GLOBAL)
add_dependencies(NuGet NuGetBuild)
set_target_properties(NuGet PROPERTIES IMPORTED_LOCATION "${SOURCE_DIR}/build/native/NuGet.exe")
