set "DISABLED=no"

if /i "%SYSTEM_LANGUAGE%"=="es" set "TIPO=TIPO_INICIO"
if /i "%SYSTEM_LANGUAGE%"=="en" set "TIPO=START_TYPE"

for /f "tokens=4 delims= " %%A in ('sc qc "%~1" ^| findstr /i "%TIPO%"') do (
    if "%%A"=="DISABLED" (
        %LOG%    "    El servicio \"%~1\" esta DESHABILITADO. saltando servicio"
        set "DISABLED=yes"
        goto :eof
    ) else (
        %LOG%    "    El servicio \"%~1\" NO está deshabilitado (TIPO_INICIO = %%A) continuando con el proceso."
        goto :eof
    )
)
goto :eof
