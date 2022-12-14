

cmake_minimum_required(VERSION 3.7.2)
project(tor C)

#include_directories(${CMAKE_SOURCE_DIR}/sel4cp/release/sel4cp-sdk-1.2.6/board/imx8mm/debug/include/)
add_library(lib_sel4cp_imx8mm INTERFACE)
target_include_directories(lib_sel4cp_imx8mm INTERFACE ${CMAKE_SOURCE_DIR}/sel4cp/release/sel4cp-sdk-1.2.6/board/imx8mm/debug/include/)

# Add our test directory.
add_subdirectory(sddf-serial/)
