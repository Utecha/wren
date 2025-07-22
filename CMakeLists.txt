cmake_minimum_required(VERSION 3.14)

#-------------------------------------------------------------------------------

# So that we don't conflict with the 'CMAKE_PROJECT_VERSION' of projects
# depending on Wren.
set(VERSION 0.4.1)

# Declare the project
project(
    wren
    VERSION ${VERSION}
    LANGUAGES C CXX
)

# Tell the user about it!
message("${PROJECT_NAME} version ${VERSION}")

#-------------------------------------------------------------------------------

# Exports 'compile_commands.json' for use with LSPs.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set a default build type if the user does not provide one.
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build Type" FORCE)
    message(STATUS "No build type set. Defaulting to '${CMAKE_BUILD_TYPE}'.")
endif()

#-------------------------------------------------------------------------------

# Define custom variables for the necessary include paths.
set(WREN_INCLUDE "${CMAKE_CURRENT_SOURCE_DIR}/src/include")
set(WREN_OPT_INCLUDE "${CMAKE_CURRENT_SOURCE_DIR}/src/optional")
set(WREN_VM_INCLUDE "${CMAKE_CURRENT_SOURCE_DIR}/src/vm")

# Set these here so that nested CMakeLists (i.e. src/CMakeLists.txt) are always
# able to reference these directories.
#
# This is important as, for example, `CMAKE_CURRENT_SOURCE_DIR` inside of the
# `src/CMakeLists.txt` would resolve to `wren/src` and not 'wren/'.
#
# We use 'CMAKE_CURRENT_X_DIR' and not 'CMAKE_X_DIR' to prevent Wren from
# outputting itself into an upper-level projects 'build' output directory.
# This keeps it local even if Wren is being built as a dependency.
set(MAIN_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}")
set(MAIN_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

#-------------------------------------------------------------------------------

# If 'ON', enables the use of NaN tagged doubles to represent Values. This
# provides a nice performance boost and even lowers memory usage a bit. It is
# not entirely portable, though, so it is an optional flag.
option(
    WREN_NAN_TAGGING
    "Enable the NaN tagging optimization"
    ON
)

# If 'ON', enables the use of computed gotos for the Wren VM's interpreter loop.
# This provides a nice boost in runtime performance but is not entirely
# portable, so it is an optional flag.
option(
    WREN_COMPUTED_GOTO
    "Enable the use of computed goto for the interpreter loop"
    ON
)

# If 'ON', compiles the optional built-in 'Meta' module with the rest of the
# project.
option(
    WREN_OPT_META
    "Include the optional 'meta' module"
    ON
)

# If 'ON', compiles the optional built-in 'Random' module with the rest of the
# project.
option(
    WREN_OPT_RANDOM
    "Include the optional 'random' module"
    ON
)

# If 'ON', compiles the 'wren_test' executable, which is both a test runner and
# a very basic CLI for running Wren scripts.
# NOTE: It is not the *official* CLI and as a result does not have the complete
# standard library. For a more usable CLI for actually using Wren, check out the
# 'wren-cli' or 'wren-console' projects.
option(
    WREN_TEST
    "Build the 'wren_test' test/simple script runner"
    ON
)

# Let the user know which options are enabled/disabled.
message(STATUS "Wren NaN Tagging: ${WREN_NAN_TAGGING}")
message(STATUS "Wren Computed Goto: ${WREN_COMPUTED_GOTO}")
message(STATUS "Wren Optional Module 'Meta': ${WREN_OPT_META}")
message(STATUS "Wren Optional Module 'Random': ${WREN_OPT_RANDOM}")
message(STATUS "Build Wren Test: ${WREN_TEST}")

#-------------------------------------------------------------------------------

# Add the 'src' subdirectory which handles the building of Wren itself.
add_subdirectory(src)

# If 'WREN_TEST' is enabled, add's the 'test' subdirectory to build the
# 'wren_test' executable.
if(WREN_TEST)
    add_subdirectory(test)
endif()
