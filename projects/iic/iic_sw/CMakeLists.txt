cmake_minimum_required(VERSION 2.8.9)

project(iic_test)

set(SRCS main.c PmodCLS.c iic.c)

add_executable(iic_test ${SRCS})
