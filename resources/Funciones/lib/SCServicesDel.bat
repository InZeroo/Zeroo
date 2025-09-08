
set "VARSERV=%~1"

:: Existe el servicio?
%SCQuery% "%~1"
if %errorlevel% NEQ 0 (
    %LOG%    "    El servicio "%VARSERV%" no existe, se omite eliminar."
    goto :eof
)

:: detener servicio
%SCQuery3% "%VARSERV%"

sc delete "%VARSERV%" >> "%LOG2%" 2>&1

goto :eof