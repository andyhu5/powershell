dotnet build --configuration release
; kill pwsh.exe
taskkill /IM pwsh.exe /F
copy C:\Users\sheng\powershell\learning\303\MyBinaryModule\bin\release\net9.0\MyBinaryModule.dll C:\Users\sheng\Documents\PowerShell\Modules\MyBinaryModule
