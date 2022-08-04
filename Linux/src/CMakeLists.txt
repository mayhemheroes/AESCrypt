# The iconv library is required for proper conversion from
# system locale strings to UTF16-LE strings
include(FindIconv)

if(NOT Iconv_FOUND)
    message(FATAL_ERROR "iconv library is not found, but required")
endif()

string(TIMESTAMP PACKAGE_DATE %Y-%m-%dT%H:%M:%SZ UTC)

# Build a version number into the binary library
configure_file(version.h.in version.h @ONLY)

add_executable(aescrypt
    aescrypt.c
    aes.c
    aesrandom.c
    sha256.c
    util.c
    keyfile.c
    password.c)
target_compile_definitions(aescrypt PRIVATE ENABLE_ICONV)
target_include_directories(aescrypt
    PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)
target_link_libraries(aescrypt PRIVATE Iconv::Iconv)

add_executable(aescrypt_keygen
    aescrypt_keygen.c
    aes.c
    aesrandom.c
    sha256.c
    util.c
    keyfile.c
    password.c)
target_compile_definitions(aescrypt_keygen PRIVATE ENABLE_ICONV)
target_include_directories(aescrypt_keygen
    PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)
target_link_libraries(aescrypt_keygen PRIVATE Iconv::Iconv)

# Install target and associated include files
install(TARGETS aescrypt aescrypt_keygen
        RUNTIME DESTINATION bin)
