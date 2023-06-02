@ECHO OFF
if "%1"=="" goto help


set BuildType=debug
if "%1"=="Release" set BuildType=release
if "%1"=="release" set BuildType=release

rem *** Change the install directory prefix and proxies as you wish  ***
rem set http_proxy=
rem set https_proxy=
set InstallDirectoryPrefix=%cd%\_install

set INSTALL_DIR=%InstallDirectoryPrefix%
if "%1"=="Release" (
    set INSTALL_DIR=%InstallDirectoryPrefix%\Release
)
if "%1"=="Debug" (
    set INSTALL_DIR=%InstallDirectoryPrefix%\Debug
)

mkdir _extra
if not exist _extra\gstreamer\ (
    git clone --depth 1 --branch main https://gitlab.freedesktop.org/gstreamer/gstreamer.git _extra\gstreamer
) 

meson setup _build\%1\gstreamer  _extra\gstreamer --prefix "%INSTALL_DIR%" --buildtype %BuildType% -Dpkg_config_path="%INSTALL_DIR%\lib\pkgconfig" -Dlibav=disabled -Ddevtools=disabled -Dges=disabled -Drtsp_server=disabled -Dgst-examples=disabled -Dtls=disabled -Dtests=disabled -Dexamples=disabled -Dgst-plugins-base:gl=disabled -Dgst-plugins-bad:gl=disabled -Dgst-plugins-bad:msdk=disabled -Dgst-plugins-bad:va=enabled -Dcairo:tests=disabled
ninja -C  _build\%1\gstreamer install

goto end

:help
echo %0 [Release or Debug]

:end
@ECHO ON