cmake_minimum_required(VERSION 2.8.9)

project(i2c_test)

set(SRCS main.c PmodCLS.c i2c.c)

add_executable(i2c_test ${SRCS})
