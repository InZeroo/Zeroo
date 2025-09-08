:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::IntecZeroo:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::https://www.youtube.com/channel/UCkIm0Fu5DdJ-va5Gp9n3Taw
::========================================================================================================================================
::========================================================================================================================================

set "STANDALONE=%1"
if "%STANDALONE%"=="" set "STANDALONE=no"

:: API llamada de otros bat
if "%STANDALONE%"=="ind" (
    @echo off
    chcp 65001
    %LOGO%
)

:: API llamada de otros bat
if "%STANDALONE%"=="API" (
    @echo off
    chcp 65001
    %LOGO%
    pushd "%~dp0"
    set "RUTA=%~dp0"
    call :API
    popd
    exit /b
)    

:: Comprobar ejecución independiente
if /i not "%LOGFILE%"=="" goto :start
    setlocal EnableDelayedExpansion
    @echo off
    chcp 65001

    if exist "%~dp0resources" set "RUTA=%~dp0" & goto :cargar

    :: Numero de busquedas de la carpeta resources
    set N=10
        for /L %%A in (0,1,%N%) do (
            set "X=!X!..\"
            if exist "%~dp0!X!resources" (
                pushd "%~dp0!X!"
                for %%I in (.) do set "RUTA=%%~fI"
                goto :Cargar
            )
        )

    echo No se encontro la carpeta resources
    pause
    exit

    :Cargar
    endlocal & set "RUTA=%RUTA%"
    set "STANDALONE=yes"
    pushd %RUTA%
    call "%RUTA%\resources\Funciones\Version.bat"
    call "%RUTA%\resources\Funciones\Logo.bat"

:start


title "%~nx0"
%LOG% "    Iniciando script "%~nx0"."


if "%maximo_rendimiento%"=="yes" call :maximo_rendimiento
call :Menu
::========================================================================================================================================
::========================================================================================================================================

:Menu
%LOGO%
echo ----------------------------------------------
echo        Selecciona una opcion (1-10)
echo ----------------------------------------------
echo  1 - Desactivar servicios de publicidad, telemetria y experiencia
echo  2 - Desactivar Servicios empresariales
echo  3 - Desactivar Servicios de maquinas virtuales
echo  4 - Desactivar Servicios Gaming
echo  5 - Desactivar los servicios para escritorio remoto
echo  6 - Desactivar los servicios de geolocalizacion
echo  7 - Desactivar los servicios para VPN
echo  8 - Desactivar Perifericos (Bluetooth, huella, impresora, telefonia, NFC, banda ancha)
echo  9 - Desactivar los servicios para Windows Update
echo 10 - Desactivar los servicios de Windows Defender
echo 11 - Desactivar aplicaciones de windows store
echo  S - Suscribete
echo ----------------------------------------------
set /p opc=Elige una opcion: 

if /I "%opc%"=="S" (
    %Suscribete%
    goto :eof
)

if /I "%opc%"=="1" (
    %start% "resources\Servicios\desactivar\SC_Telemetria.cmd ind"
    goto :eof
)

if /I "%opc%"=="2" (
    %start% "resources\Servicios\desactivar\SC_Empresariales.cmd ind"
    goto :eof
)

if /I "%opc%"=="3" (
    %start% "resources\Servicios\desactivar\SC_Maquinas_virtuales.cmd ind"
    goto :eof
)

if /I "%opc%"=="4" (
    %start% "resources\Servicios\desactivar\SC_Gaming.cmd ind"
    goto :eof
)

if /I "%opc%"=="5" (
    %start% "resources\Servicios\desactivar\SC_Escritorio_remoto.cmd ind"
    goto :eof
)

if /I "%opc%"=="6" (
    %start% "resources\Servicios\desactivar\SC_Geolocalizacion.cmd ind"
    goto :eof
)

if /I "%opc%"=="7" (
    %start% "resources\Servicios\desactivar\SC_VPN.cmd ind"
    goto :eof
)

if /I "%opc%"=="8" (
    %start% "resources\Servicios\desactivar\SC_Perifericos_(Bluetooth,_huella,_impresora,_telefonia,_NFC,_banda_ancha).cmd ind"
    goto :eof
)

if /I "%opc%"=="9" (
    %start% "resources\Servicios\desactivar\SC_Windows_Update.cmd ind"
    goto :eof
)

if /I "%opc%"=="10" (
    %start% "resources\Servicios\desactivar\SC_Windows_Defender.cmd ind"
    goto :eof
)

if /I "%opc%"=="11" (
    %start% "resources\Servicios\desactivar\StoreRunMe.cmd ind"
    goto :eof
)

::========================================================================================================================================
::========================================================================================================================================

:fin
::popd
%LOG%    "     Ha finalizado el script "%~nx0""
%LOG%    "     ."
%LOG%    "     ."
%LOG%    "     ."
:: pausar si estamos realizando una ejecucion independiente
if %STANDALONE%==yes pause
if %STANDALONE%==yes %Suscribete%
if %STANDALONE%==ind exit
if %STANDALONE%==no goto :eof
if %STANDALONE%==API goto :eof

::========================================================================================================================================
::========================================================================================================================================

:API
%start% "resources\Servicios\desactivar\SC_Telemetria.cmd ind"
goto :eof

:maximo_rendimiento
%start% "resources\Servicios\desactivar\SC_Telemetria.cmd ind"
%start% "resources\Servicios\desactivar\SC_Empresariales.cmd ind"
%start% "resources\Servicios\desactivar\SC_Maquinas_virtuales.cmd ind"
%start% "resources\Servicios\desactivar\SC_Gaming.cmd ind"
%start% "resources\Servicios\desactivar\SC_Escritorio_remoto.cmd ind"
%start% "resources\Servicios\desactivar\SC_Geolocalizacion.cmd ind"
%start% "resources\Servicios\desactivar\SC_VPN.cmd ind"
%start% "resources\Servicios\desactivar\SC_Perifericos_(Bluetooth,_huella,_impresora,_telefonia,_NFC,_banda_ancha).cmd ind"
%start% "resources\Servicios\desactivar\SC_Windows_Update.cmd ind"
%start% "resources\Servicios\desactivar\SC_Windows_Defender.cmd ind"
%start% "resources\Servicios\desactivar\StoreRunMe.cmd ind"
if "%maximo_rendimiento%"=="yes" exit
