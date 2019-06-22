:del_old_files
if not exist %windir%\system32\forfiles.exe call %cmd%\cp_forfiles
echo 删除旧日志文件，最长可能需要3分钟左右，耐心等待！请勿关闭本窗口！！
forfiles /p "%pos_path%\Logs" /D -60 /C "cmd /c del @path"
exit /b %errorlevel%