# Intel Media Stack vscode Workspace (Windows)
This document describes how to build the binaries.

## Prerequisites

To build this project on Windows you will need:

- Visual Studio Code
- Visual Studio Build Tools 2022
	* Desktop Development with C++
	* C++ CMake tools for Windows
	* C++ ATL latest build tools (x86 and x64)
	* Windows 10 SDK
- Python (at least 3.8)
	* Install below components with pip
		a. meson
		b. ninja
		c. mako
	* Add the folder path contains these executable binaries to the system PATH
- [pkg-config-lite](https://sourceforge.net/projects/pkgconfiglite/files/0.28-1) and [winflexbison](https://github.com/lexxmark/winflexbison/releases/tag/v2.5.25)
	* Download the windows binaries zip packages and extract them
	* Add the folder path contains these executable binaries to the system PATH

## Clone and Build
```
git clone https://github.com/UngTengEn/Intel-Media-Stack-Windows.git --recursive
```

Open the workspace in the folder with Visual Studio Code.

In Visual Studio Code menu, goto Terminal > Run Task..., run "Build|All|Release".

The binaries and programs will build in _install\Release\bin.

## Extra Tools

### Gstreamer

a. Open a new Terminal in Visual Studio Code.
b. Run ".\env.bat" from project root path.  This should set the build environments.
c. Run ".\build_gstreamer.bat [Release|Debug]".  This will checkout gstreamer and build it.

### FFmpeg

You will need nasm and msys2 (follow [here](https://www.youtube.com/watch?v=OIYGjzmJ2GI) to cofigure msys2).

a. Open a new Terminal in Visual Studio Code. Run ".\env.bat" from project root path.
b. Then run the msys2_shell.cmd.  This will open a msys2 shell window.
c. in the msys2 shell window, go to the project root path and run "./build_ffmpeg.sh [Release|Debug]"
