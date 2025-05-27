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

# Test-NetConnection (tnc) examples 5
"x.com","www.baidu.com","sina.com","163.com","vip.com","sohu.com","microsoft.com","github.com" | ForEach-Object  {
    if (Test-TcpPort -ComputerName $_ -Port 80 -TimeoutSeconds 2) {
        Write-Host "{$_} Port 80 is open"
    } else {
        Write-Host "{$_} Port 80 is closed or timed out"
    }
}