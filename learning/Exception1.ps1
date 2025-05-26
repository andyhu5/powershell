try {
    Get-Process -Name notepad 
}
catch {
    write-host "not found notepad"
}
finally {
    <#Do this after the try block regardless of whether an exception occurred or not#>
}
