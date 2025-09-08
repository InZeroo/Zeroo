:: 1.1 se ha modificado el log para que acepte argumentos sin tener que usar comillas 
:: Función de registro de Zeroo con grupo de fecha y hora (DTG) integrado
:: 1.2 se crea la carpeta log si esta no existe

:: Cuando la cadena del argumento (%1) está entre comillas dobles, se envía como argumento.
:: La sintaxis de tilde (%~1) elimina las comillas dobles que rodean el argumento.
@echo off
if not exist "%LOGPATH%" mkdir "%LOGPATH%"
:: Acumula todos los parámetros en MSG
set "MSG=%~1"
shift
:loop
if "%~1"=="" goto write
set MSG=%MSG% %~1
shift
goto loop

:write
setlocal
echo:%CUR_DATE% %MSG%>> "%LOGPATH%\%LOGFILE%"
echo:%CUR_DATE% %MSG%
endlocal
exit /b
