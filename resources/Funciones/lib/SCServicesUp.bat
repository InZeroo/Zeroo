set "VARSERV=%~1"
set "V2=%~2"

:: Existe el servicio?
%SCQuery% "%VARSERV%"
if %errorlevel% NEQ 0 (
    %LOG%    "    El servicio %VARSERV% no existe, se omite Activar."
    goto :eof
)

call :SCQueryup "%VARSERV%"


sc config "%VARSERV%" start=%V2%
if %errorlevel% NEQ 0 (
    %LOG%    "    El servicio %VARSERV% no se pudo configurar."
) else (
    %LOG%    "    El servicio %VARSERV% se ha configurado correctamente en %V2%."
)

goto :eof

::-----------------------------------------------------

:SCQueryup

if /i "%SYSTEM_LANGUAGE%"=="es" set "estado=ESTADO"
if /i "%SYSTEM_LANGUAGE%"=="en" set "estado=STATE"

for /f "tokens=4" %%a in ('sc query "%VARSERV%" ^| findstr "%estado%"') do (
    if /i "%%a"=="RUNNING" (
        %LOG%    "    Ya se esta ejecutando "%VARSERV%". omitiendo paso 1 forzando paso 2"
        goto :eof
    )
    if /i "%%a"=="RUNNING" (
        %LOG%    "    Servicio "%VARSERV%" está Deteniendo. Ejecutando..."
        sc start "%~1" >> "%LOG2%" 2>&1
    ) else (
        %LOG%    "    Servicio "%VARSERV%" esta en %%a."
        goto :eof
    )
)
goto :eof