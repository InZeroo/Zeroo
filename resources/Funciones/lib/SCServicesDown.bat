set "VARSERV=%~1"
if exist "%TEMP%\services.log" del /f /q "%TEMP%\services.log"

:: Existe el servicio?
%SCQuery% "%VARSERV%"
if %errorlevel% NEQ 0 (
    %LOG%    "    El servicio %VARSERV% no existe, se omite Desactivar."
    goto :eof
)

:: Estado del servicio
%SCQuery2% "%VARSERV%"

if /i "%DISABLED%"=="no" (

    :: detener servicio
    %SCQuery3% "%VARSERV%"

    sc config "%VARSERV%" start= disabled > "%TEMP%\services.log" 2>&1
    type "%TEMP%\services.log" >> "%LOG2%"

    if /i "%SYSTEM_LANGUAGE%"=="es" set "ACCESO=Acceso denegado."
    if /i "%SYSTEM_LANGUAGE%"=="en" set "ACCESO=Access is denied."

)

findstr /c:"%ACCESO%" "%TEMP%\services.log" >nul
if not errorlevel 1 (
    %LOG%    "    Se detecto "%ACCESO%""
    %SCError1%
)

goto :eof
