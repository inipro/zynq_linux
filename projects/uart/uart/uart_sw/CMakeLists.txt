cmake_minimum_required(VERSION 2.8.9)

project(uart_test)

set(SRCS main.c PmodCLS.c uart.c)

add_executable(uart_test ${SRCS})
