@echo off
if %processor_architecture% == x86 (
exit /b 0
) else (
exit /b 1
)