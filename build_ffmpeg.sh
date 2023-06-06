#!/bin/sh

if [ -z "$1" ]; then
    echo "$0 [Release|Debug]"
    exit 1
fi

ExtraOpts=
[ "$1" == "Release" ] && ExtraOpts=" --disable-debug"
[ "$1" == "release" ] && ExtraOpts=" --disable-debug"

# *** Change the install directory prefix and proxies as you wish  ***
# set http_proxy=
# set https_proxy=
InstallDirectoryPrefix=$(pwd)/_install

INSTALL_DIR=$InstallDirectoryPrefix
[ "$1" == "Release" ] && INSTALL_DIR=$InstallDirectoryPrefix/Release
[ "$1" == "Debug" ] && INSTALL_DIR=$InstallDirectoryPrefix/Debug


mkdir _extra
if [ ! -e _extra/ffmpeg ]; then
    git clone --depth 1 --branch n5.1.3 https://github.com/FFmpeg/FFmpeg.git _extra/ffmpeg
fi

mkdir _build/$1/ffmpeg
cd _build/$1/ffmpeg
# PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig ../../../_extra/ffmpeg/configure --prefix=$INSTALL_DIR --target-os=win64 --arch=x86_64 --enable-vaapi --enable-libmfx --enable-d3d11va $ExtraOpts --enable-shared --disable-static --toolchain=msvc
PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig ../../../_extra/ffmpeg/configure --prefix=$INSTALL_DIR --target-os=win64 --arch=x86_64 --enable-vaapi --enable-d3d11va $ExtraOpts --enable-shared --disable-static --toolchain=msvc
make