set pos_ini=pos_set\POSdevice.ini
set yb_ini=pos_set\ybDevice.ini

for /f "delims== tokens=2" %%i in ('find /i "±æµÍ±Í ∂=" "%pos_ini%"') do set sid=%%i
for /f "delims== tokens=2" %%i in ('find /i "÷’∂À∫≈=" "%pos_ini%"') do set rcb=%%i

curl -m1 -d "sid=%sid%&%rcb=%rcb%&" http://192.168.10.55/api/posstat
