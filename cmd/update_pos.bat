@echo off

set "start=10000"
set "cmd=%server%\cmd"
set "update_log=pos_update.log"
echo 系统升级中 ... 稍等！请勿关闭本窗口！
if not exist %update_log% echo %start%> %update_log%
for /F %%i in (%update_log%) do set /a ver=%%i+1
goto :%ver%
exit /b

:10001
call %cmd%\cp_pos_bat
call %cmd%\create_lnk
call %cmd%\copy %server%\pos\ybDevice.702.dll ybDevice.dll
call %cmd%\rm_alipay_logs
call %cmd%\cp_sed
call %cmd%\append_rcb
call %cmd%\del_old_files
echo 10001>> %update_log%

REM 删除桌面旧文件
:10002
call %cmd%\is_xp
if %errorlevel% equ 0 (
set "desktop=%USERPROFILE%\桌面"
) else (
set "desktop=%USERPROFILE%\Desktop"
)
del "%desktop%\ybdevice314.exe" 2>nul
del "%desktop%\建行升级314.exe" 2>nul
del "%desktop%\ybDevice.exe" 2>nul
echo 10002>> %update_log%

REM 在 pos.bat 中加入了版本号，覆盖原文件
:10003
call %cmd%\cp_pos_bat
echo 10003>> %update_log%

REM 解决 "UNC 路径不受支持"
:10004

REM 将 10.203 替换为 200.9
:10005
