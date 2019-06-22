@echo off

:: TODO get interface name

set dns1=119.29.29.29
set dns2=223.5.5.5
set if=本地连接
set subcom=ipv4
call :is_xp

netsh interface %subcom% set dns %if% static %dns1% primary no
netsh interface %subcom% add dns %if% %dns2% index=2

ipconfig /flushdns

:: Is Windows XP?
:is_xp
ver | find "5.1" > nul 
if %errorlevel% equ 0 set subcom=ip
exit /b %errorlevel%