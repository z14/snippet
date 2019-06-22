@echo off

set lnk_path=%ProgramFiles%\internet explorer\iexplore.exe baidu.com

call :is_xp
echo %lnk%
call :create_lnk

pause

exit /b %errorlevel%

REM Define Functions

:create_lnk
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%lnk%" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%lnk_path%" >> %SCRIPT%
:: echo oLink.IconLocation = %lnk_path% >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%
exit /b %errorlevel%

:: Is Windows XP?
:is_xp
ver | find "5.1" > nul 
if %errorlevel% equ 0 (
set "lnk=%USERPROFILE%\桌面\十堰医保定点机构信息管理系统.lnk"
) else (
set "lnk=%USERPROFILE%\Desktop\十堰医保定点机构信息管理系统.lnk"
)
exit /b %errorlevel%
