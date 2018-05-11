# AES Crypt (Linux source code)

The Linux source code in the git respository is intended for use with
"The Autotools". This includes the following packages: autoconf; automake; and, libtool.
Install these from your distro packages.

Before you can build the software, you need to run the
following command:

```
autoreconf -ivf 
```

Note that the package maintainers, when producing an official release,
will run the above command and only publish the source files needed
to run "configure" and "make".  Official source releases can be downloaded
from https://www.aescrypt.com/.

Package maintainers can create a tarball using the following command:

```
make dist 
```

## CMake build

    mkdir build
    cd build
    cmake ../
    make


