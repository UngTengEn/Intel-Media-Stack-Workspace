@ECHO OFF
if "%1"=="" goto end
if "%2"=="" goto end

set RootDir=%cd%

set BuildType=debug
if "%2"=="Release" set BuildType=release
if "%2"=="release" set BuildType=release

rem *** Change the install directory prefix and proxies as you wish  ***
rem set http_proxy=
rem set https_proxy=
set InstallDirectoryPrefix=%cd%\_install

set INSTALL_DIR=%InstallDirectoryPrefix%
if "%2"=="Release" (
    set INSTALL_DIR=%InstallDirectoryPrefix%\Release
    mkdir _build\%2
    mkdir %INSTALL_DIR%
)
if "%2"=="Debug" (
    set INSTALL_DIR=%InstallDirectoryPrefix%\Debug
    mkdir _build\%2
    mkdir %INSTALL_DIR%
)

set PATH=%InstallDirectoryPrefix%\Release\bin;%InstallDirectoryPrefix%\Debug\bin;%PATH%
set InstallDirectoryPrefix=

set Continue=F
if "%1"=="all" set Continue=T
if "%1"=="onevpl" set Continue=T
if "%Continue%"=="F" goto bypass_onevpl

cmake -S oneVPL -B _build\%2\oneVPL -D CMAKE_INSTALL_PREFIX="%INSTALL_DIR%"
cmake --build _build\%2\oneVPL --config %2 --target install

:bypass_onevpl

cd "%RootDir%"

set Continue=F
if "%1"=="all" set Continue=T
if "%1"=="libva" set Continue=T
if "%Continue%"=="F" goto bypass_libva

meson setup _build\%2\libva libva --prefix "%INSTALL_DIR%" --buildtype %BuildType%
ninja -C _build\%2\libva install

meson setup _build\%2\libva-utils libva-utils --prefix "%INSTALL_DIR%" --buildtype %BuildType% -Dpkg_config_path="%INSTALL_DIR%\lib\pkgconfig"
ninja -C _build\%2\libva-utils install

:bypass_libva

cd "%RootDir%"

set Continue=F
if "%1"=="all" set Continue=T
if "%1"=="mesa" set Continue=T
if "%Continue%"=="F" goto bypass_mesa

meson setup _build\%2\mesa mesa --prefix "%INSTALL_DIR%" --buildtype %BuildType% -Db_vscrt=mt -Dllvm=disabled -Dplatforms=windows -Dosmesa=false -Dgallium-drivers=d3d12 -Dvideo-codecs=vc1dec,h264dec,h264enc,h265dec,h265enc -Dva-libs-path="%INSTALL_DIR%\lib\dri" -Dpkg_config_path="%INSTALL_DIR%\lib\pkgconfig"
ninja -C _build\%2\mesa install

if exist "%INSTALL_DIR%\bin\vaon12_drv_video.dll" (
    mkdir "%INSTALL_DIR%\lib\dri"
    move "%INSTALL_DIR%\bin\vaon12_drv_video.dll" "%INSTALL_DIR%\lib\dri\."
)

:bypass_mesa

:end

set Continue=
set RootDir=
set BuildType=
@ECHO ON