#!/bin/sh

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
        echo "Usage: build_extra_ffmpeg.sh [debug|release]"
        exit 1
        ;;
esac

# Correct the "\" characters in path string
InstallDir=$(echo $INSTALL_DIR | sed -e 's/\\/\//g')

mkdir _extra

### Build x264 ###
if [ ! -e _extra/x264 ]; then
    git clone --depth 1 --branch stable https://git.videolan.org/git/x264.git _extra/x264
fi

if [ ! -e _build/$BuildDir/x264/Makefile ]; then
    mkdir -p _build/$BuildDir/x264
    cd _build/$BuildDir/x264

    PKG_CONFIG_PATH="$PKG_CONFIG_DIR" CC=cl ../../../_extra/x264/configure --prefix="$InstallDir" --enable-shared
    make install

    cd ../../..

    cp -f $InstallDir/lib/libx264.dll.lib $InstallDir/lib/x264.lib
    cp -f $InstallDir/lib/libx264.dll.lib $InstallDir/lib/libx264.lib
fi

### Build x265 ###
if [ ! -e _extra/x265 ]; then
    # Have to checkout x265 with tag, or cmake will fail
    git clone --depth 1 --branch 3.4 https://github.com/videolan/x265.git _extra/x265
fi

BuildArch=Win32
[ "$VSCMD_ARG_TGT_ARCH" = "x64" ] && BuildArch=x64

if [ ! -e _build/$BuildDir/x265/install_manifest.txt ]; then
    cmake -S  _extra/x265/source -B _build/$BuildDir/x265 -A $BuildArch -DCMAKE_INSTALL_PREFIX="$InstallDir"
    cmake --build _build/$BuildDir/x265 --config $BuildType --target install
    cp -f $InstallDir/lib/libx265.lib $InstallDir/lib/x265.lib
fi

### Build dav1d ###
if [ ! -e _extra/dav1d ]; then
    git clone --depth 1 --branch 1.4.3 https://github.com/videolan/dav1d.git _extra/dav1d
fi

if [ ! -e _build/$BuildDir/dav1d/ninja.build ]; then
    meson setup _build/$BuildDir/dav1d _extra/dav1d --prefix="$InstallDir" --buildtype $buildtype -Dpkg_config_path="$PKG_CONFIG_DIR" -Ddefault_library=shared
    ninja -C _build/$BuildDir/dav1d install
fi


### Build svt-av1 ###
if [ ! -e _extra/svt-av1 ]; then
    git clone --depth 1 --branch v2.1.2 https://gitlab.com/AOMediaCodec/SVT-AV1.git _extra/svt-av1
fi

if [ ! -e _build/$BuildDir/svt-av1/install_manifest.txt ]; then
    cmake -S  _extra/svt-av1 -B _build/$BuildDir/svt-av1 -A $BuildArch -DCMAKE_INSTALL_PREFIX="$InstallDir"
    cmake --build _build/$BuildDir/svt-av1 --config $BuildType --target install
fi


### Build fdk-aac ###
if [ ! -e _extra/fdk-aac ]; then
    git clone --depth 1 --branch v2.0.3 https://github.com/mstorsjo/fdk-aac.git _extra/fdk-aac
fi

if [ ! -e _build/$BuildDir/fdk-aac/install_manifest.txt ]; then
    cmake -S  _extra/fdk-aac -B _build/$BuildDir/fdk-aac -A $BuildArch -DCMAKE_INSTALL_PREFIX="$InstallDir"
    cmake --build _build/$BuildDir/fdk-aac --config $BuildType --target install
fi


### Build ffmpeg ###
if [ ! -e _build/$BuildDir/ffmpeg/Makefile ]; then
    ExtraOpts=" --enable-debug"
    [ "$BuildType" == "Release" ] && ExtraOpts=" --disable-debug"

    cp -f patches/ffmpeg/mp3lame.pc $InstallDir/lib/pkgconfig/.
    cp -f patches/ffmpeg/unistd.h $InstallDir/include/.

    cd _extra/ffmpeg
    git apply ../../patches/ffmpeg/*.patch
    cd ../..

    mkdir _build/$BuildDir/ffmpeg
    cd _build/$BuildDir/ffmpeg

    # Some components are build with gstreamer.  Need external configurations for mp3lame and zlib (unistd.h), 
    # look into ./patches/ffmpeg.
    PKG_CONFIG_PATH="$PKG_CONFIG_DIR" ../../../_extra/ffmpeg/configure --prefix="$InstallDir" --enable-x86asm --x86asmexe=yasm64 \
        --enable-gpl --enable-libx264 --enable-libx265 --enable-libdav1d --enable-libsvtav1 --enable-vaapi \
        --enable-libvpl --enable-d3d11va $ExtraOpts --enable-zlib --enable-shared --enable-static --toolchain=msvc \
        --enable-nonfree --enable-libfdk_aac
    make -j$((nproc - 1)) install

    cd ../../..
fi
