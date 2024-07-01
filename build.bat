@ECHO OFF
if "%2"=="" goto end

set BuildDir=Debug
set buildtype=debug

if "%1%"=="RELEASE" set buildtype=release
if "%1"=="Release" set buildtype=release
if "%1"=="release" set buildtype=release
if "%buildtype%"=="release" set BuildDir=Release

if "%INSTALL_DIR%" == "" (
    set INSTALL_DIR=%cd%\_install
)
if not exist _build\%BuildDir% mkdir _build\%BuildDir%
if not exist %INSTALL_DIR% mkdir %INSTALL_DIR%

set PATH=%INSTALL_DIR%\bin;%INSTALL_DIR%\bin\x86;%PATH%
set PKG_CONFIG_DIR=%INSTALL_DIR%\lib\pkgconfig;%INSTALL_DIR%\lib\x86\pkgconfig

set Continue=F
if "%2"=="all" set Continue=T
if "%2"=="vpl" set Continue=T
if "%Continue%"=="F" goto bypass_onevpl

set VPL_ARCH=Win32

if "%VSCMD_ARG_TGT_ARCH%"=="x64" set VPL_ARCH="x64"

cmake -S oneVPL -B _build\%BuildDir%\oneVPL -A %VPL_ARCH% -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%"  -DCMAKE_BUILD_TYPE="%buildtype%" -D INSTALL_EXAMPLE_CODE=OFF
cmake --build _build\%BuildDir%\oneVPL --target install

copy /y %INSTALL_DIR%\lib\vpld.lib  %INSTALL_DIR%\lib\vpl.lib

set VPL_ARCH=

:bypass_onevpl

set Continue=F
if "%2"=="all" set Continue=T
if "%2"=="vaapi" set Continue=T
if "%Continue%"=="F" goto bypass_libva

meson setup _build\%BuildDir%\libva libva --prefix "%INSTALL_DIR%" --buildtype %buildtype%
ninja -C _build\%BuildDir%\libva install

meson setup _build\%BuildDir%\libva-utils libva-utils --prefix "%INSTALL_DIR%" --buildtype %buildtype% -Dpkg_config_path="%PKG_CONFIG_DIR%"
ninja -C _build\%BuildDir%\libva-utils install

:bypass_libva

set Continue=F
if "%2"=="all" set Continue=T
if "%2"=="driver" set Continue=T
if "%Continue%"=="F" goto bypass_mesa

meson setup _build\%BuildDir%\DirectX-Headers DirectX-Headers --prefix "%INSTALL_DIR%" --buildtype %buildtype% -Dpkg_config_path="%PKG_CONFIG_DIR%"
ninja -C _build\%BuildDir%\DirectX-Headers install

meson setup _build\%BuildDir%\mesa mesa --prefix "%INSTALL_DIR%" --buildtype %buildtype% -Dllvm=disabled -Dplatforms=windows -Dgallium-drivers=d3d12 -Dgallium-va=enabled -Dvideo-codecs=vc1dec,h264dec,h264enc,h265dec,h265enc -Dva-libs-path="%INSTALL_DIR%\lib\dri" -Dpkg_config_path="%PKG_CONFIG_DIR%"
ninja -C _build\%BuildDir%\mesa install

copy /y %INSTALL_DIR%\lib\z.lib  %INSTALL_DIR%\lib\zlib.lib

:bypass_mesa

:end

set buildtype=
set BuildDir=
set Continue=

@ECHO ON
