cmake_minimum_required(VERSION 3.15)
project(qb-firmware LANGUAGES C CXX ASM)

include(cmake/globals.cmake)
include(cmake/firmware.cmake)

add_subdirectory(qb/service)
