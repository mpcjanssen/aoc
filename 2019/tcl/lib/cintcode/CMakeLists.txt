cmake_minimum_required(VERSION 3.16)
project(cintcode C)

set(CMAKE_C_STANDARD 99)

add_library(cintcode SHARED library.c library.h)
target_link_libraries(cintcode tclstub86)
add_definitions(-DUSE_TCL_STUBS)
