add_executable(sha256_test ${PROJECT_SOURCE_DIR}/src/sha256.c)
target_compile_definitions(sha256_test PRIVATE TEST)
add_executable(aes_test ${PROJECT_SOURCE_DIR}/src/aes.c)
target_compile_definitions(aes_test PRIVATE TEST)

add_test(NAME sha256_test
         COMMAND sha256_test)
add_test(NAME aes_test
         COMMAND aes_test)
add_test(NAME aescrypt_test
         COMMAND /bin/bash ${CMAKE_CURRENT_SOURCE_DIR}/test.sh ${aescrypt_BINARY_DIR})
