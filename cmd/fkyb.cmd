@echo off
set "server=\\192.168.10.55\s"
set "cmd=%server%\cmd"

call %cmd%\is_xp
if %errorlevel% equ 0 (
set "desktop=%USERPROFILE%\桌面"
set "alldesktop=C:\Documents and Settings\All Users\桌面"
) else (
set "desktop=%USERPROFILE%\Desktop"
set "alldesktop=C:\Users\Public\Desktop"
)

del "%alldesktop%\十堰医保定点机构信息管理系统.url" 2> nul
del "%alldesktop%\医保定点机构信息管理系统.url" 2> nul
copy %server%\public\十堰医保定点机构信息管理系统.lnk "%desktop%\医保.lnk"

pause
