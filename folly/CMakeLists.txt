# Copyright (c) Facebook, Inc. and its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.0.2 FATAL_ERROR)
# We use the GoogleTest module if it is available (only in CMake 3.9+)
# It requires CMP0054 and CMP0057 to be enabled.
if (POLICY CMP0054)
  cmake_policy(SET CMP0054 NEW)
endif()
if (POLICY CMP0057)
  cmake_policy(SET CMP0057 NEW)
endif()

# CMP0075 Include file check macros honor CMAKE_REQUIRED_LIBRARIES
if(POLICY CMP0075)
  cmake_policy(SET CMP0075 NEW)
endif()

# includes
set(CMAKE_MODULE_PATH
  "${CMAKE_CURRENT_SOURCE_DIR}/CMake"
  # for in-fbsource builds
  "${CMAKE_CURRENT_SOURCE_DIR}/../opensource/fbcode_builder/CMake"
  # For shipit-transformed builds
  "${CMAKE_CURRENT_SOURCE_DIR}/build/fbcode_builder/CMake"
  ${CMAKE_MODULE_PATH})

# package information
set(PACKAGE_NAME      "folly")
if (NOT DEFINED PACKAGE_VERSION)
  set(PACKAGE_VERSION   "0.58.0-dev")
endif()
set(PACKAGE_STRING    "${PACKAGE_NAME} ${PACKAGE_VERSION}")
set(PACKAGE_TARNAME   "${PACKAGE_NAME}-${PACKAGE_VERSION}")
set(PACKAGE_BUGREPORT "https://github.com/facebook/folly/issues")

# 150+ tests in the root folder anyone? No? I didn't think so.
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

project(${PACKAGE_NAME} CXX C)

set(INCLUDE_INSTALL_DIR include CACHE STRING
    "The subdirectory where header files should be installed")
set(LIB_INSTALL_DIR lib CACHE STRING
    "The subdirectory where libraries should be installed")
set(BIN_INSTALL_DIR bin CACHE STRING
    "The subdirectory where binaries should be installed")
set(CMAKE_INSTALL_DIR lib/cmake/folly CACHE STRING
    "The subdirectory where CMake package config files should be installed")

option(BUILD_SHARED_LIBS
  "If enabled, build folly as a shared library.  \
  This is generally discouraged, since folly does not commit to having \
  a stable ABI."
  OFF
)
# Mark BUILD_SHARED_LIBS as an "advanced" option, since enabling it
# is generally discouraged.
mark_as_advanced(BUILD_SHARED_LIBS)
set(FOLLY_SUPPORT_SHARED_LIBRARY "${BUILD_SHARED_LIBS}")

include(FBBuildOptions)
fb_activate_static_library_option()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(TOP_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(FOLLY_DIR "${CMAKE_CURRENT_SOURCE_DIR}/folly")
set(
  FOLLY_DIR_PREFIXES
  "${CMAKE_CURRENT_SOURCE_DIR}:${CMAKE_CURRENT_BINARY_DIR}"
)

include(GNUInstallDirs)

set(CMAKE_THREAD_PREFER_PTHREAD ON)
set(THREADS_PREFER_PTHREAD_FLAG ON)

find_package(Threads REQUIRED)
set(FOLLY_HAVE_PTHREAD "${CMAKE_USE_PTHREADS_INIT}")
list(APPEND CMAKE_REQUIRED_LIBRARIES Threads::Threads)
list(APPEND FOLLY_LINK_LIBRARIES Threads::Threads)


include(FollyCompilerUnix)
include(FollyFunctions)

include(folly-deps) # Find the required packages

include(FollyConfigChecks)
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/CMake/folly-config.h.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/folly/folly-config.h
)

# Define FOLLY_XLOG_STRIP_PREFIXES when compiling our sources so that
# folly/logging will automatically choose the correct log category names,
# using only the relative portion of the source file name inside the
# folly repository.
set_property(
  DIRECTORY
  ${CMAKE_CURRENT_SOURCE_DIR}
  APPEND
  PROPERTY
  COMPILE_DEFINITIONS
  "FOLLY_XLOG_STRIP_PREFIXES=\"${CMAKE_SOURCE_DIR}:${CMAKE_BINARY_DIR}\""
)

# We currently build the main libfolly library by finding all sources
# and header files.  We then exclude specific files below.
#
# In the future it would perhaps be nicer to explicitly list the files we want
# to include, and to move the source lists in to separate per-subdirectory
# CMakeLists.txt files.
auto_sources(files "*.cpp" "RECURSE" "${FOLLY_DIR}")
auto_sources(hfiles "*.h" "RECURSE" "${FOLLY_DIR}")

# Exclude tests, benchmarks, and other standalone utility executables from the
# library sources.  Test sources are listed separately below.
REMOVE_MATCHES_FROM_LISTS(files hfiles
  MATCHES
    "^${FOLLY_DIR}/build/"
    "^${FOLLY_DIR}/experimental/exception_tracer/"
    "^${FOLLY_DIR}/logging/example/"
    "^${FOLLY_DIR}/(.*/)?test/"
    "^${FOLLY_DIR}/tools/"
    "Benchmark.cpp$"
    "Test.cpp$"
)

list(REMOVE_ITEM files
  ${FOLLY_DIR}/experimental/JSONSchemaTester.cpp
  ${FOLLY_DIR}/experimental/io/HugePageUtil.cpp
  ${FOLLY_DIR}/python/error.cpp
  ${FOLLY_DIR}/python/executor.cpp
  ${FOLLY_DIR}/python/fibers.cpp
  ${FOLLY_DIR}/python/GILAwareManualExecutor.cpp
  ${FOLLY_DIR}/experimental/symbolizer/Addr2Line.cpp
)

list(REMOVE_ITEM hfiles
  ${FOLLY_DIR}/python/fibers.h
  ${FOLLY_DIR}/python/GILAwareManualExecutor.h
)

# Explicitly include utility library code from inside
# test subdirs
list(APPEND files
  ${FOLLY_DIR}/io/async/test/ScopedBoundPort.cpp
  ${FOLLY_DIR}/io/async/test/SocketPair.cpp
  ${FOLLY_DIR}/io/async/test/TimeUtil.cpp
)

list(APPEND hfiles
  ${FOLLY_DIR}/container/test/F14TestUtil.h
  ${FOLLY_DIR}/container/test/TrackingTypes.h
  ${FOLLY_DIR}/io/async/test/AsyncSSLSocketTest.h
  ${FOLLY_DIR}/io/async/test/AsyncSocketTest.h
  ${FOLLY_DIR}/io/async/test/AsyncSocketTest2.h
  ${FOLLY_DIR}/io/async/test/BlockingSocket.h
  ${FOLLY_DIR}/io/async/test/MockAsyncSocket.h
  ${FOLLY_DIR}/io/async/test/MockAsyncServerSocket.h
  ${FOLLY_DIR}/io/async/test/MockAsyncSSLSocket.h
  ${FOLLY_DIR}/io/async/test/MockAsyncTransport.h
  ${FOLLY_DIR}/io/async/test/MockAsyncUDPSocket.h
  ${FOLLY_DIR}/io/async/test/MockTimeoutManager.h
  ${FOLLY_DIR}/io/async/test/ScopedBoundPort.h
  ${FOLLY_DIR}/io/async/test/SocketPair.h
  ${FOLLY_DIR}/io/async/test/TestSSLServer.h
  ${FOLLY_DIR}/io/async/test/TimeUtil.h
  ${FOLLY_DIR}/io/async/test/UndelayedDestruction.h
  ${FOLLY_DIR}/io/async/test/Util.h
  ${FOLLY_DIR}/synchronization/test/Semaphore.h
  ${FOLLY_DIR}/test/DeterministicSchedule.h
  ${FOLLY_DIR}/test/JsonTestUtil.h
  ${FOLLY_DIR}/test/TestUtils.h
)

# Exclude specific sources if we do not have third-party libraries
# required to build them.
list(REMOVE_ITEM files
  ${FOLLY_DIR}/experimental/io/AsyncIO.cpp
)
list(REMOVE_ITEM hfiles
  ${FOLLY_DIR}/experimental/io/AsyncIO.h
)


  list(REMOVE_ITEM files
    ${FOLLY_DIR}/experimental/io/IoUring.cpp
    ${FOLLY_DIR}/experimental/io/IoUringBackend.cpp
  )
  list(REMOVE_ITEM hfiles
    ${FOLLY_DIR}/experimental/io/IoUring.h
    ${FOLLY_DIR}/experimental/io/IoUringBackend.h
  )

  list(REMOVE_ITEM files
    ${FOLLY_DIR}/experimental/io/AsyncBase.cpp
    ${FOLLY_DIR}/experimental/io/PollIoBackend.cpp
    ${FOLLY_DIR}/experimental/io/SimpleAsyncIO.cpp
  )
  list(REMOVE_ITEM hfiles
    ${FOLLY_DIR}/experimental/io/AsyncBase.h
    ${FOLLY_DIR}/experimental/io/PollIoBackend.h
    ${FOLLY_DIR}/experimental/io/SimpleAsyncIO.h
  )


# Remove LIBSODIUM files
list(REMOVE_ITEM files
  ${FOLLY_DIR}/experimental/crypto/Blake2xb.cpp
  ${FOLLY_DIR}/experimental/crypto/detail/MathOperation_AVX2.cpp
  ${FOLLY_DIR}/experimental/crypto/detail/MathOperation_Simple.cpp
  ${FOLLY_DIR}/experimental/crypto/detail/MathOperation_SSE2.cpp
  ${FOLLY_DIR}/experimental/crypto/LtHash.cpp
)
list(REMOVE_ITEM hfiles
  ${FOLLY_DIR}/experimental/crypto/Blake2xb.h
  ${FOLLY_DIR}/experimental/crypto/detail/LtHashInternal.h
  ${FOLLY_DIR}/experimental/crypto/LtHash-inl.h
  ${FOLLY_DIR}/experimental/crypto/LtHash.h
)

# Remove GFLAG files
list(REMOVE_ITEM files
  ${FOLLY_DIR}/experimental/NestedCommandLineApp.cpp
  ${FOLLY_DIR}/experimental/ProgramOptions.cpp
)
list(REMOVE_ITEM hfiles
  ${FOLLY_DIR}/experimental/NestedCommandLineApp.h
  ${FOLLY_DIR}/experimental/ProgramOptions.h
)

set(PCLMUL_FILES
  ${FOLLY_DIR}/hash/detail/ChecksumDetail.cpp
  ${FOLLY_DIR}/hash/detail/Crc32CombineDetail.cpp
  ${FOLLY_DIR}/hash/detail/Crc32cDetail.cpp
)

check_cxx_compiler_flag(-mpclmul COMPILER_HAS_M_PCLMUL)

if (COMPILER_HAS_M_PCLMUL)
  message(
    STATUS
    "compiler has flag pclmul, setting compile flag for ${PCLMUL_FILES}"
  )
  set_source_files_properties(
    ${PCLMUL_FILES}
    PROPERTIES
    COMPILE_OPTIONS
    -mpclmul
  )
else()
  message(
    STATUS
    "compiler does not have flag pclmul, skipping setting compile flags for ${PCLMUL_FILES}"
  )
endif()

message("Setting folly_base OBJECT")

add_library(folly_base OBJECT
  ${files} ${hfiles}
  ${CMAKE_CURRENT_BINARY_DIR}/folly/folly-config.h
)

message("Checking build shared libs")

if (BUILD_SHARED_LIBS)
  set_property(TARGET folly_base PROPERTY POSITION_INDEPENDENT_CODE ON)
endif()

message("Auto source group")

auto_source_group(folly ${FOLLY_DIR} ${files} ${hfiles})

message("Apply folly compile")

apply_folly_compile_options_to_target(folly_base)

# Add the generated files to the correct source group.
source_group("folly" FILES ${CMAKE_CURRENT_BINARY_DIR}/folly/folly-config.h)

# Generate pkg-config variables from folly_deps before we add our own
# build/install-time include directory generator expressions
include(GenPkgConfig)

gen_pkgconfig_vars(FOLLY_PKGCONFIG folly_deps)

target_include_directories(folly_deps
  BEFORE
  INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

target_include_directories(folly_deps
  INTERFACE
    $<INSTALL_INTERFACE:include>
)

message("Including folly_base")

target_include_directories(folly_base
  PUBLIC
    $<TARGET_PROPERTY:folly_deps,INTERFACE_INCLUDE_DIRECTORIES>
)


target_compile_definitions(folly_base
  PUBLIC
    $<TARGET_PROPERTY:folly_deps,INTERFACE_COMPILE_DEFINITIONS>
)

set(FOLLY_INSTALL_TARGETS folly folly_deps)

option(PYTHON_EXTENSIONS
  "Build Python Bindings for Folly, requires Cython and (BUILD_SHARED_LIBS=ON)"
  OFF
)

add_library(folly
  $<TARGET_OBJECTS:folly_base>
)

message("Setting property")

set_property(TARGET folly PROPERTY VERSION ${PACKAGE_VERSION})

apply_folly_compile_options_to_target(folly)

target_compile_features(folly INTERFACE cxx_generic_lambdas)

target_link_libraries(folly PUBLIC folly_deps)

# Test utilities exported for use by downstream projects
add_library(folly_test_util
  ${FOLLY_DIR}/test/DeterministicSchedule.cpp
  ${FOLLY_DIR}/test/JsonTestUtil.cpp
)

set_property(TARGET folly_test_util PROPERTY VERSION ${PACKAGE_VERSION})
target_link_libraries(folly_test_util
  PUBLIC
    ${BOOST_LIBRARIES}
    folly
    ${LIBGMOCK_LIBRARIES}
)

apply_folly_compile_options_to_target(folly_test_util)

list(APPEND FOLLY_INSTALL_TARGETS folly_test_util)

install(TARGETS ${FOLLY_INSTALL_TARGETS}
  EXPORT folly
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION ${LIB_INSTALL_DIR}
  ARCHIVE DESTINATION ${LIB_INSTALL_DIR})

auto_install_files(folly ${FOLLY_DIR}
  ${hfiles}
)

install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/folly/folly-config.h
  DESTINATION ${INCLUDE_INSTALL_DIR}/folly
  COMPONENT dev
)

message("Generating folly-config")

# Generate the folly-config.cmake file for installation so that
# downstream projects that use on folly can easily depend on it in their CMake
# files using "find_package(folly CONFIG)"

include(CMakePackageConfigHelpers)

configure_package_config_file(
  CMake/folly-config.cmake.in
  folly-config.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_DIR}
  PATH_VARS
    INCLUDE_INSTALL_DIR
    CMAKE_INSTALL_DIR
)

install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/folly-config.cmake
  DESTINATION ${CMAKE_INSTALL_DIR}
  COMPONENT dev
)

install(
  EXPORT folly
  DESTINATION ${CMAKE_INSTALL_DIR}
  NAMESPACE Folly::
  FILE folly-targets.cmake
  COMPONENT dev
)

# Generate a pkg-config file so that downstream projects that don't use
# CMake can depend on folly using pkg-config.
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/CMake/libfolly.pc.in
  ${CMAKE_CURRENT_BINARY_DIR}/libfolly.pc.gen
  @ONLY
)

message("Specifying target")

# Specify target to allow resolving generator expressions requiring
# a target for CMake >=3.19. See #1414.
# VERSION_GREATER_EQUAL isn't available before CMake 3.7.
if(NOT CMAKE_VERSION VERSION_LESS 3.19)
  set(target_arg TARGET folly_deps)
endif()

file(
  GENERATE
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/libfolly.pc
  INPUT ${CMAKE_CURRENT_BINARY_DIR}/libfolly.pc.gen
  ${target_arg}
)

message(" Installing Final")

install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/libfolly.pc
  DESTINATION ${LIB_INSTALL_DIR}/pkgconfig
  COMPONENT dev
)

add_subdirectory(folly)
