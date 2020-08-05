cmake_minimum_required(VERSION 3.16)
project(cintcode C)

set(CMAKE_C_STANDARD 99)
add_library(cintcode SHARED library.c library.h)

if (UNIX)
	include_directories(SYSTEM /usr/include)
	target_link_libraries(cintcode tclstub8.6)
endif (UNIX)

if (WIN32)
	include_directories(SYSTEM /c/Tcl/include)
	link_directories(SYSTEM /c/Tcl/lib)
	target_link_libraries(cintcode tclstub86)
endif (WIN32)

add_definitions(-DUSE_TCL_STUBS)
