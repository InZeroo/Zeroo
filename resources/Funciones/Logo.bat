:LOGO
cls
color 30
title INTECZEROO

echo +-------------------------------------------------+
echo ¦                    INTECZEROO                   ¦        
echo ¦        ZEROO PROBLEMAS - INFINITAS SOLUCIONES   ¦      
echo +-------------------------------------------------+

echo.
echo  ¦¦+ ¦¦¦+   ¦¦+¦¦¦¦¦¦¦¦+¦¦¦¦¦¦¦+ ¦¦¦¦¦¦+¦¦¦¦¦¦¦+¦¦¦¦¦¦¦+ ¦¦¦¦¦¦¦+¦¦¦¦¦¦+  ¦¦¦¦¦¦+  ¦¦¦¦¦¦+ 
echo  ¦¦+ ¦¦¦¦+  ¦¦¦+--¦¦+--+¦¦+----+¦¦+----+¦¦+----+     ¦¦¦ ¦¦+----+¦¦+--¦¦+¦¦+---¦¦+¦¦+---¦¦+
echo  ¦¦+ ¦¦+¦¦+ ¦¦¦   ¦¦¦   ¦¦¦¦¦+  ¦¦¦     ¦¦¦¦¦+     ¦¦¦   ¦¦¦¦¦+  ¦¦¦¦¦¦++¦¦¦   ¦¦¦¦¦¦   ¦¦¦
echo  ¦¦+ ¦¦¦+¦¦+¦¦¦   ¦¦¦   ¦¦+--+  ¦¦¦     ¦¦+--+   ¦¦¦     ¦¦+--+  ¦¦+--¦¦+¦¦¦   ¦¦¦¦¦¦   ¦¦¦
echo  ¦¦+ ¦¦¦ +¦¦¦¦¦   ¦¦¦   ¦¦¦¦¦¦¦++¦¦¦¦¦¦+¦¦¦¦¦¦¦+¦¦¦¦¦¦¦ ¦¦¦¦¦¦¦+¦¦¦  ¦¦¦ +¦¦¦¦¦¦+++¦¦¦¦¦¦++
echo  +-+ +-+  +---+   +-+   +------+ +-----++------++------++------++-+  +-+ +-----+  +-----+   
echo.
echo ==============================================================================================
echo Estado de conexión a Internet: %NETWORK_AVAILABLE%      Idioma del sistema: %SYSTEM_LANGUAGE%
echo Sistema operativo: %WIN_VER% (%WIN_VER_NUM%)            RAM: %RAM%GB
if /i "%bateria%"=="yes" (
echo Laptop detectada)
if /i "%bateria%"=="no" (
echo PC de mesa detectado)
if /i "%bateria%"=="Desconocido" (
echo No se detecta el tipo de computador)
echo ==============================================================================================
echo TIPO DE DISCO:%DISK%          PROCESADOR:%CPU%
echo ==============================================================================================
echo TARJETA DE RED:%NAMERED1%
echo ==============================================================================================
echo Lista de usuarios:
type resources\log\userlist.txt
echo ==============================================================================================
if %STANDALONE%==yes pause
goto :eof
