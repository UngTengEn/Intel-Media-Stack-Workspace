@ECHO OFF

rem *** The path to vcvarsall.bat depends on the version of Visual Studio you have installed.  ***
rem *** Configure build arch (x86, x64, x86_x64, x64_x86).                                     ***
"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x86

rem *** Set the default install directory, proxies and build type as you wish  ***
rem set INSTALL_DIR=
rem set http_proxy=
rem set https_proxy=

@ECHO ON