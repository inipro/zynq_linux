cmake_minimum_required(VERSION 2.8.9)

project(gpio_test)

set(SRCS main.c)

include_directories(lib/include)
link_directories(lib)
add_executable(gpio_test ${SRCS})

target_link_libraries(gpio_test gpio)
