# AES Crypt (Linux source code)

The Linux source code in the git repository is intended for use with CMake or
"The Autotools".

## CMake build

Change to the Linux directory and issue the following commands to create
a release build:

```bash
cmake -B build -S . --install-prefix=/usr -DCMAKE_BUILD_TYPE:STRING=Release
cmake --build build --parallel
```

The aescrypt and aescrypt_keygen binaries will be placed in the directory
`build/src/` once the build completes.

If you wish to install the two binary files `aescrypt` and `aescrypt_keygen`,
just run this command:

```bash
cmake --install build
```

To invoke the tests to ensure everything is working properly, do the following:

```bash
cd build
make test
```

## Using Autotools

Install these from your Linus distribution packages:

* autoconf
* automake
* libtool

Before you can build the software, you need to run the
following command:

```bash
autoreconf -ivf
```

Note that the package maintainers, when producing an official release,
will run the above command and only publish the source files needed
to run "configure" and "make".  Official source releases can be downloaded
from [aescrypt.com](https://www.aescrypt.com/download/).

Package maintainers can create a tarball using the following command:

```bash
make dist
```
