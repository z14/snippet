@echo off

set py_installer=python-3.7.4-amd64.exe
set py_dir=c:\python

python -V 2> nul

if %errorlevel% EQU 9009 (
	rmdir /S /Q %py_dir%
	%py_installer% InstallAllUsers=1 TargetDir=%py_dir% PrependPath=1 Include_doc=0 Include_test=0 Include_tcltk=0 Shortcuts=0 SimpleInstall=0
)
