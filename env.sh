#!/bin/bash

CurDir=$(pwd)
InstallDir="$PWD/_install"

if [ -z $(echo $LD_LIBRARY_PATH | grep "$InstallDir") ]; then
	export PATH=$InstallDir/bin:$PATH
	export LD_LIBRARY_PATH=$InstallDir/lib64:$LD_LIBRARY_PATH
	export LIBRARY_PATH=$InstallDir/lib64:$LIBRARY_PATH
	export PKG_CONFIG_PATH=$InstallDir/lib64/pkgconfig
	export LIBVA_DRIVERS_PATH=$InstallDir/lib64/dri
	export GST_PLUGIN_SYSTEM_PATH=$InstallDir/lib64/gstreamer-1.0
	[ -d $InstallDir/cache ] || mkdir -p $InstallDir/cache
	export XDG_CACHE_HOME=$InstallDir/cache
fi

[ ! -f .vscode/launch.json ] && cp .vscode/launch.json.template  .vscode/launch.json

