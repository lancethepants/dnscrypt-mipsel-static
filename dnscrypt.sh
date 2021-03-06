#!/bin/bash

set -e
set -x

mkdir ~/dnscrypt && cd ~/dnscrypt

BASE=`pwd`
SRC=$BASE/src
WGET="wget --prefer-family=IPv4"
DEST=$BASE/opt
LDFLAGS="-L$DEST/lib -Wl,--gc-sections"
CPPFLAGS="-I$DEST/include"
CFLAGS="-mtune=mips32 -mips32 -O3 -ffunction-sections -fdata-sections"	
CXXFLAGS=$CFLAGS
CONFIGURE="./configure --prefix=/opt --host=mipsel-linux"
MAKE="make -j`nproc`"
mkdir -p $SRC

############# ###############################################################
# LIBSODIUM # ###############################################################
############# ###############################################################

mkdir -p $SRC/sodium && cd $SRC/sodium
$WGET https://github.com/jedisct1/libsodium/releases/download/1.0.2/libsodium-1.0.2.tar.gz
tar zxvf libsodium-1.0.2.tar.gz
cd libsodium-1.0.2

LDFLAGS=$LDFLAGS \
CPPFLAGS=$CPPFLAGS \
CFLAGS=$CFLAGS \
CXXFLAGS=$CXXFLAGS \
$CONFIGURE \
--enable-minimal \
--enable-static \
--disable-shared

$MAKE
make install DESTDIR=$BASE

############ ################################################################
# DNSCRYPT # ################################################################
############ ################################################################

mkdir $SRC/dnscrypt && cd $SRC/dnscrypt
$WGET http://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-1.4.3.tar.gz
tar zxvf dnscrypt-proxy-1.4.3.tar.gz
cd dnscrypt-proxy-1.4.3

LDFLAGS="-Wl,-static -static -static-libgcc -s $LDFLAGS" \
CPPFLAGS=$CPPFLAGS \
CFLAGS=$CFLAGS \
CXXFLAGS=$CXXFLAGS \
$CONFIGURE

$MAKE
make install DESTDIR=$BASE/dnscrypt
