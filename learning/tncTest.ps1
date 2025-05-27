# Test-NetConnection (tnc) examples 1
tnc www.baidu.com -p 80

# Test-NetConnection (tnc) examples 2
$ProgressPreference = 'SilentlyContinue'
"www.baidu.com","sina.com","163.com","vip.com","sohu.com","microsoft.com","github.com" | tnc -p 80


# Test-NetConnection (tnc) examples 3
"x.com" ,"www.baidu.com","sina.com","163.com","vip.com","sohu.com","microsoft.com","github.com" | tnc -p 80 -InformationAction Continue  | Select-Object ComputerName, TcpTestSucceeded


# Test-NetConnection (tnc) examples 4
"x.com","www.baidu.com","sina.com","163.com","vip.com","sohu.com","microsoft.com","github.com" | ForEach-Object -Parallel {
    $result = Test-NetConnection -ComputerName $_ -Port 80
    [PSCustomObject]@{
        Website = $_
        TcpTestSucceeded = $result.TcpTestSucceeded
    }
} | Format-Table -AutoSize

# use ping to test connection
"x.com","www.baidu.com","sina.com","163.com","vip.com","sohu.com","aws.com","github.com" | ForEach-Object -Parallel {
    $originalDomain = $_
    Test-Connection -ComputerName $_ -TimeoutSeconds 5 -Count 1 | 
    Select-Object @{Name='Domain';Expression={$originalDomain}},
                  Source,Address,Status,BufferSize,
                  @{Name='ResolvedName';Expression={$_.ComputerName}}
} | Format-Table -AutoSize


# use ping to test connection
1..100 | ForEach-Object -Parallel {
    $ip = "192.168.3.$_"
    Test-Connection -ComputerName $ip -TimeoutSeconds 5 -Count 1 -ErrorAction SilentlyContinue | 
    Select-Object @{Name='IP';Expression={$ip}},
                  Source,Address,Status,BufferSize,
                  @{Name='ResolvedName';Expression={$_.ComputerName}}
} | Where-Object {$_ -ne $null} | Format-Table -AutoSize