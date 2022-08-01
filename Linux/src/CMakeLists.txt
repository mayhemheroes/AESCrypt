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

add_executable(aescrypt_keygen
   aescrypt_keygen.c
   aes.c
   aesrandom.c
   sha256.c
   util.c
   keyfile.c
   password.c)

target_include_directories(aescrypt_keygen
   PRIVATE
       $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)

# Install target and associated include files
install(TARGETS aescrypt aescrypt_keygen)
