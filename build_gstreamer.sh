#!/bin/bash

. ./env.sh
BuildType="Release"
buildtype="release"
MesonDebugFlags=""
Simulate=""

if [ "$1" == "debug" ]; then
	BuildType="Debug"
	buildtype="debug"
#	MesonDebugFlags="-Db_sanitize=address"
fi

[ -z $2 ] || Simulate="true"
NPROC=$(nproc)
[ $NPROC -gt 4 ] && NPROC=$(( $NPROC - 2 ))

function meson_gst_install() {
	if [ ! -e _build/$BuildType/$1/build.ninja ]; then
		if [ -z "$Simulate" ]; then
			meson setup _build/$BuildType/$1 _extra/gstreamer/subprojects/$1 --prefix="$PWD/_install" --libdir="lib64" --buildtype "$buildtype" -Ddoc=disabled -Dtests=disabled $2 ${MesonDebugFlags}
		else
			echo meson setup _build/$BuildType/$1 _extra/gstreamer/subprojects/$1 --prefix="$PWD/_install" --libdir="lib64" --buildtype "$buildtype" -Ddoc=disabled -Dtests=disabled $2 ${MesonDebugFlags}
		fi
  fi
	[ -z "$Simulate" ] && ninja -C _build/$BuildType/$1 install
}

if [ -d _extra/gstreamer ]; then
	meson_gst_install gstreamer "-Dcoretracers=enabled"

	meson_gst_install gst-plugins-base "-Dgl_platform=egl -Dgl-graphene=disabled"

	meson_gst_install gst-plugins-good "-Ddv=disabled"

	meson_gst_install gst-plugins-bad "-Dmsdk=enabled -Dmfx_api=oneVPL -Dva=enabled"
else
	[ -d _extra ] || mkdir _extra
  git clone https://gitlab.freedesktop.org/gstreamer/gstreamer.git _extra/gstreamer
fi
