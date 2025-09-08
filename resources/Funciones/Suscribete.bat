:SUSCRIBETE
cls
@echo off
color 30 

echo +-------------------------------------------------+
echo ¦                    INTECZEROO                   ¦        
echo ¦        ZEROO PROBLEMAS - INFINITAS SOLUCIONES   ¦      
echo +-------------------------------------------------+

echo.
echo  ¦¦+ ¦¦¦+   ¦¦+¦¦¦¦¦¦¦¦+¦¦¦¦¦¦¦+ ¦¦¦¦¦¦+¦¦¦¦¦¦¦+¦¦¦¦¦¦¦+ ¦¦¦¦¦¦¦+¦¦¦¦¦¦+ ¦¦¦¦¦¦+  ¦¦¦¦¦¦+ 
echo  ¦¦+ ¦¦¦¦+  ¦¦¦+--¦¦+--+¦¦+----+¦¦+----+¦¦+----+     ¦¦¦ ¦¦+----+¦¦+--¦¦+¦¦+---¦¦+¦¦+---¦¦+
echo  ¦¦+ ¦¦+¦¦+ ¦¦¦   ¦¦¦   ¦¦¦¦¦+  ¦¦¦     ¦¦¦¦¦+     ¦¦¦   ¦¦¦¦¦+  ¦¦¦¦¦¦++¦¦¦   ¦¦¦¦¦¦   ¦¦¦
echo  ¦¦+ ¦¦¦+¦¦+¦¦¦   ¦¦¦   ¦¦+--+  ¦¦¦     ¦¦+--+   ¦¦¦     ¦¦+--+  ¦¦+--¦¦+¦¦¦   ¦¦¦¦¦¦   ¦¦¦
echo  ¦¦+ ¦¦¦ +¦¦¦¦¦   ¦¦¦   ¦¦¦¦¦¦¦++¦¦¦¦¦¦+¦¦¦¦¦¦¦+¦¦¦¦¦¦¦¦ ¦¦¦¦¦¦¦+¦¦¦  ¦¦¦+¦¦¦¦¦¦+++¦¦¦¦¦¦++
echo  +-+ +-+  +---+   +-+   +------+ +-----++------++------++------++-+  +-+ +-----+  +-----+   
echo.

echo 1 - YouTube  
echo 2 - Facebook     
echo 3 - TikTok        
echo 4 - Instagram     
echo 5 - Twitter (X)   
echo 6 - WhatsApp      
echo 7 - Telegram      
echo 8 - Tienda        
echo 9 - Volver al menu principal
echo --------------------------------------------
set /p opcion_sus="Elige una opcion (1-9): "

if "%opcion_sus%"=="1" start https://www.youtube.com/@iNTecZeroo
if "%opcion_sus%"=="2" start https://www.facebook.com/profile.php?id=61574569357614
if "%opcion_sus%"=="3" start https://www.tiktok.com/@inteczeroo
if "%opcion_sus%"=="4" start https://www.instagram.com/intec_zeroo/
if "%opcion_sus%"=="5" start https://x.com/inteczeroo
if "%opcion_sus%"=="6" start https://wa.me/message/IA2LEJDFHUQ5L1
if "%opcion_sus%"=="7" start t.me/inteczeroo
if "%opcion_sus%"=="8" start https://www.facebook.com/marketplace/profile/61574569357614/
if "%opcion_sus%"=="9" goto MENU

echo Opcion no valida, intenta de nuevo...
timeout /t 2 >nul
goto suscribete
