# MyUtilityModule.psm1

function Get-CustomGreeting {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    Write-Output "Hello, $Name! Welcome to PowerShell Modules!"
}

function Get-SystemInfo {
    Write-Output "OS: $(Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption).Caption"
}

# 导出模块成员
Export-ModuleMember -Function Get-CustomGreeting, Get-SystemInfo