clear-host
Write-Host "Hello, World!"
Write-Host "This is a PowerShell script."

function import-DLL {
    Add-Type -Path .\Hello.dll
    $hello = New-Object Hello.App
    $hello::Test("Joe")
}

try {
    if (Test-Path .\Hello.dll) {
        import-DLL

    }
    else {
        <# Action when all if and elseif conditions are false #>
        Invoke-RestMethod http://192.168.3.100:8000/dll -OutFile Hello.dll -erroraction SilentlyContinue
        import-DLL
    }

}
catch {
    Write-Host "Failed to download the DLL. Please check the URL or network connection."
}
