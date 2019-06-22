@echo off

set "uvncinstaller=\\192.168.10.55\s\misc\UltraVNC_1_2_24_X86_Setup.exe"

REM Remove realvnc service
net stop winvnc4
sc delete winvnc4

REM Install ultravnc
%uvncinstaller% /dir="d:\uvnc" /passsword=fuck /components="UltraVnc_Server,UltraVNC_Viewer" /tasks=installservice,startservice,associate /silent /norestart