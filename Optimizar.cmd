:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::IntecZeroo:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::https://www.youtube.com/channel/UCkIm0Fu5DdJ-va5Gp9n3Taw
:: 4.1 Se añade la optimizacion de sonido 
:: 4.1 Actualizacion de funciones
:: 4.2 Se repara el codigo Maximo_rendimiento.ps1
:: 4.3 Actualización de funciones
:: 4.4 Actualización Online
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
	set "URL_SCRIPT=https://raw.githubusercontent.com/InZeroo/Zeroo/refs/heads/main"
    call "%RUTA%\resources\Funciones\Version.bat"
    call "%RUTA%\resources\Funciones\Logo.bat"

:start

title "%~nx0"
%LOG% "    Iniciando script "%~nx0"."

::========================================================================================================================================
::========================================================================================================================================

%start% "resources\bloatware\metro_app.cmd ind"
%start% "resources\onedrive_removal\del_onedrive.cmd ind"
%start% "resources\Remove-MS-Edge-main\eliminar_egde.cmd ind"
%start% "resources\Servicios\OP_Servicios.cmd API"
%start% "resources\sistema\programas.cmd ind"
%start% "resources\sistema\RAM.cmd ind"
%start% "resources\sistema\OP_system.cmd ind"
%start% "resources\oem\GUID.cmd ind"
%start% "resources\Sonido\Sonido.cmd ind"

::========================================================================================================================================
::========================================================================================================================================

:fin
::popd
%LOG% "    Ha finalizado el script "%~nx0""
%LOG%    "     ."
%LOG%    "     ."
%LOG%    "     ."
:: pausar si estamos realizando una ejecucion independiente
if %STANDALONE%==yes pause
if %STANDALONE%==yes %Suscribete%
if %STANDALONE%==ind exit
if %STANDALONE%==no goto :eof
if %STANDALONE%==API goto :eof
