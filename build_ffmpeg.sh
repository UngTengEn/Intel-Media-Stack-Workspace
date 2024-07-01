#!/bin/sh

if [ ! -e _extra ]; then
    mkdir _extra
fi
if [ ! -e _extra/ffmpeg ]; then
    git clone --depth 1 --branch n6.1.1 https://github.com/FFmpeg/FFmpeg.git _extra/ffmpeg
fi

BuildType=Debug
BuildDir=Debug
buildtype=debug

case "$1" in
    RELEASE|Release|release)
        BuildType=Release
        BuildDir=Release
        buildtype=release
        ;;
    DEBUG|Debug|debug)
        ;;
    *)
        echo "Usage: build_ffmpeg.sh [debug|release]"
        exit 1
        ;;
esac

ExtraOpts=" --enable-debug"
[ "$BuildType" == "Release" ] && ExtraOpts=" --disable-debug"

# Correct the "\" characters in path string
InstallDir=$(echo $INSTALL_DIR | sed -e 's/\\/\//g')

if [ ! -e _build/$BuildDir/ffmpeg/Makefile ]; then
    cp -f patches/ffmpeg/unistd.h $InstallDir/include/.

    cd _extra/ffmpeg
    git apply ../../patches/ffmpeg/*.patch

    cd ../..

    mkdir _build/$BuildDir/ffmpeg
    cd _build/$BuildDir/ffmpeg
    PKG_CONFIG_PATH="$PKG_CONFIG_DIR" ../../../_extra/ffmpeg/configure --prefix="$InstallDir" --enable-vaapi --enable-libvpl --enable-d3d11va $ExtraOpts --enable-shared --enable-static --toolchain=msvc
    make -j$((nproc - 1)) install
fi
