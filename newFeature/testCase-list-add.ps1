# PowerShell 7.5 数组操作优化 Demo

# 初始化测试数据
$iterations = 100000
$array = @()
$list = [System.Collections.Generic.List[object]]::new()

# 测试 1：使用 += 操作符向数组添加元素
Write-Host "Testing array with += operator..."
$startTimeArray = Get-Date
for ($i = 0; $i -lt $iterations; $i++) {
    $array += $i
}
$endTimeArray = Get-Date
$timeArray = ($endTimeArray - $startTimeArray).TotalMilliseconds

# 测试 2：使用 List<T>.Add() 方法
Write-Host "Testing List<T>.Add()..."
$startTimeList = Get-Date
for ($i = 0; $i -lt $iterations; $i++) {
    $list.Add($i)
}
$endTimeList = Get-Date
$timeList = ($endTimeList - $startTimeList).TotalMilliseconds

# 输出结果
Write-Host "Array += Time: $timeArray ms"
Write-Host "List<T>.Add Time: $timeList ms"
Write-Host "Performance Difference (Array vs List): $([math]::Round(($timeArray / $timeList), 2))x"

# 验证数组和列表的内容长度
Write-Host "Array Length: $($array.Count)"
Write-Host "List Length: $($list.Count)"