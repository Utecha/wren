cmake_minimum_required(VERSION 3.20...3.30)

# Add the `cmake` directory to the CMAKE_MODULE_PATH for easier includes.
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# Setup the project settings.
project(wren VERSION 0.4.0 LANGUAGES C)
set(API_VERSION 040)

message("[ Configuring ] Wren ${CMAKE_PROJECT_VERSION} :: ${CMAKE_SYSTEM_NAME}")

#-------------------------------------------------------------------------------

# Export `compile_commands.json` to be read by LSP's.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set a default build type if one is not set by the user.
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Build Type" FORCE)
  message("No build type set. Defaulting to '${CMAKE_BUILD_TYPE}'.")
endif()

# The output directory varies by both platform and compiler toolchain.
# On Windows, if compiling with MSVC, the output directory is equal to
# `CMAKE_CURRENT_BINARY_DIR/CMAKE_BUILD_TYPE`.
#
# However, compiling using gcc or clang on Windows dumps it into
# `CMAKE_CURRENT_BINARY_DIR`. This applies to Linux and other platforms as
# well.
#
# Here, we normalize it so that all combinations result in an output to
# `CMAKE_CURRENT_BINARY_DIR/CMAKE_BUILD_TYPE`, i.e. `build/Debug/**`.
if(WIN32 AND ("${CMAKE_C_COMPILER_ID}" STREQUAL "MSVC"))
  # This is the same as `CMAKE_CURRENT_BINARY_DIR/CMAKE_BUILD_TYPE` for others.
  set(OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
else()
  set(OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE}")
endif()

# Used for the test runner to more safely get the include directory.
set(WREN_INCLUDE_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/src/include")

#-------------------------------------------------------------------------------

# Include the various tunable options for Wren.
include(Options)

# Add the CMakeLists.txt for the `src` and `test` directories.
add_subdirectory(src)
add_subdirectory(test)
