
if /i "%SYSTEM_LANGUAGE%"=="es" set "estado=ESTADO"
if /i "%SYSTEM_LANGUAGE%"=="en" set "estado=STATE"

for /f "tokens=4" %%a in ('sc query "%~1" ^| findstr "%estado%"') do (
    if /i "%%a"=="STOPPED" (
        %LOG%    "    Ya esta detenido"
        goto :eof
    )
    if /i "%%a"=="RUNNING" (
        %LOG%    "    Servicio \"%~1\" está en ejecución. Deteniendo..."
        sc stop "%~1" >> "%LOG2%" 2>&1
    ) else (
        %LOG%    "    Servicio \"%~1\" esta en %%a."
        goto :eof
    )
)
goto :eof