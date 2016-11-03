cmake_minimum_required(VERSION 2.8.9)

project(gpio_test)

set(SRCS main.c gpio.c)

add_executable(gpio_test ${SRCS})
