function Test-TcpPort {
    param(
        [string]$ComputerName,
        [int]$Port,
        [int]$TimeoutSeconds = 5
    )
    
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    try {
        $task = $tcpClient.ConnectAsync($ComputerName, $Port)
        if ($task.Wait($TimeoutSeconds * 1000)) {
            return $tcpClient.Connected
        } else {
            return $false
        }
    } catch {
        return $false
    } finally {
        $tcpClient.Close()
    }
}

# Usage
if (Test-TcpPort -ComputerName "baidu.com" -Port 80 -TimeoutSeconds 3) {
    Write-Host "Port 80 is open"
} else {
    Write-Host "Port 80 is closed or timed out"
}