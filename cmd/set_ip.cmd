@echo off

:: TODO get interface name

set /p if=网卡名称： 
set /p ipaddr=IP 地址：
set /p mask=子网掩码： 
set /p gateway=网关地址： 

if not defined if set if=本地连接
if not defined ipaddr set ipaddr=
if not defined mask set mask=255.255.252.0
if not defined gateway set gateway=

set dns1=119.29.29.29
set dns2=223.5.5.5
set subcom=ip
:: set subcom=ipv4
:: call :is_xp

netsh interface ip set address %if% static %ipaddr% %mask% %gateway%

netsh interface %subcom% set dns %if% static %dns1% primary no
netsh interface %subcom% add dns %if% %dns2% index=2

ipconfig /flushdns
pause
exit /b

:: Is Windows XP?
:is_xp
ver | find "5.1" > nul 
if %errorlevel% equ 0 set subcom=ip
exit /b %errorlevel%