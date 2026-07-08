#!/usr/bin/env bash
set -euo pipefail

[ -n "${SOURCE_DATE_EPOCH:-}" ] || unset SOURCE_DATE_EPOCH

: "${SANITIZER_FLAGS=-fsanitize=address,undefined -fno-sanitize-recover=all -fno-omit-frame-pointer}"
: "${DEBUG_FLAGS:=-g -gdwarf-3}"
: "${CC:=clang}" ; : "${CXX:=clang++}" ; : "${LIB_FUZZING_ENGINE:=-fsanitize=fuzzer}"
: "${MAYHEM_JOBS:=$(nproc)}"
export SANITIZER_FLAGS DEBUG_FLAGS CC CXX LIB_FUZZING_ENGINE MAYHEM_JOBS

cd "$SRC/Linux"
autoreconf -ivf

# 1) Test build (normal flags — oracle for mayhem/test.sh)
rm -rf build-test
mkdir build-test
(
  cd build-test
  env -u CFLAGS -u CXXFLAGS -u LDFLAGS \
    ../configure --disable-gui CC=gcc CFLAGS="-O2"
  make -j"$MAYHEM_JOBS" -C src aescrypt
)

# 2) Sanitized fuzz build
rm -rf build-fuzz
mkdir build-fuzz
(
  cd build-fuzz
  ../configure --disable-gui \
    CC="$CC" \
    CFLAGS="$SANITIZER_FLAGS $DEBUG_FLAGS -fsanitize=fuzzer-no-link" \
    LDFLAGS="$SANITIZER_FLAGS $DEBUG_FLAGS"

  FUZZ_COMPILE=( "$CC" $SANITIZER_FLAGS $DEBUG_FLAGS -fsanitize=fuzzer-no-link
    -DHAVE_CONFIG_H -I. -Isrc )
  mkdir -p src
  for src in aes sha256 password keyfile util; do
    "${FUZZ_COMPILE[@]}" -c "../src/${src}.c" -o "src/${src}.o"
  done
  "${FUZZ_COMPILE[@]}" -Dmain=mayhem_aescrypt_cli_main \
    -c ../src/aescrypt.c -o src/aescrypt_no_main.o
)

FUZZ_CFLAGS="$SANITIZER_FLAGS $DEBUG_FLAGS -fsanitize=fuzzer-no-link -DHAVE_CONFIG_H -I$SRC/Linux/build-fuzz -I$SRC/Linux/build-fuzz/src"
FUZZ_OBJS=(
  "$SRC/Linux/build-fuzz/src/aes.o"
  "$SRC/Linux/build-fuzz/src/sha256.o"
  "$SRC/Linux/build-fuzz/src/password.o"
  "$SRC/Linux/build-fuzz/src/keyfile.o"
  "$SRC/Linux/build-fuzz/src/util.o"
  "$SRC/Linux/build-fuzz/src/aescrypt_no_main.o"
)

"$CC" $FUZZ_CFLAGS -c "$SRC/mayhem/fuzz_aescrypt.c" -o /tmp/fuzz_aescrypt.o

"$CC" $SANITIZER_FLAGS $DEBUG_FLAGS $LIB_FUZZING_ENGINE \
  /tmp/fuzz_aescrypt.o "${FUZZ_OBJS[@]}" \
  -o /mayhem/aescrypt

"$CC" $SANITIZER_FLAGS $DEBUG_FLAGS \
  "$STANDALONE_FUZZ_MAIN" /tmp/fuzz_aescrypt.o "${FUZZ_OBJS[@]}" \
  -o /mayhem/aescrypt-standalone
