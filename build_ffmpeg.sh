#!/bin/sh

ExtraOpts=" --enable-debug"
[ "$BuildType" == "release" ] && ExtraOpts=" --disable-debug"

mkdir _extra
if [ ! -e _extra/ffmpeg ]; then
    git clone --depth 1 --branch master https://github.com/FFmpeg/FFmpeg.git _extra/ffmpeg
fi

mkdir _build/$BuildDir/ffmpeg
cd _build/$BuildDir/ffmpeg
PKG_CONFIG_PATH="$PKG_CONFIG_DIR" ../../../_extra/ffmpeg/configure --prefix=$INSTALL_DIR --target-os=win64 --arch=x86_64 --enable-vaapi --enable-libvpl --enable-d3d11va $ExtraOpts --enable-shared --disable-static --toolchain=msvc
make -j$(nproc - 1) install