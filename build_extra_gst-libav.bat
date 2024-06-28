@ECHO OFF

if "%1"=="" goto help

set BuildType=Debug
set BuildDir=Debug
set buildtype=debug

if "%1%"=="RELEASE" set BuildType=Release
if "%1"=="Release" set BuildType=Release
if "%1"=="release" set BuildType=Release
if "%BuildType%"=="Release" set buildtype=release

if "%BuildType%"=="Release" set BuildDir=Release

if not exist _build\%BuildDir%\gst-plg-libav/build.ninja (
    meson setup _build\%BuildDir%\gst-plg-libav  _extra\gstreamer\subprojects\gst-libav  --prefix "%INSTALL_DIR%" --buildtype %BuildType% -Dpkg_config_path="%PKG_CONFIG_DIR%" -Dtests=disabled -Ddoc=disabled
    ninja -C _build\%BuildDir%\gst-plg-libav install
)

goto end

:help
echo Usage: build_extra_gst-libav.bat [debug|release]

:end

set BuildType=
set buildtype=
set BuildDir=

@ECHO ON