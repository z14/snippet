@echo off
REM Query BDE cfg file path.

if exist "c:\Program Files (x86)" (
set keyname=HKLM\SOFTWARE\WOW6432Node\Borland\Database Engine
) else (
set keyname=HKLM\SOFTWARE\Borland\Database Engine
)
set valuename=CONFIGFILE01

reg query "%keyname%" /v %valuename%

pause

exit /b
