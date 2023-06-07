@ECHO OFF
if "%1"=="" goto end
if "%2"=="" goto end

set BuildType=debug
if "%2"=="Release" set BuildType=release
if "%2"=="release" set BuildType=release

if "%INSTALL_DIR%" == "" (
    if "%2"=="Release" (
        set INSTALL_DIR=%cd%\_install\Release
    )
    if "%2"=="Debug" (
        set INSTALL_DIR=%cd%\_install\Debug
    )
)
mkdir _build\%2
mkdir %INSTALL_DIR%

set PATH=%INSTALL_DIR%\bin;%INSTALL_DIR%\bin\x86;%PATH%
set PKG_CONFIG_DIR=%INSTALL_DIR%\lib\pkgconfig;%INSTALL_DIR%\lib\x86\pkgconfig

set Continue=F
if "%1"=="all" set Continue=T
if "%1"=="onevpl" set Continue=T
if "%Continue%"=="F" goto bypass_onevpl

set VPL_ARCH=Win32

if "%VSCMD_ARG_TGT_ARCH%"=="x64" set VPL_ARCH="x64"

cmake -S oneVPL -B _build\%2\oneVPL -A %VPL_ARCH% -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" -D INSTALL_EXAMPLE_CODE=OFF
cmake --build _build\%2\oneVPL --config %2 --target install

set VPL_ARCH=

:bypass_onevpl

set Continue=F
if "%1"=="all" set Continue=T
if "%1"=="libva" set Continue=T
if "%Continue%"=="F" goto bypass_libva

meson setup _build\%2\libva libva --prefix "%INSTALL_DIR%" --buildtype %BuildType%
ninja -C _build\%2\libva install

meson setup _build\%2\libva-utils libva-utils --prefix "%INSTALL_DIR%" --buildtype %BuildType% -Dpkg_config_path="%PKG_CONFIG_DIR%"
ninja -C _build\%2\libva-utils install

:bypass_libva

set Continue=F
if "%1"=="all" set Continue=T
if "%1"=="mesa" set Continue=T
if "%Continue%"=="F" goto bypass_mesa

meson setup _build\%2\mesa mesa --prefix "%INSTALL_DIR%" --buildtype %BuildType% -Dllvm=disabled -Dplatforms=windows -Dgallium-drivers=d3d12 -Dgallium-va=enabled -Dvideo-codecs=vc1dec,h264dec,h264enc,h265dec,h265enc -Dva-libs-path="%INSTALL_DIR%\lib\dri" -Dpkg_config_path="%PKG_CONFIG_DIR%"
ninja -C _build\%2\mesa install

if exist "%INSTALL_DIR%\bin\vaon12_drv_video.dll" (
    mkdir "%INSTALL_DIR%\lib\dri"
    move "%INSTALL_DIR%\bin\vaon12_drv_video.dll" "%INSTALL_DIR%\lib\dri\."
)

:bypass_mesa

:end

set Continue=
set BuildType=

echo %INSTALL_DIR%
@ECHO ON