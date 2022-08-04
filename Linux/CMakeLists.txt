cmake_minimum_required(VERSION 3.11)

option(aescrypt_BUILD_TESTS "Build Tests for AESCrypt" ON)

project(aescrypt
        VERSION 3.16.1
        DESCRIPTION "AES Crypt for Linux"
        LANGUAGES C)

add_subdirectory(src)
add_subdirectory(man)

include(CTest)

if(BUILD_TESTING AND aescrypt_BUILD_TESTS)
    add_subdirectory(test)
endif()
