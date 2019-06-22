:: copy sed/
set sed_dir_remote=%server%\misc\sed
set utils=d:\utils

if not exist %utils%\sed.exe (
xcopy /S /Y %sed_dir_remote% %utils%\ > nul
)