# Used as the public API for including in other projects.
set(
  LIBWREN_HEADERS
  include/wren.h
  include/wren.hpp
)

# The sources to compile for libwren.
set(
  LIBWREN_SOURCES
  vm/wren_compiler.c
  vm/wren_core.c
  vm/wren_debug.c
  vm/wren_primitive.c
  vm/wren_utils.c
  vm/wren_value.c
  vm/wren_vm.c
  $<$<BOOL:${WREN_OPT_META}>:optional/wren_opt_meta.c>
  $<$<BOOL:${WREN_OPT_RANDOM}>:optional/wren_opt_random.c>
)

# By enabling this while still defining a static library target, it allows
# for building both a static and a shared library in one script.
set(BUILD_SHARED_LIBS ON)

# Add the various targets.
add_library(wren OBJECT ${LIBWREN_SOURCES})
add_library(wren_static STATIC $<TARGET_OBJECTS:wren>)
add_library(wren_shared SHARED $<TARGET_OBJECTS:wren>)

#-------------------------------------------------------------------------------

# Set properties for the various targets.
set_target_properties(
  wren PROPERTIES
  C_STANDARD 99
  C_STANDARD_REQUIRED OFF
  C_EXTENSIONS OFF
  POSITION_INDEPENDENT_CODE 1
  PUBLIC_HEADER "${LIBWREN_HEADERS}"
  VERSION ${PROJECT_VERSION}
  S0VERSION ${API_VERSION}
)

set_target_properties(
  wren_static PROPERTIES
  OUTPUT_NAME wren
  ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_DIRECTORY}
  LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_DIRECTORY}
  RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIRECTORY}
)

set_target_properties(
  wren_shared PROPERTIES
  OUTPUT_NAME wren
  ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_DIRECTORY}
  LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_DIRECTORY}
  RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIRECTORY}
)

# Set include directories for the main library target.
target_include_directories(
  wren PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}/include
  ${CMAKE_CURRENT_SOURCE_DIR}/optional
  ${CMAKE_CURRENT_SOURCE_DIR}/vm
)

# Configure the compiler flags.
target_compile_options(
  wren PRIVATE
  $<$<C_COMPILER_ID:Clang,GNU>:
    -Wall
    -Wextra
    -Wno-unused-parameter
  >
  $<$<C_COMPILER_ID:GNU>:
    $<$<CONFIG:Debug>:-ggdb>
  >
  $<$<C_COMPILER_ID:Clang>:
    $<$<NOT:$<PLATFORM_ID:Windows>>:
      $<$<CONFIG:Debug>:-glldb>
    >
  >
  $<$<C_COMPILER_ID:MSVC>:
    /W2
    $<$<CONFIG:Debug>:/Zi>
  >
)

# Configure target definitions.
target_compile_definitions(
  wren PRIVATE
  $<$<CONFIG:Debug>:DEBUG>
  WREN_NAN_TAGGING=$<IF:$<BOOL:${WREN_NAN_TAGGING}>,1,0>
  WREN_COMPUTED_GOTO=$<IF:$<BOOL:${WREN_COMPUTED_GOTO}>,1,0>
  WREN_OPT_META=$<IF:$<BOOL:${WREN_OPT_META}>,1,0>
  WREN_OPT_RANDOM=$<IF:$<BOOL:${WREN_OPT_RANDOM}>,1,0>
  WREN_DEBUG_GC_STRESS=$<IF:$<BOOL:${WREN_DEBUG_GC_STRESS}>,1,0>
  WREN_DEBUG_TRACE_MEMORY=$<IF:$<BOOL:${WREN_DEBUG_TRACE_MEMORY}>,1,0>
  WREN_DEBUG_TRACE_GC=$<IF:$<BOOL:${WREN_DEBUG_TRACE_GC}>,1,0>
  WREN_DEBUG_DUMP_COMPILED_CODE=$<IF:$<BOOL:${WREN_DEBUG_DUMP_COMPILED_CODE}>,1,0>
  WREN_DEBUG_TRACE_INSTRUCTIONS=$<IF:$<BOOL:${WREN_DEBUG_TRACE_INSTRUCTIONS}>,1,0>
)

# Copy the include headers to the build directory for convenience.
file(COPY ${LIBWREN_HEADERS} DESTINATION "${OUTPUT_DIRECTORY}/include")
