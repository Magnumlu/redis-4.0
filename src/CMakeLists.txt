#CMake最低版本要求
cmake_minimum_required (VERSION 2.8)

#项目信息
project (Redis-4.0.1)

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -pedantic -DREDIS_STATIC=''")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -W -Wno-missing-field-initializers")
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR})
SET(CMAKE_INSTALL_PREFIX /usr/local)

#依赖库目录
set(DEPS_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../deps)

set(DEPENDENCY_TARGETS linenoise lua)
execute_process(COMMAND make ${DEPENDENCY_TARGETS} WORKING_DIRECTORY ${DEPS_PATH})
execute_process(COMMAND sh ${CMAKE_CURRENT_SOURCE_DIR}/mkreleasehdr.sh WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

#依赖共享库
set(SHARED_LIBS -lm -ldl -lpthread)

add_subdirectory(${DEPS_PATH}/hiredis ${DEPS_PATH}/hiredis)

#link_directories(${DEPS_PATH}/hiredis)
link_directories(${DEPS_PATH}/lua/src)
link_directories(${DEPS_PATH}/linenoise)

#Inlcude files
include_directories(${DEPS_PATH}/hiredis
	${DEPS_PATH}/lua/src
	${DEPS_PATH}/linenoise)

set(HIREDIS_LIB hiredis)

set(LINENOISE_LIB ${DEPS_PATH}/linenoise/linenoise.o)
#find_library(LINENOISE_LIB	
#	NAMES linenoise.o
#	PATHS ${DEPS_PATH}/linenoise
#	NO_DEFAULT_PATH)

find_library(LUA_LIB
	NAMES liblua.a
	PATHS ${DEPS_PATH}/lua/src
	NO_DEFAULT_PATH)


set(REDIS_SERVER_LIST adlist.c quicklist.c ae.c anet.c dict.c server.c sds.c zmalloc.c lzf_c.c lzf_d.c pqsort.c zipmap.c sha1.c ziplist.c release.c networking.c util.c object.c db.c replication.c rdb.c t_string.c t_list.c t_set.c t_zset.c t_hash.c config.c aof.c pubsub.c multi.c debug.c sort.c intset.c syncio.c cluster.c crc16.c endianconv.c slowlog.c scripting.c bio.c rio.c rand.c memtest.c crc64.c bitops.c sentinel.c notify.c setproctitle.c blocked.c hyperloglog.c latency.c sparkline.c redis-check-rdb.c redis-check-aof.c geo.c lazyfree.c module.c evict.c expire.c geohash.c geohash_helper.c childinfo.c defrag.c siphash.c rax.c)
set(REDIS_BENCHMARK_LIST ae.c anet.c adlist.c zmalloc.c redis-benchmark.c)
set(REDIS_CLI_LIST anet.c adlist.c redis-cli.c zmalloc.c release.c anet.c ae.c crc64.c)

add_executable(redis-server ${REDIS_SERVER_LIST})
add_executable(redis-benchmark ${REDIS_BENCHMARK_LIST})
add_executable(redis-cli ${REDIS_CLI_LIST})

#target_link_libraries(redis-server ${HIREDIS_LIB} ${LUA_LIB} libm.so libdl.so libpthread.so) #直接指定动态库
target_link_libraries(redis-server ${HIREDIS_LIB} ${LUA_LIB} ${SHARED_LIBS})
target_link_libraries(redis-benchmark ${HIREDIS_LIB} ${SHARED_LIBS})
target_link_libraries(redis-cli ${LINENOISE_LIB} ${HIREDIS_LIB} ${SHARED_LIBS})


ADD_CUSTOM_COMMAND(
	  TARGET redis-server
	  COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/redis-server  ${CMAKE_CURRENT_SOURCE_DIR}/redis-sentinel
	  COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/redis-server  ${CMAKE_CURRENT_SOURCE_DIR}/redis-check-rdb
	  COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/redis-server  ${CMAKE_CURRENT_SOURCE_DIR}/redis-check-aof
)

install(TARGETS redis-server DESTINATION bin)
install(TARGETS redis-benchmark DESTINATION bin)
install(TARGETS redis-cli DESTINATION bin)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/redis-server DESTINATION bin RENAME redis-check-rdb)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/redis-server DESTINATION bin RENAME redis-check-aof)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/redis-server DESTINATION bin RENAME redis-sentinel)

