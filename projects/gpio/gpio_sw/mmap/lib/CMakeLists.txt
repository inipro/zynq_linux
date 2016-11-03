cmake_minimum_required(VERSION 2.8.9)

project(libgpio)

set(SRCS standalone_v5_3/xil_io.c standalone_v5_3/xil_assert.c 
standalone_v5_3/xplatform_info.c gpio_v4_0/xgpio.c gpio_v4_0/xgpio_sinit.c 
gpiops_v3_1/xgpiops.c gpiops_v3_1/xgpiops_intr.c
)

include_directories(include)
add_library(gpio SHARED ${SRCS})

install(TARGETS gpio DESTINATION ${CMAKE_SOURCE_DIR})
