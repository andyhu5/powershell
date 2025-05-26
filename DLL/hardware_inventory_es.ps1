# Requires -Version 5.1 
# Not Suported on PowerShell Core

if ($Host.Version.Major -ne 5 ) {
    Write-Host -ForegroundColor Red "This script requires PowerShell 5.1,after 5 seconds to exit."
    Start-Sleep -Seconds 5
    exit
}
# Hardware ID Generation Methods
function Get-HardwareIdHash {
    <#
    .SYNOPSIS
    Generates a hardware ID using system-specific information
    
    .PARAMETER HashType
    Specify the hash algorithm (MD5 or SHA256)
    #>
    param(
        [ValidateSet('MD5', 'SHA256')]
        [string]$HashType = 'MD5'
    )

    # Collect system information
    $computerSystem = Get-CimInstance Win32_ComputerSystem
    $operatingSystem = Get-CimInstance Win32_OperatingSystem
    $baseboard = Get-CimInstance Win32_BaseBoard

    # Combine system identifiers
    $systemInfo = @(
        $computerSystem.Manufacturer,
        $computerSystem.Model,
        $computerSystem.SystemType,
        $operatingSystem.Version,
        $baseboard.SerialNumber,
        $env:COMPUTERNAME
    ) -join '|'

    # Create hash
    $encoder = [System.Text.Encoding]::UTF8
    $bytes = $encoder.GetBytes($systemInfo)

    switch ($HashType) {
        'MD5' {
            $hashAlgorithm = [System.Security.Cryptography.MD5]::Create()
            $hash = $hashAlgorithm.ComputeHash($bytes)
            return [BitConverter]::ToString($hash).Replace('-', '').ToLower()
        }
        'SHA256' {
            $hashAlgorithm = [System.Security.Cryptography.SHA256]::Create()
            $hash = $hashAlgorithm.ComputeHash($bytes)
            return [BitConverter]::ToString($hash).Replace('-', '').ToLower()
        }
    }
}

$guid = Get-HardwareIdHash -HashType 'MD5'


$ProgressPreference = 'SilentlyContinue'
$info = Get-ComputerInfo

# comuter name:
#$info.LogonServer.Replace('\\','')
# $disks = get-wmiobject -class win32_logicaldisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object { [System.Math]::Round( $_.size / 1000 / 1000 / 1000) }
# $disklist = [System.String]::Join("GB ", $disks)

$ram = [System.Math]::Round( $info.CsPhyicallyInstalledMemory / 1024 / 1024)
$timestamp = Get-Date -format "yyyy-MM-dd HH:mm:ss"
$hostname = $env:COMPUTERNAME
$cpu = $info.CsProcessors.Name
$ram = $ram.ToString()
# $disks = $disklist.ToString()
$gpu = (Get-WmiObject Win32_VideoController).VideoProcessor

# Hotfix list
# foreach ($item in $info.OsHotFixes){$HotFixIDss += $item.HotFixID + " "}

# Mac address
# foreach ($mac in (Get-NetAdapter)) { $macs += $mac.MacAddress + "|" }

# IP address
# $list = [System.Collections.ArrayList]::new()
# foreach ($ip in (Get-NetIPAddress)) {
#     if (($ip.AddressFamily -eq 'IPv4') -and ($ip.IPAddress -notmatch '169') -and ($ip.IPAddress -notmatch '127')) {
#         $null = $list.Add($ip.IPAddress)
#     }
# }
# $ips = $list -join "|"

# OS boottime
# $LastBootUpTime = $info.OsLastBootUpTime.ToString()
# $Uptime = $info.OsUptime.ToString()

# OS version
$OsVersion = $info.OsVersion
# Define credentials

$username = "forPowerShell"
$password = "Es@2013."

# Create Basic Authentication credentials
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))



$data = [ordered]@{}
$data["Id"] = $guid
# $data["Message"] = $timestamp + ',' + $hostname + ',' + $cpu + ',' + $ram + ',' + $gpu + ',' + $OsVersion
$data["timestamp"] = $timestamp
$data["hostname"] = $hostname
$data["cpu"] = $cpu
$data["ram"] = $ram
$data["gpu"] = $gpu
$data["OS"]=$OsVersion

#free macs variable.

# $macs = $null

$body = $data | ConvertTo-Json
$body

$response = Invoke-RestMethod 'http://elk.utools.run:19200/hardware_inventory/_doc' -Method 'POST' -Headers @{'Authorization' = "Basic $base64AuthInfo"} -Body $body -ContentType "application/json;charset=UTF-8"
$response | ConvertTo-Json
