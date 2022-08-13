include(cmake/cppwinrt.cmake)
include(cmake/cswinrt.cmake)
include(cmake/WindowsAppSDK.cmake)
include(cmake/NETCoreAppRef.cmake)
include(cmake/nuget.cmake)

find_package(PythonInterp REQUIRED)
find_program(MIDL_EXE midl REQUIRED)
find_program(MDMERGE_EXE mdmerge REQUIRED)
find_program(CSC_EXE csc REQUIRED)

set(UWP_VERSION 10.0.18362)

set(PACKAGE_VERSION 0.5.11-prerelease)

# Native paths used by native tools
cmake_path(CONVERT ${CMAKE_CURRENT_LIST_DIR}/Sample.idl TO_NATIVE_PATH_LIST MIDL_FILE NORMALIZE)
cmake_path(CONVERT ${CMAKE_CURRENT_BINARY_DIR}/Unmarged/Sample.winmd TO_NATIVE_PATH_LIST UNMERGED_WINMD_FILE NORMALIZE)
cmake_path(CONVERT ${CMAKE_CURRENT_BINARY_DIR}/Sample.winmd TO_NATIVE_PATH_LIST MERGED_WINMD_FILE NORMALIZE)

cmake_path(CONVERT ${CMAKE_CURRENT_BINARY_DIR}/midlrt.rsp TO_NATIVE_PATH_LIST MIDLRT_RSP_FILE NORMALIZE)
cmake_path(CONVERT ${CMAKE_CURRENT_BINARY_DIR}/mdmerge.rsp TO_NATIVE_PATH_LIST MDMERGE_RSP_FILE NORMALIZE)

cmake_path(CONVERT ${CMAKE_CURRENT_BINARY_DIR}/cppwinrt_plat.rsp TO_NATIVE_PATH_LIST CPPWINRT_PLAT_RSP_FILE NORMALIZE)
cmake_path(CONVERT ${CMAKE_CURRENT_BINARY_DIR}/cppwinrt_ref.rsp TO_NATIVE_PATH_LIST CPPWINRT_REF_RSP_FILE NORMALIZE)
cmake_path(CONVERT ${CMAKE_CURRENT_BINARY_DIR}/cppwinrt_comp.rsp TO_NATIVE_PATH_LIST CPPWINRT_COMP_RSP_FILE NORMALIZE)

cmake_path(CONVERT ${CMAKE_CURRENT_BINARY_DIR}/generated TO_NATIVE_PATH_LIST GENERATED_SOURCE_DIR NORMALIZE)
cmake_path(CONVERT ${CMAKE_CURRENT_BINARY_DIR}/template TO_NATIVE_PATH_LIST GENERATED_TEMPLATE_DIR NORMALIZE)

cmake_path(CONVERT ${CMAKE_CURRENT_BINARY_DIR}/projection TO_NATIVE_PATH_LIST PROJECTION_SOURCE_DIR NORMALIZE)
cmake_path(CONVERT ${CMAKE_CURRENT_BINARY_DIR}/cswinrt.rsp TO_NATIVE_PATH_LIST CSWINRT_RSP_FILE NORMALIZE)
cmake_path(CONVERT ${CMAKE_CURRENT_BINARY_DIR}/csc.rsp TO_NATIVE_PATH_LIST CSC_RSP_FILE NORMALIZE)

add_library(Sample SHARED
	${CMAKE_CURRENT_BINARY_DIR}/generated/module.g.cpp
	SampleControl.cpp
	Sample.def
)

set_target_properties(
	Sample
	PROPERTIES
	CXX_STANDARD 17
	CXX_STANDARD_REQUIRED ON
	CXX_EXTENSIONS OFF
	VS_WINRT_COMPONENT ON
)

target_include_directories(Sample PRIVATE
	${CMAKE_CURRENT_LIST_DIR}
	${GENERATED_SOURCE_DIR}
	${GENERATED_SOURCE_DIR}/winrt
)

add_dependencies(Sample WindowsAppSDK)

# Custom commands to invoke native tools
add_custom_command(
	OUTPUT ${MIDLRT_RSP_FILE}
	COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_LIST_DIR}/scripts/generate_midlrt_rsp.py
		--windows-app-sdk-dir ${WINDOWS_APP_SDK_DIR}
		--uwp-version ${UWP_VERSION}
		${MIDLRT_RSP_FILE}
	MAIN_DEPENDENCY ${CMAKE_CURRENT_LIST_DIR}/scripts/generate_midlrt_rsp.py
	COMMENT "Generating midlrt rsp file"
)

add_custom_command(
	OUTPUT ${UNMERGED_WINMD_FILE}
	COMMAND ${MIDL_EXE} /nologo /winrt /nomidl
		/h "nul" /dlldata "nul" /iid "nul" /proxy "nul"
		/notlb /client none /server none /enum_class /ns_prefix
		/target "NT60" /env x64
		@${MIDLRT_RSP_FILE}
		/winmd ${UNMERGED_WINMD_FILE}
		${MIDL_FILE}
	MAIN_DEPENDENCY ${MIDL_FILE}
	DEPENDS ${MIDLRT_RSP_FILE}
	COMMENT "Generating winmd file"
)

add_custom_command(
	OUTPUT ${MDMERGE_RSP_FILE}
	COMMAND ${PYTHON_EXECUTABLE} "${CMAKE_CURRENT_LIST_DIR}/scripts/generate_mdmerge_rsp.py"
		--windows-app-sdk-dir "${WINDOWS_APP_SDK_DIR}"
		--uwp-version ${UWP_VERSION}
		"${MDMERGE_RSP_FILE}"
	MAIN_DEPENDENCY ${CMAKE_CURRENT_LIST_DIR}/scripts/generate_mdmerge_rsp.py
	COMMENT "Generating mdmerge rsp file"
)

add_custom_command(
	OUTPUT ${MERGED_WINMD_FILE}
	COMMAND ${MDMERGE_EXE} @${MDMERGE_RSP_FILE} -i ${UNMERGED_WINMD_FILE} -o ${CMAKE_CURRENT_BINARY_DIR} -v -partial -n:1
	MAIN_DEPENDENCY ${UNMERGED_WINMD_FILE}
	DEPENDS ${MDMERGE_RSP_FILE}
	COMMENT "Merging winmd file"
)

add_custom_command(
	OUTPUT ${CPPWINRT_PLAT_RSP_FILE}
	COMMAND ${PYTHON_EXECUTABLE} "${CMAKE_CURRENT_LIST_DIR}/scripts/generate_cppwinrt_plat.py"
		--windows-app-sdk-dir "${WINDOWS_APP_SDK_DIR}"
		--uwp-version ${UWP_VERSION}
		"${CPPWINRT_PLAT_RSP_FILE}"
	MAIN_DEPENDENCY ${MERGED_WINMD_FILE}
	DEPENDS ${CMAKE_CURRENT_LIST_DIR}/scripts/generate_cppwinrt_plat.py
	COMMENT "Generating cppwinrt_plat rsp file"
)

add_custom_command(
	OUTPUT ${CPPWINRT_REF_RSP_FILE}
	COMMAND ${PYTHON_EXECUTABLE} "${CMAKE_CURRENT_LIST_DIR}/scripts/generate_cppwinrt_ref.py"
		--windows-app-sdk-dir "${WINDOWS_APP_SDK_DIR}"
		--uwp-version ${UWP_VERSION}
		"${CPPWINRT_REF_RSP_FILE}"
	MAIN_DEPENDENCY ${MERGED_WINMD_FILE}
	DEPENDS ${CMAKE_CURRENT_LIST_DIR}/scripts/generate_cppwinrt_ref.py
	COMMENT "Generating cppwinrt_ref rsp file"
)

add_custom_command(
	OUTPUT ${CPPWINRT_COMP_RSP_FILE}
	COMMAND ${PYTHON_EXECUTABLE} "${CMAKE_CURRENT_LIST_DIR}/scripts/generate_cppwinrt_comp.py"
		--windows-app-sdk-dir "${WINDOWS_APP_SDK_DIR}"
		--uwp-version ${UWP_VERSION}
		"${CPPWINRT_COMP_RSP_FILE}"
	MAIN_DEPENDENCY ${MERGED_WINMD_FILE}
	DEPENDS ${CMAKE_CURRENT_LIST_DIR}/scripts/generate_cppwinrt_comp.py
	COMMENT "Generating cppwinrt_plat rsp file"
)

add_custom_command(
	OUTPUT "${GENERATED_SOURCE_DIR}/module.g.cpp"
	COMMAND "$<TARGET_FILE:CppWinRT>" @"${CPPWINRT_PLAT_RSP_FILE}" -out "${GENERATED_SOURCE_DIR}"
	COMMAND "$<TARGET_FILE:CppWinRT>" @"${CPPWINRT_REF_RSP_FILE}" -out "${GENERATED_SOURCE_DIR}"
	COMMAND "$<TARGET_FILE:CppWinRT>" @"${CPPWINRT_COMP_RSP_FILE}" -in "${MERGED_WINMD_FILE}" -out "${GENERATED_SOURCE_DIR}"
		-name Sample
		-pch . -prefix -comp "${GENERATED_TEMPLATE_DIR}"
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	MAIN_DEPENDENCY ${MERGED_WINMD_FILE}
	DEPENDS ${CPPWINRT_PLAT_RSP_FILE} ${CPPWINRT_REF_RSP_FILE} ${CPPWINRT_COMP_RSP_FILE}
	COMMENT "Generating WinRT component files"
)

string(REPLACE "\\" "" WindowsSDKVersion $ENV{WindowsSDKVersion})

add_custom_target(SampleProjection ALL
	DEPENDS
		${CMAKE_CURRENT_BINARY_DIR}/Sample.Projection.dll
		${CMAKE_CURRENT_BINARY_DIR}/Sample.${PACKAGE_VERSION}.nupkg
)

add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Sample.Projection.dll
    COMMAND "${CSC_EXE}"
		/target:library
		/unsafe+
		/platform:x64
		/nostdlib+
		/debug+
		/debug:full
		/out:${CMAKE_CURRENT_BINARY_DIR}/Sample.Projection.dll
		${CMAKE_CURRENT_BINARY_DIR}/projection/Sample.cs
		${CMAKE_CURRENT_BINARY_DIR}/projection/WinRT.cs
		${CMAKE_CURRENT_BINARY_DIR}/projection/WinRT_Interop.cs
		${CMAKE_CURRENT_BINARY_DIR}/projection/WinRTEventHelpers.cs
		/reference:${CSWINRT_DIR}/lib/net5.0/WinRT.Runtime.dll
        @"${CSC_RSP_FILE}"
    DEPENDS
		${CMAKE_CURRENT_BINARY_DIR}/projection/Sample.cs
		${CMAKE_CURRENT_BINARY_DIR}/projection/WinRT.cs
		${CMAKE_CURRENT_BINARY_DIR}/projection/WinRT_Interop.cs
		${CMAKE_CURRENT_BINARY_DIR}/projection/WinRTEventHelpers.cs
		${CSC_RSP_FILE}
)

add_dependencies(SampleProjection Sample CsWinRT NETCoreAppRef Nuget)

add_custom_command(
	OUTPUT
		${CMAKE_CURRENT_BINARY_DIR}/projection/Sample.cs
		${CMAKE_CURRENT_BINARY_DIR}/projection/WinRT.cs
		${CMAKE_CURRENT_BINARY_DIR}/projection/WinRT_Interop.cs
		${CMAKE_CURRENT_BINARY_DIR}/projection/WinRTEventHelpers.cs
    COMMAND "$<TARGET_FILE:CsWinRT>"
        -in "${MERGED_WINMD_FILE}"
        -in ${WindowsSDKVersion}
        @"${CSWINRT_RSP_FILE}"
        -out "${PROJECTION_SOURCE_DIR}"
        -target net6.0
        -exclude Windows
        -exclude Microsoft
        -include Sample
    DEPENDS ${CSWINRT_RSP_FILE}
)

add_custom_command(
	OUTPUT ${CSWINRT_RSP_FILE}
	COMMAND ${PYTHON_EXECUTABLE} "${CMAKE_CURRENT_LIST_DIR}/scripts/generate_cswinrt_rsp.py"
		--windows-app-sdk-dir "${WINDOWS_APP_SDK_DIR}"
		--uwp-version ${UWP_VERSION}
		"${CSWINRT_RSP_FILE}"
	MAIN_DEPENDENCY ${MERGED_WINMD_FILE}
	DEPENDS ${CMAKE_CURRENT_LIST_DIR}/scripts/generate_cswinrt_rsp.py
	COMMENT "Generating cswinrt rsp file"
)

add_custom_command(
	OUTPUT ${CSC_RSP_FILE}
	COMMAND ${PYTHON_EXECUTABLE} "${CMAKE_CURRENT_LIST_DIR}/scripts/generate_csc_rsp.py"
		--netcore-app-ref-dir "${NETCORE_APP_REF_DIR}"
		--windows-app-sdk-dir "${WINDOWS_APP_SDK_DIR}"
		--uwp-version ${UWP_VERSION}
		"${CSC_RSP_FILE}"
	DEPENDS ${CMAKE_CURRENT_LIST_DIR}/scripts/generate_csc_rsp.py
	COMMENT "Generating csc rsp file"
)

configure_file(${CMAKE_CURRENT_LIST_DIR}/nuget/Sample.nuspec.in ${CMAKE_CURRENT_BINARY_DIR}/Sample.nuspec)

add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Sample.${PACKAGE_VERSION}.nupkg
	COMMAND "$<TARGET_FILE:Nuget>" pack ${CMAKE_CURRENT_BINARY_DIR}/Sample.nuspec
	DEPENDS
		${CMAKE_CURRENT_BINARY_DIR}/Sample.nuspec
		${CMAKE_CURRENT_BINARY_DIR}/Sample.Projection.dll
	COMMENT "NuGet packaging"
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/Sample.${PACKAGE_VERSION}.nupkg TYPE BIN)
