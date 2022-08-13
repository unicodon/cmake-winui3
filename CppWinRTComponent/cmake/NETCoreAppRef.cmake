include(ExternalProject)

ExternalProject_Add(
  NETCoreAppRef
  URL "https://www.nuget.org/api/v2/package/Microsoft.NETCore.App.Ref/5.0.0"
  URL_HASH "SHA256=910f30a51e1cad6a2acbf8ebb246addf863736bde76f1a12a443cc9f1c9cc2dc"

  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""

  EXCLUDE_FROM_ALL
)

ExternalProject_Get_Property(NETCoreAppRef SOURCE_DIR)

set(NETCORE_APP_REF_DIR "${SOURCE_DIR}")
set(NETCORE_APP_REF_DIR "${NETCORE_APP_REF_DIR}" PARENT_SCOPE)
