# Define the source files for the target
set(SOURCES
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

# The 'base' library target. This target compiles the source code down into
# object files.
add_library(wren OBJECT ${SOURCES})

# The static library target. This target links the objects built by 'wren' into
# the final static library.
add_library(wren_static STATIC $<TARGET_OBJECTS:wren>)

# The shared library target. This target links the objects built by 'wren' into
# the final shared library.
add_library(wren_shared SHARED $<TARGET_OBJECTS:wren>)

# The interface for including Wren in CMake projects. This isn't used directly.
# Instead, the alias 'wren::wren' is used.
#
# This, however, stores the the base wren include directory as well as the
# appropriate link target.
#
# This is then later used by projects who depend on Wren. If a target needs
# access to the headers and to link with Wren, it simply does this:
#
# target_link_libaries(yourProject PRIVATE wren::wren)
add_library(wren_interface INTERFACE)
add_library(wren::wren ALIAS wren_interface)

#-------------------------------------------------------------------------------

# Normalize the output name for the library targets.
set_target_properties(
    wren_static PROPERTIES
    OUTPUT_NAME "wren"
)

set_target_properties(
    wren_shared PROPERTIES
    OUTPUT_NAME "wren"
)

# Ensures each build outputs to the correct directory.
set_target_properties(
    wren_static PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY ${MAIN_BINARY_DIR}/${CMAKE_BUILD_TYPE}
    LIBRARY_OUTPUT_DIRECTORY ${MAIN_BINARY_DIR}/${CMAKE_BUILD_TYPE}
    RUNTIME_OUTPUT_DIRECTORY ${MAIN_BINARY_DIR}/${CMAKE_BUILD_TYPE}
)

set_target_properties(
    wren_shared PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY ${MAIN_BINARY_DIR}/${CMAKE_BUILD_TYPE}
    LIBRARY_OUTPUT_DIRECTORY ${MAIN_BINARY_DIR}/${CMAKE_BUILD_TYPE}
    RUNTIME_OUTPUT_DIRECTORY ${MAIN_BINARY_DIR}/${CMAKE_BUILD_TYPE}
)

# Add the include directories to the base target.
target_include_directories(
    wren PRIVATE
    ${WREN_INCLUDE}
    ${WREN_OPT_INCLUDE}
    ${WREN_VM_INCLUDE}
)

# Add extra compiler flags for the base target.
target_compile_options(
    wren PRIVATE
    $<$<NOT:$<PLATFORM_ID:Windows>>:
        -fPIC
        $<$<STREQUAL:$<CONFIG>,Debug>:-ggdb>
        $<$<STREQUAL:$<CONFIG>,Debug>:-DDEBUG>
    >
    $<$<PLATFORM_ID:Windows>:
        $<$<STREQUAL:$<CONFIG>,Debug>:/Z7>
        $<$<STREQUAL:$<CONFIG>,Debug>:/DDEBUG>
    >
)

# Add defines to the base target.
target_compile_definitions(
    wren PRIVATE
    WREN_NAN_TAGGING=$<IF:$<BOOL:${WREN_NAN_TAGGING}>,1,0>
    WREN_COMPUTED_GOTO=$<IF:$<BOOL:${WREN_COMPUTED_GOTO}>,1,0>
    WREN_OPT_META=$<IF:$<BOOL:${WREN_OPT_META}>,1,0>
    WREN_OPT_RANDOM=$<IF:$<BOOL:${WREN_OPT_RANDOM}>,1,0>
)

# Add include directories for the interface target.
target_include_directories(
    wren_interface INTERFACE
    $<BUILD_INTERFACE:${MAIN_SRC_DIR}/src/include>
    $<INSTALL_INTERFACE:include>
)

# Link the appropriate library for the interface target.
if(BUILD_SHARED_LIBS)
    target_link_libraries(wren_interface INTERFACE wren_shared)
else()
    target_link_libraries(wren_interface INTERFACE wren_static)
endif()

#-------------------------------------------------------------------------------

# Setup installation for Wren.

include(GNUInstallDirs)

install(
    DIRECTORY ${WREN_INCLUDE}/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    FILES_MATCHING
        PATTERN "*.h"
        PATTERN "*.hpp"
)

install(
    TARGETS wren_static wren_shared EXPORT wrenTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(
    EXPORT wrenTargets
    NAMESPACE wren::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/wren
)

install(
    FILES
        "${MAIN_BINARY_DIR}/cmake/wrenConfig.cmake"
        "${MAIN_BINARY_DIR}/cmake/wrenConfigVersion.cmake"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/wren"
)

include(CMakePackageConfigHelpers)

write_basic_package_version_file(
    "${MAIN_BINARY_DIR}/cmake/wrenConfigVersion.cmake"
    VERSION "${VERSION}"
    COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
    "${MAIN_SRC_DIR}/cmake/wrenConfig.cmake.in"
    "${MAIN_BINARY_DIR}/cmake/wrenConfig.cmake"
    INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/wren"
)
