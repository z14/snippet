@echo off
REM version 1.0.1
:: Variables
set "pos_exe=MTpos_jh.exe"
set "pos_bat=pos.bat"
set "pos_path=d:\KSOA POS"
set "server=\\192.168.10.55\s"
set "update_pos_bat=%server%\pos\update_pos.bat"
set "online_flag=online_flag"
set "path=%path%;D:\utils"

d:
if not exist "%pos_path%" md "%pos_path%"
cd "%pos_path%"

:: If can not connect to %server% in 2 seconds, don't run %update_pos_bat%
del %online_flag% 2> nul
start /min "" cmd /C if exist "%update_pos_bat%" copy /y nul %online_flag%
:: XP don't have timeout
:: timeout /t 2 /nobreak > nul

for /L %%i in (1,1,3) do call :check_online

start "" "%pos_exe%"
exit /b

:check_online
if not exist %online_flag% (
ping 127.0.0.1 -n 2 > nul
) else (
call "%update_pos_bat%"
start "" "%pos_exe%"
exit
)
exit /b


