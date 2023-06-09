@ECHO OFF
if "%1"=="" goto end

set BuildType=debug

if "%BUILD_TYPE%"=="RELEASE" set BuildType=release
if "%BUILD_TYPE%"=="Release" set BuildType=release
if "%BUILD_TYPE%"=="release" set BuildType=release

set BuildDir=Debug
if "%BuildType%"=="release" set BuildDir=Release

if "%INSTALL_DIR%" == "" (
    set INSTALL_DIR=%cd%\_install\%BuildDir%
)
mkdir _build\%BuildDir%
mkdir %INSTALL_DIR%

set PATH=%INSTALL_DIR%\bin;%INSTALL_DIR%\bin\x86;%PATH%
set PKG_CONFIG_DIR=%INSTALL_DIR%\lib\pkgconfig;%INSTALL_DIR%\lib\x86\pkgconfig

set Continue=F
if "%1"=="all" set Continue=T
if "%1"=="onevpl" set Continue=T
if "%Continue%"=="F" goto bypass_onevpl

set VPL_ARCH=Win32

if "%VSCMD_ARG_TGT_ARCH%"=="x64" set VPL_ARCH="x64"

cmake -S oneVPL -B _build\%BuildDir%\oneVPL -A %VPL_ARCH% -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" -D INSTALL_EXAMPLE_CODE=OFF
cmake --build _build\%BuildDir%\oneVPL --config %BuildType% --target install

set VPL_ARCH=

:bypass_onevpl

set Continue=F
if "%1"=="all" set Continue=T
if "%1"=="libva" set Continue=T
if "%Continue%"=="F" goto bypass_libva

meson setup _build\%BuildDir%\libva libva --prefix "%INSTALL_DIR%" --buildtype %BuildType%
ninja -C _build\%BuildDir%\libva install

meson setup _build\%BuildDir%\libva-utils libva-utils --prefix "%INSTALL_DIR%" --buildtype %BuildType% -Dpkg_config_path="%PKG_CONFIG_DIR%"
ninja -C _build\%BuildDir%\libva-utils install

:bypass_libva

set Continue=F
if "%1"=="all" set Continue=T
if "%1"=="mesa" set Continue=T
if "%Continue%"=="F" goto bypass_mesa

meson setup _build\%BuildDir%\mesa mesa --prefix "%INSTALL_DIR%" --buildtype %BuildType% -Dllvm=disabled -Dplatforms=windows -Dgallium-drivers=d3d12 -Dgallium-va=enabled -Dvideo-codecs=vc1dec,h264dec,h264enc,h265dec,h265enc -Dva-libs-path="%INSTALL_DIR%\lib\dri" -Dpkg_config_path="%PKG_CONFIG_DIR%"
ninja -C _build\%BuildDir%\mesa install

if exist "%INSTALL_DIR%\bin\vaon12_drv_video.dll" (
    mkdir "%INSTALL_DIR%\lib\dri"
    move "%INSTALL_DIR%\bin\vaon12_drv_video.dll" "%INSTALL_DIR%\lib\dri\."
)

:bypass_mesa

:end

set Continue=

@ECHO ON