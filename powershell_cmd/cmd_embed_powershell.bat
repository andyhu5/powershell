<# :
chcp 65001 &cls&echo off&cd /d "%~dp0"&rem encoding ANSI
powershell -NoProfile -ExecutionPolicy bypass "[IO.File]::ReadAllText(\"%~f0\",[Text.Encoding]::GetEncoding('GB2312'))|Invoke-Expression"
pause
exit /b 0
#>
write-host "Hello World"
