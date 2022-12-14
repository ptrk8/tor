
cmake_minimum_required(VERSION 3.7.2)

project(serial C)

#set(CMAKE_C_STANDARD 11)
#
#SET(CMAKE_BUILD_TYPE Debug)
#
#set(GCC_COMPILE_FLAGS "-Wall -Werror -Wvla")

add_library(lib_uart uart.c)
target_include_directories(lib_uart PUBLIC include)
target_link_libraries(
        lib_uart
        lib_sel4cp_imx8mm
)

add_library(lib_serial serial.c)
target_include_directories(lib_serial PUBLIC include)
target_link_libraries(
        lib_serial
        lib_sel4cp_imx8mm
)
