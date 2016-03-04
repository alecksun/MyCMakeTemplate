if(XCODE_VERSION)

    # add some custom settings to Xcode projects
    function(add_xcode_settings TARGET)
        # message(STATUS "Adding Xcode settings to project: ${TARGET}")

        set_target_properties(${TARGET} PROPERTIES XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD              "c++11")
        set_target_properties(${TARGET} PROPERTIES XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY                        "libc++")
        set_target_properties(${TARGET} PROPERTIES XCODE_ATTRIBUTE_COMBINE_HIDPI_IMAGES                     "YES")
        set_target_properties(${TARGET} PROPERTIES XCODE_ATTRIBUTE_WARNING_CFLAGS                           "") # clean out default value and set specific flags below
        set_target_properties(${TARGET} PROPERTIES XCODE_ATTRIBUTE_CLANG_WARN_EMPTY_BODY                    "YES")
        set_target_properties(${TARGET} PROPERTIES XCODE_ATTRIBUTE_GCC_WARN_INITIALIZER_NOT_FULLY_BRACKETED "YES")
        set_target_properties(${TARGET} PROPERTIES XCODE_ATTRIBUTE_GCC_WARN_ABOUT_RETURN_TYPE               "YES")
        set_target_properties(${TARGET} PROPERTIES XCODE_ATTRIBUTE_GCC_WARN_UNINITIALIZED_AUTOS             "YES")
        set_target_properties(${TARGET} PROPERTIES XCODE_ATTRIBUTE_GCC_WARN_UNUSED_VALUE                    "YES")
        set_target_properties(${TARGET} PROPERTIES XCODE_ATTRIBUTE_GCC_WARN_NON_VIRTUAL_DESTRUCTOR          "YES")
    endfunction(add_xcode_settings TARGET)

    # redefine the "add_executable" function to automatically add Xcode specific settings to each added executable
    function(add_executable TARGET)
        _add_executable(${TARGET} ${ARGN}) # call the original builtin "add_executable" function
        add_xcode_settings(${TARGET}) # add the Xcode settings to the target as well
    endfunction(add_executable TARGET)

    # redefine the "add_library" function to automatically add Xcode specific settings to each added library
    function(add_library TARGET)
        _add_library(${TARGET} ${ARGN}) # call the original builtin "add_library" function
        add_xcode_settings(${TARGET}) # add the Xcode settings to the target as well
    endfunction(add_library TARGET)

    # redefine the "add_custom_target" function to automatically add Xcode specific settings to each added target
    function(add_custom_target TARGET)
        _add_custom_target(${TARGET} ${ARGN}) # call the original builtin "add_custom_target" function
        add_xcode_settings(${TARGET}) # add the Xcode settings to the target as well
    endfunction(add_custom_target TARGET)

    # add c++ standard header include path explicitly in order to get the scan-build to find the standard headers
    set(CLANG_STANDARD_CXX_INCLUDE_PATH "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/c++/v1/")
    if(IS_DIRECTORY ${CLANG_STANDARD_CXX_INCLUDE_PATH})
        message(STATUS "Adding standard C++ library include path for fixing scan-build issues: ${CLANG_STANDARD_CXX_INCLUDE_PATH}")
        include_directories(${CLANG_STANDARD_CXX_INCLUDE_PATH})
    endif(IS_DIRECTORY ${CLANG_STANDARD_CXX_INCLUDE_PATH})

endif(XCODE_VERSION)