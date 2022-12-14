
cmake_minimum_required(VERSION 3.7.2)

project(hello-world C)

add_library(lib_hello hello.c)
target_include_directories(lib_hello PUBLIC include)
target_link_libraries(
        lib_hello
        lib_sel4cp_imx8mm
)
