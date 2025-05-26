@echo on
setlocal EnableDelayedExpansion
chcp 65001

:: Initialize JSON array
set "json=["
set "first=1"

for /f "tokens=1,3 delims=, skip=1" %%a in ('getmac /v /FO csv ') do (
    if !first! equ 1 (
        set "json=!json!{"Name":"%%~a","MacAddress":"%%~b"}"
        set "first=0"
    ) else (
        set "json=!json!,{"Name":"%%~a","MacAddress":"%%~b"}"
    )
)

:: Close JSON array
set "json=%json%]"

echo !json! > temp.json

:: Send JSON data with curl
curl -X POST -H "Content-Type: application/json" -d "@temp.json" http://localhost:8000/api/network-interfaces

:: Clean up and exit
set "first="
set "json="

endlocal
