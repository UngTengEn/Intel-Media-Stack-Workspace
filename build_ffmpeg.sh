#!/bin/sh

ExtraOpts=" --enable-debug"
[ "$BuildType" == "release" ] && ExtraOpts=" --disable-debug"

mkdir _extra
if [ ! -e _extra/ffmpeg ]; then
    git clone --depth 1 --branch master https://github.com/FFmpeg/FFmpeg.git _extra/ffmpeg

#    cd _extra/ffmpeg
#    git apply ../../patches/ffmpeg/*.patch
#    cd ../..
fi

# Correct the "\" characters in path string
InstallDir=$(echo $INSTALL_DIR | sed -e 's/\\/\//g')

mkdir _build/$BuildDir/ffmpeg
cd _build/$BuildDir/ffmpeg
PKG_CONFIG_PATH="$PKG_CONFIG_DIR" ../../../_extra/ffmpeg/configure --prefix="$InstallDir" --target-os=win64 --arch=x86_64 --enable-vaapi --enable-libvpl --enable-d3d11va $ExtraOpts --enable-shared --enable-static --toolchain=msvc
make -j$(nproc - 1) install