Add-Type -Path .\Hello.dll
$hello = New-Object AndyHU.Tools
$hello.Greet("AndyHU")