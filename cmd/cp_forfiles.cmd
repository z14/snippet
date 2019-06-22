REM Define Functions
:: Copy forfiles.exe
:cp_forfiles
set forfiles=%server%\misc\forfiles.exe
copy %forfiles% %windir%\system32 > nul
exit /b %errorlevel%