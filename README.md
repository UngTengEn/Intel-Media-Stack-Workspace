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
		1. meson
		2. ninja
		3. mako
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