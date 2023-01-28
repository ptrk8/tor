

cmake_minimum_required(VERSION 3.7.2)
project(tor C)

#include_directories(${CMAKE_SOURCE_DIR}/sel4cp/release/sel4cp-sdk-1.2.6/board/imx8mm/debug/include/)
# Create Header-Only libraries for sel4cp and sel4. To be linked to sel4cp C programs.
add_library(lib_sel4cp_imx8mm INTERFACE)
target_include_directories(lib_sel4cp_imx8mm INTERFACE ${CMAKE_SOURCE_DIR}/sel4cp/release/sel4cp-sdk-1.2.6/board/imx8mm/debug/include/)

add_library(lib_sel4cp_tqma8xqp1gb INTERFACE)
target_include_directories(lib_sel4cp_tqma8xqp1gb INTERFACE ${CMAKE_SOURCE_DIR}/sel4cp/release/sel4cp-sdk-1.2.6/board/tqma8xqp1gb/debug/include/)

add_library(lib_sel4cp_zcu102 INTERFACE)
target_include_directories(lib_sel4cp_zcu102 INTERFACE ${CMAKE_SOURCE_DIR}/sel4cp/release/sel4cp-sdk-1.2.6/board/zcu102/debug/include/)

add_library(lib_sel4cp_rpi3b INTERFACE)
target_include_directories(lib_sel4cp_rpi3b INTERFACE ${CMAKE_SOURCE_DIR}/sel4cp-patrick/release/sel4cp-sdk-1.2.6/board/rpi3b/debug/include/)

add_subdirectory(sddf-serial/)
add_subdirectory(sddf-serial-rpi3/)
add_subdirectory(sddf-mmc/)
add_subdirectory(sddf-playground/)
add_subdirectory(hello-world/)
add_subdirectory(sel4cp-workshop/)



