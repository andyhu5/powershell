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

# Example usage
$hardwareId = Get-HardwareIdHash -HashType 'SHA256'
Write-Output "Hardware SHA256 ID: $hardwareId"

$hardwareId = Get-HardwareIdHash -HashType 'MD5'
Write-Output "Hardware MD5 ID: $hardwareId"