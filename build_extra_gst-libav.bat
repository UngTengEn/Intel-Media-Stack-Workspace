@ECHO OFF

if not exist _build\%BuildDir%\gst-libav (
    meson setup _build\%BuildDir%\gst-libav  _extra\gstreamer\subprojects\gst-libav  --prefix "%INSTALL_DIR%" --buildtype %BuildType% -Dpkg_config_path="%PKG_CONFIG_DIR%" -Dtests=disabled -Ddoc=disabled
    ninja -C _build\%BuildDir%\gst-libav install
)
@ECHO ON