set "VARSERV=%~1"

if exist "%TEMP%\services.log" del /f /q "%TEMP%\services.log"
set "llamado=RegDelEntry"

%RegQuery% "%~1"
if %errorlevel% NEQ 0 (
    %LOG%    "La clave %~1 no existe, se omite eliminar."
    goto :eof
)

if "%~2"=="" (
    %REG% delete "%~1" /f > "%TEMP%\services.log" 2>&1
) else (
    %REG% delete "%~1" /v "%~2" /f > "%TEMP%\services.log" 2>&1
)
if %errorlevel%==0 (
    %LOG%    "     Clave "%~1" eliminada."
) else (
    %LOG%    "     Falló al eliminar la clave "%~1""
)

type "%TEMP%\services.log" >> "%LOG2%"
if /i "%SYSTEM_LANGUAGE%"=="es" set "ACCESO=Acceso denegado"
if /i "%SYSTEM_LANGUAGE%"=="en" set "ACCESO=Access is denied"

findstr /c:"%ACCESO%" "%TEMP%\services.log" >nul
if not errorlevel 1 (
    %LOG%    "    Se detecto "%ACCESO%""
    %SCError2% "%~1"
)

goto :eof
