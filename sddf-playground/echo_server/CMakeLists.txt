
cmake_minimum_required(VERSION 3.7.2)

project(echo_server C)

add_library(lib_shared_ringbuffer ./libsharedringbuffer/shared_ringbuffer.c)
target_include_directories(lib_shared_ringbuffer PUBLIC ./libsharedringbuffer/include)
target_link_libraries(
        lib_shared_ringbuffer
        lib_sel4cp_imx8mm
)

add_library(lib_eth eth.c)
target_include_directories(lib_eth PUBLIC include)
target_link_libraries(
        lib_eth
        lib_sel4cp_imx8mm
        lib_shared_ringbuffer
)
