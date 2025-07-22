# Define the source files for the target
set(TEST_SOURCES
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
    main.c
    test.c
)

# Add the executable target.
add_executable(wren_test ${TEST_SOURCES})

# Normalize the output name for the executable target.
set_target_properties(
    wren_test PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${MAIN_BINARY_DIR}/${CMAKE_BUILD_TYPE}
)

# Add extra compiler flags for the executable target.
target_compile_options(
    wren_test PRIVATE
    $<$<NOT:$<PLATFORM_ID:Windows>>:
        $<$<STREQUAL:$<CONFIG>,Debug>:-ggdb>
        $<$<STREQUAL:$<CONFIG>,Debug>:-DDEBUG>
    >
    $<$<PLATFORM_ID:Windows>:
        $<$<STREQUAL:$<CONFIG>,Debug>:/Z7>
        $<$<STREQUAL:$<CONFIG>,Debug>:/DDEBUG>
    >
)

# Link with wren using the interface (this includes providing the headers.)
target_link_libraries(wren_test PRIVATE wren::wren)

# On Windows, 'libm' is built in to MSVC and is not a separate library,
# so only link it if not on Windows.
if(NOT WIN32)
    target_link_libraries(wren_test PRIVATE m)
endif()
