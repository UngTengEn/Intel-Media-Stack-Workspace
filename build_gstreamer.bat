@ECHO OFF
if "%BuildType%"=="" goto help
if "%BuildDir%"=="" goto help
if "%INSTALL_DIR%"=="" goto help

mkdir _extra
if not exist _extra\gstreamer\ (
    git clone --depth 1 --branch main https://gitlab.freedesktop.org/gstreamer/gstreamer.git _extra\gstreamer
) 

if not exist _build\%BuildDir%\gstreamer (
    meson setup _build\%BuildDir%\gstreamer  _extra\gstreamer --prefix "%INSTALL_DIR%" --buildtype %BuildType% -Dpkg_config_path="%PKG_CONFIG_DIR%" -Dlibav=disabled -Ddevtools=disabled -Dges=disabled -Drtsp_server=disabled -Dgst-examples=disabled -Dtls=disabled -Dtests=disabled -Dexamples=disabled -Dgst-plugins-base:gl=disabled -Dgst-plugins-bad:gl=disabled -Dgst-plugins-bad:openh264=disabled -Dgst-plugins-bad:msdk=enabled -Dgst-plugins-bad:va=enabled -Dcairo:tests=disabled
    ninja -C _build\%BuildDir%\gstreamer install
    copy /Y %INSTALL_DIR%\lib\z.lib  %INSTALL_DIR%\lib\zlib.lib
)

goto end

:help
echo Make sure you have run the ".\env.bat" to set the environments.

:end
@ECHO ON
