@ECHO OFF

rem *** Set the default install directory and build type as you wish  ***
rem set INSTALL_DIR=
rem set BUILD_TYPE=[Debug or Release]
set BUILD_TYPE=Release

rem *** Set the proxies if behind firewall  ***
rem set http_proxy=
rem set https_proxy=

rem *** Setup MSVC environments.  Have to put at end, or will override previous settings.      ***
rem *** The path to vcvarsall.bat depends on the version of Visual Studio you have installed.  ***
rem *** Configure build arch (x86, x64, x86_x64, x64_x86).                                     ***
"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64

@ECHO ON