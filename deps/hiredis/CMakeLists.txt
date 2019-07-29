#CMake最低版本要求
cmake_minimum_required (VERSION 2.8)

#项目信息
project (hiredis)

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -g -ggdb")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -W -Wstrict-prototypes -Wwrite-strings -Wno-unused-function")
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR})
#SET(CMAKE_INSTALL_PREFIX /usr/local)

#依赖共享库
#set(SHARED_LIBS -lm -ldl -lpthread)

aux_source_directory(. DIR_LIB_SRCS)
# 生成链接库
add_library (hiredis ${DIR_LIB_SRCS})

