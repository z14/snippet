@echo off
set server=\\192.168.10.55\s
::reg import %server%\reg\proxy.reg
regedit /S %server%\reg\proxy.reg