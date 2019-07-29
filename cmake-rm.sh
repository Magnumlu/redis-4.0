#!/bin/sh

rm -rf CMakeFiles/ CMakeCache.txt cmake_install.cmake Makefile

cd ./src
rm -rf CMakeFiles/ cmake_install.cmake Makefile

cd ../deps/hiredis
rm -rf CMakeFiles/ cmake_install.cmake Makefile

