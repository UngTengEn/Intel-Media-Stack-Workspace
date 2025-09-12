@ECHO OFF

if not exist _extra\ (
    mkdir _extra
)
if not exist _extra\gstreamer\ (
    git clone --depth 1 --branch 1.26.5 https://gitlab.freedesktop.org/gstreamer/gstreamer.git _extra\gstreamer
) 

if "%1"=="" goto help

set BuildDir=Debug
set buildtype=debug

if "%1%"=="RELEASE" set buildtype=release
if "%1"=="Release" set buildtype=release
if "%1"=="release" set buildtype=release
if "%buildtype%"=="release" set BuildDir=Release

if "%INSTALL_DIR%" == "" (
    set INSTALL_DIR=%cd%\_install
)

if not exist _build\%BuildDir%\gstreamer\gst-main\build.ninja (
    mkdir _extra\gstreamer\subprojects\gstreamer\subprojects
    copy /y _extra\gstreamer\subprojects\glib.wrap _extra\gstreamer\subprojects\gstreamer\subprojects\.
    meson setup _build\%BuildDir%\gstreamer\gst-main  _extra\gstreamer\subprojects\gstreamer --prefix "%INSTALL_DIR%" --buildtype %buildtype% -Dpkg_config_path="%PKG_CONFIG_DIR%" -Dtests=disabled -Dexamples=disabled -Ddoc=disabled
    ninja -C _build\%BuildDir%\gstreamer\gst-main install
)

if not exist _build\%BuildDir%\gstreamer\gst-plg-base\build.ninja (
    meson setup _build\%BuildDir%\gstreamer\gst-plg-base  _extra\gstreamer\subprojects\gst-plugins-base --prefix "%INSTALL_DIR%" --buildtype %buildtype% -Dpkg_config_path="%PKG_CONFIG_DIR%" -Dtests=disabled -Dexamples=disabled -Ddoc=disabled
    ninja -C _build\%BuildDir%\gstreamer\gst-plg-base install
)

if not exist _build\%BuildDir%\gstreamer\gst-plg-good\build.ninja (
    meson setup _build\%BuildDir%\gstreamer\gst-plg-good  _extra\gstreamer\subprojects\gst-plugins-good --prefix "%INSTALL_DIR%" --buildtype %buildtype% -Dpkg_config_path="%PKG_CONFIG_DIR%" -Dtests=disabled -Dexamples=disabled -Ddoc=disabled
    ninja -C _build\%BuildDir%\gstreamer\gst-plg-good install
)

if not exist _build\%BuildDir%\gstreamer\gst-plg-ugly\build.ninja (
    meson setup _build\%BuildDir%\gstreamer\gst-plg-ugly  _extra\gstreamer\subprojects\gst-plugins-ugly --prefix "%INSTALL_DIR%" --buildtype %buildtype% -Dpkg_config_path="%PKG_CONFIG_DIR%" -Dtests=disabled -Ddoc=disabled
    ninja -C _build\%BuildDir%\gstreamer\gst-plg-ugly install
)

if not exist _build\%BuildDir%\gstreamer\gst-plg-bad\build.ninja (
    meson setup _build\%BuildDir%\gstreamer\gst-plg-bad  _extra\gstreamer\subprojects\gst-plugins-bad --prefix "%INSTALL_DIR%" --buildtype %buildtype% -Dpkg_config_path="%PKG_CONFIG_DIR%" -Dmsdk=enabled -Dva=enabled -Dtests=disabled -Dexamples=disabled -Ddoc=disabled
    ninja -C _build\%BuildDir%\gstreamer\gst-plg-bad install
)

goto end

:help
echo Usage: build_gstreamer.bat [debug|release]

:end

set buildtype=
set BuildDir=

@ECHO ON
