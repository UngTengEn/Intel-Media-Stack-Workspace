#!/bin/sh

if [ -z "$1" ]; then
    echo "$0 [Release|Debug]"
    exit 1
fi

BuildType=debug
[ "$1"=="Release" ] && BuildType=release
[ "$1"=="release" ] && BuildType=release

# *** Change the install directory prefix and proxies as you wish  ***
# set http_proxy=
# set https_proxy=
InstallDirectoryPrefix=$(pwd)/_install

INSTALL_DIR=$InstallDirectoryPrefix
[ "$1"=="Release" ] && INSTALL_DIR=$InstallDirectoryPrefix/Release
[ "$1"=="Debug" ] && INSTALL_DIR=$InstallDirectoryPrefix/Debug


mkdir _extra
if [ ! -e _extra/ffmpeg ]; then
    git clone --depth 1 --branch n5.1.3 https://github.com/FFmpeg/FFmpeg.git _extra/ffmpeg
fi

mkdir _build/$1/ffmpeg
cd _build/$1/ffmpeg
# PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig ../../../_extra/ffmpeg/configure  --target-os=win64 --arch=x86_64 --enable-vaapi --enable-libmfx --enable-shared --disable-static --toolchain=msvc
PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig ../../../_extra/ffmpeg/configure  --target-os=win64 --arch=x86_64 --enable-vaapi --enable-shared --disable-static --toolchain=msvc
make