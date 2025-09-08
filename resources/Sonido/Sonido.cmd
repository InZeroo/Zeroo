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

::========================================================================================================================================
::========================================================================================================================================

:: Ruta completa del ejecutable
set "FXPATH=%ProgramFiles%\FxSound LLC\FxSound\FxSound.exe"

:: Verificar si ya está instalado
if exist "%FXPATH%" (
    %LOG%    "    FxSound ya está instalado en: "%FXPATH%""
    goto fin
)

:: URL directa del archivo en MediaFire
set "URL=https://download1638.mediafire.com/tem31p6gl9sg1Bv-M4f2liMGg4KtC3ppWhHscNYNylNytgMnm3ktuYl8kNXViRENd9cCmyrc1gOk-tC6enMZxLPehi4rhHkrkITXW1BJ36qDCLH7UahkUHXlymEuBEIx85HFjJuHjxZ3QB3k9HFm_1M-5qvtlnhJdMhC3m0rD1MUgw/rvda8k6eqqxupku/fxsound_setup.exe"


if "%STANDALONE%"=="yes" (

    if not exist "%~dp0fxsound_setup.exe" powershell -Command "Invoke-WebRequest '%URL%' -OutFile '%~dp0fxsound_setup.exe'"
    timeout /t 5 /nobreak >nul
    %~dp0fxsound_setup.exe /exenoui /exelog "%RAW_LOGS%\fxsound_install.log"

)

if not "%STANDALONE%"=="yes" (

    if not exist "resources\Sonido\fxsound_setup.exe" powershell -Command "Invoke-WebRequest '%URL%' -OutFile 'resources\Sonido\fxsound_setup.exe'"
    timeout /t 5 /nobreak >nul
    resources\Sonido\fxsound_setup.exe /exenoui /exelog "%RAW_LOGS%\fxsound_install.log"

)

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