@echo off
for /f "tokens=4 delims= " %%i in ('ver') do set winver=%%i
set winver=%winver:~0,-1%
exit /b %errorlevel%