@echo off

REM Delete file with specified .ext and modified after specified date
REt /b %errorlevel% Move this script to directory where files needed to be delete
set tmpdir=%RANDOM%%RANDOM%
set date=01-01-2017
set ext=log

md %tmpdir%

xcopy /D:%date% *.%ext% %tmpdir%

del *.%ext%
move %tmpdir%\*.%ext% .
rd /s /q %tmpdir%
