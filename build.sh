#!/bin/sh

e() {
    echo "$(date): $*"
}

apt-get install \
    mercurial subversion \
    scons \
    imagemagick
mkdir -p build
cd build
# Checkout needed software
if [ ! -d ocropus ]
then
    hg clone http://ocropus.googlecode.com/hg ocropus
else
    cd ocropus
    hg update
fi
if [ ! -d iulib ]
then
    hg clone http://iulib.googlecode.com/hg iulib
else
    cd iulib
    hg update
fi
if [ ! -d hocr-tools-readonly ]
then
    svn checkout http://hocr-tools.googlecode.com/svn/trunk/ hocr-tools-read-only
else
    cd hocr-tools-read-only
    svn up
fi
#
sh -x ocropus/ubuntu-packages
# Build and install iulib
cd iulib
scons
scons install
cd ..
# Build and install Ocropus
cd ocropus
scons
scons install
cd ..
# Install hOCR-tools
cp hocr-*/hocr /usr/local/bin
cd ..

exit 0
