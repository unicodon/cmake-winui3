include(cmake/cppwinrt.cmake)

include(ExternalProject)

add_library(Sample SHARED
	${CMAKE_CURRENT_BINARY_DIR}/module.g.cpp
	SampleClass.cpp
	Sample.def
)

set(WINMD_FILE "${CMAKE_CURRENT_BINARY_DIR}/Sample.winmd")

set_target_properties(
	Sample
	PROPERTIES
	CXX_STANDARD 17
	CXX_STANDARD_REQUIRED ON
	CXX_EXTENSIONS OFF
	VS_WINRT_COMPONENT ON
)

target_include_directories(Sample PRIVATE ${CMAKE_CURRENT_LIST_DIR} ${CMAKE_CURRENT_BINARY_DIR})

find_program(MIDL_EXE midl REQUIRED)

macro(WINDOWS_NATIVE_PATH _var _path)
	cmake_path(SET ${_var} NORMALIZE "${_path}")
	cmake_path(NATIVE_PATH ${_var} NORMALIZE ${_var})
	message(STATUS "WINDOWS_NATIVE_PATH ${${_var}}")
endmacro()


macro(WINDOWS_SDK_NATIVE_PATH _var _subpath)
	cmake_path(SET ${_var} NORMALIZE "$ENV{WindowsSdkDir}/References/$ENV{WindowsSDKLibVersion}/${_subpath}")
	cmake_path(NATIVE_PATH ${_var} NORMALIZE ${_var})
	message(STATUS "WINDOWS_SDK_NATIVE_PATH ${${_var}}")
endmacro()

WINDOWS_SDK_NATIVE_PATH(METADATA_DIR Windows.Foundation.FoundationContract/4.0.0.0)
WINDOWS_SDK_NATIVE_PATH(FOUNDATION_CONTRACT Windows.Foundation.FoundationContract/4.0.0.0/Windows.Foundation.FoundationContract.winmd)

WINDOWS_NATIVE_PATH(MIDL_FILE ${CMAKE_CURRENT_LIST_DIR}/Sample.idl)
WINDOWS_NATIVE_PATH(WINMD_NATIVE_PATH ${WINMD_FILE})
WINDOWS_NATIVE_PATH(OUT_DIR ${CMAKE_CURRENT_BINARY_DIR})

add_custom_command(
	OUTPUT ${WINMD_FILE}
	COMMAND ${MIDL_EXE} /nologo /winrt /nomidl /metadata_dir ${METADATA_DIR} /reference ${FOUNDATION_CONTRACT} /winmd ${WINMD_NATIVE_PATH} ${MIDL_FILE}
	MAIN_DEPENDENCY ${MIDL_FILE}
	COMMENT "Generating winmd file"
)

add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/module.g.cpp
	COMMAND "$<TARGET_FILE:CppWinRT>" -in ${WINMD_NATIVE_PATH} -reference local -component "${OUT_DIR}/generated" -output ${OUT_DIR} -pch .
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	MAIN_DEPENDENCY ${WINMD_FILE}
	COMMENT "Generating WinRT component files"
)

install(TARGETS Sample)
install(FILES ${WINMD_FILE} TYPE BIN)
