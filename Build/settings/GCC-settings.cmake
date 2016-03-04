include(CheckCXXCompilerFlag)

CHECK_CXX_COMPILER_FLAG("-Wall" HAS_WALL_FLAG)
if(HAS_WALL_FLAG)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-register")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unknown-pragmas")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-function")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-sign-compare")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-missing-braces")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-comment")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-parentheses")
#   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-#pragma-messages")
#   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-#warnings")
#   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wunreachable-code") # not supported by GCC (ignored) but by clang

    # we want to re-activate these warnings later again!
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-reorder")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-variable")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unreachable-code")
endif(HAS_WALL_FLAG)

if (CMAKE_CXX_COMPILER MATCHES ".*clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-mismatched-tags")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-const-variable")
endif()

if ((${CMAKE_SYSTEM} MATCHES "Linux") AND CMAKE_COMPILER_IS_GNUCXX)
    message(WARNING "Enable compiler flags to work around Ubuntu 13.10 GCC bug: https://bugs.launchpad.net/ubuntu/+source/gcc-defaults/+bug/1228201")

    CHECK_CXX_COMPILER_FLAG("-Wl,--no-as-needed" HAS_NO_AS_NEEDED)
    if(HAS_NO_AS_NEEDED)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,--no-as-needed")
    endif(HAS_NO_AS_NEEDED)

    message(WARNING "Set compiler flags to enable this_thread::sleep_for with g++ 4.7 and 4.8")

    CHECK_CXX_COMPILER_FLAG("-D_GLIBCXX_USE_NANOSLEEP" HAS_USE_NANOSLEEP)
    if(HAS_USE_NANOSLEEP)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_GLIBCXX_USE_NANOSLEEP")
    endif()
    
    CHECK_CXX_COMPILER_FLAG("-D_GLIBCXX_USE_SCHED_YIELD" HAS_USE_SCHED_YIELD)
    if(HAS_USE_SCHED_YIELD)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_GLIBCXX_USE_SCHED_YIELD")
    endif()

    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")
endif()