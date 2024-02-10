#! /bin/bash

set -e

cd dropbear

echo "Generating build tools"
docker run -v $(pwd):/work ewpratten/kolib_toolchain:crosstools /bin/bash -c 'cd /work; autoconf; autoheader'

echo "Configuring dropbear to target arm-kobo-linux-gnueabihf"
docker run -v $(pwd):/work ewpratten/kolib_toolchain:crosstools /bin/bash -c 'export PATH="/root/x-tools/arm-kobo-linux-gnueabihf/bin:$PATH"; cd /work; ./configure --host=arm-kobo-linux-gnueabihf --disable-zlib --disable-zlib CC="arm-kobo-linux-gnueabihf"-gcc LD="arm-kobo-linux-gnueabihf"-ld --disable-wtmp --disable-lastlog --disable-syslog --disable-utmpx --disable-utmp --disable-wtmpx --disable-loginfunc --disable-pututxline --disable-pututline --enable-bundled-libtom --disable-pam'

echo "Compiling dropbear"
docker run -v $(pwd):/work ewpratten/kolib_toolchain:crosstools /bin/bash -c 'export PATH="/root/x-tools/arm-kobo-linux-gnueabihf/bin:$PATH"; cd /work; make clean'
docker run -v $(pwd):/work ewpratten/kolib_toolchain:crosstools /bin/bash -c 'export PATH="/root/x-tools/arm-kobo-linux-gnueabihf/bin:$PATH"; cd /work; make PROGRAMS="dropbear"'

echo "Fetching binaries"
cp dropbearmulti ..
