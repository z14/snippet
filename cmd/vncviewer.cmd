@echo off

::set "viewer=D:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe"
set "viewer=D:\Program Files\RealVNC\VNC Viewer\vncviewer.exe"
set pw=xxx
call :conn_vnc
exit /b %errorlevel%

:conn_vnc
set /p i=Enter ip addr: 192.168.
:: for ultravnc
::start "" "%viewer%" 192.168.%i% /password %pw%
:: for realvnc
start "" "%viewer%" 192.168.%i%
REM goto myself to achieve infinity loop
goto :conn_vnc