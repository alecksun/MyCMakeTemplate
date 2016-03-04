project (OCRPrototype)

if (NOT CMAKE_BUILD_TYPE)
    set (CMAKE_BUILD_TYPE RelWithDebInfo)
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/Build/CMakeModules")

####################################################################################################################
#                                                PLATFORM SPECIFIC                                                 #
####################################################################################################################
if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    cmake_minimum_required (VERSION 2.8)
    include("${CMAKE_CURRENT_SOURCE_DIR}/Build/settings/GCC-settings.cmake")
    set(LIBRARY_FILE_EXTENSION "so")

    execute_process(COMMAND ${CMAKE_C_COMPILER} -dumpversion
                OUTPUT_VARIABLE GCC_VERSION)
    if (GCC_VERSION VERSION_LESS 4.8)
        message( FATAL_ERROR "GCC 4.8+ required to build LandXML SDK." )
    endif()

elseif (APPLE)
    cmake_minimum_required (VERSION 2.8.12.2)
    include("${CMAKE_CURRENT_SOURCE_DIR}/Build/settings/Xcode-settings.cmake")
    set(OCRPrototype_CXX_FLAGS "${OCRPrototype_CXX_FLAGS} -stdlib=libc++ -Wno-parentheses")
    set(LIBRARY_FILE_EXTENSION "dylib")
    set(CMAKE_MACOSX_RPATH 1)
else()
    cmake_minimum_required (VERSION 2.8)
endif()



####################################################################################################################
#                                                    FUNCTIONS                                                     #
####################################################################################################################
function(print_compiler_flags)
    if (${CMAKE_BUILD_TYPE} STREQUAL "Release")
        message("${CMAKE_BUILD_TYPE} C flags  : ${CMAKE_C_FLAGS_RELEASE}")
        message("${CMAKE_BUILD_TYPE} C++ flags: ${CMAKE_CXX_FLAGS_RELEASE}")
    elseif (${CMAKE_BUILD_TYPE} STREQUAL "RelWithDebInfo")
        message("${CMAKE_BUILD_TYPE} C flags  : ${CMAKE_C_FLAGS_RELWITHDEBINFO}")
        message("${CMAKE_BUILD_TYPE} C++ flags: ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
    else()
        message("${CMAKE_BUILD_TYPE} C flags  : ${CMAKE_C_FLAGS_DEBUG}")
        message("${CMAKE_BUILD_TYPE} C++ flags: ${CMAKE_CXX_FLAGS_DEBUG}")
    endif()
endfunction()




####################################################################################################################
#                                                 COMPILER FLAGS                                                   #
####################################################################################################################
set (OCRPrototype_C_FLAGS "${OCRPrototype_C_FLAGS} -march=corei7 -mtune=corei7 -msse4.1 -fPIC -DPIC -Wno-unused-result -Wno-unused-value -Wno-switch")
set (OCRPrototype_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OCRPrototype_CXX_FLAGS} ${OCRPrototype_C_FLAGS} -std=c++11")

set (CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${OCRPrototype_C_FLAGS} -DDEBUG -D_DEBUG")
set (CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${OCRPrototype_CXX_FLAGS} -DDEBUG -D_DEBUG")

set (CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${OCRPrototype_C_FLAGS}")
set (CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${OCRPrototype_CXX_FLAGS}")

set (CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -g ${OCRPrototype_C_FLAGS}")
set (CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g ${OCRPrototype_CXX_FLAGS}")

message("Top level compiler flags:")
print_compiler_flags()

add_definitions(
    -DBUILD_OCRPrototype
    -DUNICODE
)



# The version number.
set (OCRPrototype_VERSION_MAJOR 1)
set (OCRPrototype_VERSION_MINOR 0)

####################################################################################################################
#                                                 MAKE INSTALL                                                     #
####################################################################################################################
# Overwrites the install directory for CAM Extractors (/usr/local/bin is not suitable as a target directory).
# If required 'MY_OWN_INSTALL_PREFIX' can be overwritten from outside. This variable is used because
# 'CMAKE_INSTALL_PREFIX' is marked as 'CACHE INTERNAL' and we didn't find a way to overwrite it without a second variable.
set (MY_OWN_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/installed" CACHE PATH "Prefix prepended to install directories")
set (CMAKE_INSTALL_PREFIX "${MY_OWN_INSTALL_PREFIX}" CACHE INTERNAL "Prefix prepended to install directories" FORCE)


# uninstall target
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)

add_subdirectory(Source/)
