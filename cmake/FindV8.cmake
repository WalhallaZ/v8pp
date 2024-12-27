# Based on https://raw.githubusercontent.com/nicehash/cpp-ethereum/master/cmake/Findv8.cmake
#
# Find the v8 includes and library
#
# This module defines
#  V8_INCLUDE_DIRS, where to find header, etc.
#  V8_LIBRARIES, the libraries needed to use v8.
#  V8_FOUND, If false, do not try to use v8.

set(V8_ROOT_DIR "D:/source/repos/v8/v8")
set(V8_INCLUDE_DIRS "${V8_ROOT_DIR}/include")

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(V8_LIB_DIR "${V8_ROOT_DIR}/out.gn/shared-dbg")
else()
    set(V8_LIB_DIR "${V8_ROOT_DIR}/out.gn/shared")
endif()

find_library(V8_LIB PATHS "${V8_LIB_DIR}" NAMES v8 v8.dll.lib)
find_library(V8_LIBPLATFORM PATHS "${V8_LIB_DIR}" NAMES v8_libplatform v8_libplatform.dll.lib)

if(WIN32)
    find_file(V8_DLL v8.dll "${V8_LIB_DIR}")
    find_file(V8_LIBPLATFORMDLL v8_libplatform.dll "${V8_LIB_DIR}")
endif()

# handle the QUIETLY and REQUIRED arguments and set V8_FOUND to TRUE
# if all listed variables are TRUE, hide their existence from configuration view
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(V8 DEFAULT_MSG V8_INCLUDE_DIRS V8_LIB V8_LIBPLATFORM)
mark_as_advanced(V8_INCLUDE_DIRS V8_LIB)

if(V8_FOUND)
	add_library(V8::v8 SHARED IMPORTED)
	add_library(V8::libplatform SHARED IMPORTED)
	if(WIN32)
		set_target_properties(V8::v8 PROPERTIES
			IMPORTED_IMPLIB ${V8_LIB} IMPORTED_LOCATION ${V8_DLL})
		set_target_properties(V8::libplatform PROPERTIES
			IMPORTED_IMPLIB ${V8_LIBPLATFORM} IMPORTED_LOCATION ${V8_LIBPLATFORMDLL})
	else()
		set_target_properties(V8::v8 PROPERTIES IMPORTED_LOCATION ${V8_LIB})
		set_target_properties(V8::libplatform PROPERTIES IMPORTED_LOCATION ${V8_LIBPLATFORM})
	endif()
	target_include_directories(V8::v8 INTERFACE ${V8_INCLUDE_DIRS})
	target_include_directories(V8::libplatform INTERFACE ${V8_INCLUDE_DIRS})
	target_link_libraries(V8::v8 INTERFACE V8::libplatform)

	if(NOT TARGET V8::V8)
		add_library(V8::V8 ALIAS V8::v8)
	endif()
endif()
