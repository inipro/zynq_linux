cmake_minimum_required(VERSION 2.8.9)

project(spi_test)

set(SRCS main.c PmodCLS.c spi.c)

add_executable(spi_test ${SRCS})
