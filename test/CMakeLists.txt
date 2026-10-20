# Setup the project settings.
message("[ Configuring ] Wren Test")

# Set the target sources.
set(
  WREN_TEST_SOURCES
  main.c
  test.c
  api/api_tests.c
  api/benchmark.c
  api/call.c
  api/call_calls_foreign.c
  api/call_wren_call_root.c
  api/error.c
  api/foreign_class.c
  api/get_variable.c
  api/handle.c
  api/lists.c
  api/maps.c
  api/new_vm.c
  api/reset_stack_after_call_abort.c
  api/reset_stack_after_foreign_construct.c
  api/resolution.c
  api/slots.c
  api/user_data.c
)

# Add the executable target.
add_executable(wren_test ${WREN_TEST_SOURCES})

#-------------------------------------------------------------------------------

# Set properties for the target.
set_target_properties(
  wren_test PROPERTIES
  C_STANDARD 99
  C_STANDARD_REQUIRED OFF
  C_EXTENSIONS OFF
  RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIRECTORY}
)

# Add include directories to target.
target_include_directories(
  wren_test PRIVATE
  ${WREN_INCLUDE_DIRECTORY}
)

# Configure the compiler flags.
target_compile_options(
  wren_test PRIVATE
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

# Link libwren and libm
target_link_libraries(wren_test PRIVATE wren m)
