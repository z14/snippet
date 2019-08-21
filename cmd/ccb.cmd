@echo off
REM ybDevice.701.dll ≈©…Ã––

set "server=\\192.168.10.55\s"
set "pos_path=d:\KSOA POS"

pushd "%pos_path%"
copy /Y %server%\pos\ybDevice.702.dll ybDevice.dll

exit /b