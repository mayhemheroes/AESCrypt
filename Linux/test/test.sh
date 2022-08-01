#!/bin/bash -e
#
# Encrypting and decrypting text files
#     usage: test.sh [<aescrypt binary build directory>]
#
# If no directory is given, the script assumes aescrypt is in the
# current working directory.  That would be the case when the software
# is compiled using autotools.
#

if [ $# != 1 ] ; then
    # Check to see if aescrypt is in the current directory
    if [ ! -f ./aescrypt ] ; then
        echo Missing binary directory parameter
        exit 1
    fi
else
    cd $1 || exit 1
fi

# Test zero-length file
cat /dev/null > test.orig.txt
./aescrypt -e -p "praxis" test.orig.txt
cp test.orig.txt.aes test.txt.aes
./aescrypt -d -p "praxis" test.txt.aes
cmp test.orig.txt test.txt
rm test.orig.txt test.orig.txt.aes test.txt.aes test.txt
# Testing short file (one AES block)
echo "Testing..." > test.orig.txt
./aescrypt -e -p "praxis" test.orig.txt
cp test.orig.txt.aes test.txt.aes
./aescrypt -d -p "praxis" test.txt.aes
cmp test.orig.txt test.txt
rm test.orig.txt test.orig.txt.aes test.txt.aes test.txt

# Test password length boundary

# Test password length 0
cat /dev/null >test.passwd.txt
echo "Testing..." > test.txt

# Expecting a failure here, but reflect opposite result code
./aescrypt -e -p `cat test.passwd.txt` test.txt 2>/dev/null && \
    echo Password length test 1 failed && \
    exit 1 || \
    true
rm test.txt test.passwd.txt

# Test password length 1023
cat /dev/null >test.passwd.txt
for x in `seq 1 1023`; do printf X >>test.passwd.txt; done
echo "Testing..." > test.txt
./aescrypt -e -p `cat test.passwd.txt` test.txt
rm test.txt.aes test.txt test.passwd.txt

# Test password length 1024
cat /dev/null >test.passwd.txt
for x in `seq 1 1024`; do printf X >>test.passwd.txt; done
echo "Testing..." > test.txt
./aescrypt -e -p `cat test.passwd.txt` test.txt
rm test.txt.aes test.txt test.passwd.txt

# Test password length 1025
cat /dev/null >test.passwd.txt
for x in `seq 1 1025`; do printf X >>test.passwd.txt; done
echo "Testing..." > test.txt

# Expecting a failure here, but reflect opposite result code
./aescrypt -e -p `cat test.passwd.txt` test.txt 2>/dev/null && \
    echo Password length test 2 failed && \
    exit 1 || \
    true
rm test.txt test.passwd.txt

# Testing longer file
cat /dev/null >test.orig.txt
for i in `seq 1 50000`; do echo "This is a test" >>test.orig.txt; done
./aescrypt -e -p "praxis" test.orig.txt
cp test.orig.txt.aes test.txt.aes
./aescrypt -d -p "praxis" test.txt.aes
cmp test.orig.txt test.txt
rm test.orig.txt test.orig.txt.aes test.txt.aes test.txt

echo AESCrypt tests passed
