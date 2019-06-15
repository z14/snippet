@echo off

set "uvncviewer=D:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe"
set pw=xxx
call :conn_vnc
exit /b %errorlevel%

:conn_vnc
set /p i=Enter ip addr: 192.168.
start "" "%uvncviewer%" 192.168.%i% /password %pw%
REM goto myself to achieve infinity loop
goto :conn_vnc