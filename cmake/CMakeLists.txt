cmake_minimum_required(VERSION 3.13)
project(yoga_odin LANGUAGES CXX)

if(NOT DEFINED YOGA_SOURCE_DIR)
    set(YOGA_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/../yoga")
endif()
file(TO_CMAKE_PATH "${YOGA_SOURCE_DIR}" YOGA_SOURCE_DIR)

if(NOT DEFINED YOGA_LIBRARY_TYPE)
    set(YOGA_LIBRARY_TYPE "SHARED")
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

file(GLOB_RECURSE YOGA_SOURCES CONFIGURE_DEPENDS
    "${YOGA_SOURCE_DIR}/yoga/*.cpp")

set(YOGA_SOURCES_CMAKE_STYLE "")
foreach(source_file IN LISTS YOGA_SOURCES)
    file(TO_CMAKE_PATH "${source_file}" source_file_cmake_style)
    list(APPEND YOGA_SOURCES_CMAKE_STYLE "${source_file_cmake_style}")
endforeach()

add_library(yoga ${YOGA_LIBRARY_TYPE} ${YOGA_SOURCES_CMAKE_STYLE})
set_target_properties(yoga PROPERTIES OUTPUT_NAME "yoga")
target_include_directories(yoga PUBLIC "${YOGA_SOURCE_DIR}")
