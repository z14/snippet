@echo off
set "path=D:\python34;D:\python34\Scripts;D:\utils;%path%"
set "start=10000"
set "server=\\192.168.10.55\s"
set "cmd=%server%\cmd"
set "updates=%cmd%\updates"
set "py=%server%\py"
set "update_log=pos_update.log"
set "pos_path=d:\KSOA POS"

pushd "%pos_path%"

if exist %update_log% (
for /f %%i in ('find "10" "%update_log%"') do set posver=%%i
) else (
set posver=0
)

python -V 1> nul 2>&1
if %errorlevel% EQU 9009 (
curl -m1 -d "posver=%posver%" http://192.168.10.55/api/posver
) else (
%py%\putPosver.py %posver%
)

popd
exit /b