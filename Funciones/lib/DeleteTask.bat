
:: %~1 contiene el nombre de la tarea
set "TaskName=%~1"
schtasks /query /TN "%TaskName%" >nul 2>&1
if %errorlevel%==0 (
    schtasks /delete /F /TN "%TaskName%" >> "%LOG2%" 2>&1
    %LOG%    "     Tarea %TaskName% eliminada."
) else (
    %LOG%    "     La tarea %TaskName% no existe."
)
goto :eof
