
### 命令分类

# 命令参数
(Get-Command -Name Stop-Process).Parameters.Keys

# 动词
get-verb

#帮助 For Linux
# man -7 man 
# man -k fork

help *process*

# 命令筛选
get-command -Verb stop -Noun process

# 动词前缀分类
Get-Verb | Sort-Object -Property Verb

# 查看模块包含的命令
Get-Command -Module Microsoft.PowerShell.Management

# 语句
# where-object , Sort-Object ,Group-Object;
# % == foreach-object

1..20 | ForEach-Object{ [System.String] $_ } | Sort-Object

1..20 | %{ [System.String] $_ }

Get-Verb | Sort-Object -Property Verb | Group-Object -Property Group | Sort-Object -Property Count

#Foreach-object , PIPE pass arguments is objects in the pipeline
1..20 | ForEach-Object { [System.String] $_ } | Sort-Object
# get-process and filter name like wsl
Get-Process | Where-Object { $_.Name -like "*wsl*" } | ForEach-Object { $_.Name }

#PIPE管道

Get-Service -Name DDD | Stop-Service
Get-Service -Name DDD | Restart-Service # 需要管理员权限

# 调用WMI Only for 5.1
Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Property Caption, Version, BuildNumber
# 调用WMI并筛选
Get-WmiObject -Class Win32_OperatingSystem | Where-Object { $_.Version -like "10.*" } | Select-Object -Property Caption, Version, BuildNumber

# 使用invoke-cimethod Create method to start notepad
# Invoke-CimMethod is a cmdlet that allows you to invoke methods on CIM classes.
$procid = Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{CommandLine = "notepad.exe"}
Stop-Process -Id $procid.ProcessId


# 函数
function Multiply-ArrayByTwo {
    # pipeline 管道
    param (
        [Parameter(ValueFromPipeline = $true)]
        [int[]]$InputArray
    )
    process {
        foreach ($item in $InputArray) {
            $item * 2
        }
    }
}

$arr = @(1, 2, 3)
Multiply-ArrayByTwo($arr)

$arr | Multiply-ArrayByTwo

# 函数~2:参数限制

function Write-Log
{

 param(
        [ValidateSet(‘INFO’,’ERR’,’FATAL’)] $level,
        [System.String] $Message
    )



    $timestamp = Get-Date -f 'o'
    $hostname = $env:COMPUTERNAME
    $logEntry = [ordered]@{}

    $logEntry["timestamp"] = $timestamp
    $logEntry["level"] = $level
    $logEntry["hostname"] = $hostname
    $logEntry["message"] = $message

    $body = $logEntry | ConvertTo-Json
    Invoke-RestMethod -Uri http://www.xxx.com/post -ContentType "Application/json;charset=UTF-8" -Method Post -Body $body
}


Write-Log -level INFO -Message "Hello World"


# 类

class Person {
    # Properties (with validation)
    [string]$Name
    [int]$Age

    # Private property (only accessible within the class)
    hidden [string]$_secretKey

    # Static property (shared across all instances)
    static [int]$SpeciesCount = 0

    # Constructor with parameter validation
    Person([string]$name, [int]$age) {
        # Validate input
        if ($null -eq $name -or $name.Length -eq 0) {
            throw [System.ArgumentException]::new("Name cannot be null or empty")
        }
        
        if ($age -lt 0 -or $age -gt 120) {
            throw [System.ArgumentException]::new("Invalid age")
        }

        $this.Name = $name
        $this.Age = $age
        
        # Increment static property
        [Person]::SpeciesCount++
    }

    # Method to introduce the person
    [void]Introduce() {
        Write-Host "Hi, I'm $($this.Name) and I'm $($this.Age) years old."
    }

    # Method with return value
    [bool]IsAdult() {
        return $this.Age -ge 18
    }

    # Static method
    static [void]DisplaySpeciesCount() {
        Write-Host "Total persons created: $([Person]::SpeciesCount)"
    }

    # Method to set a private property
    [void]SetSecretKey([string]$key) {
        $this._secretKey = $key
    }

    # Method to get a private property
    [string]GetSecretKey() {
        return $this._secretKey
    }
}

# Create instances
$person1 = [Person]::new("Alice", 30)
$person2 = [Person]::new("Bob", 25)

# Call methods
$person1.Introduce()
Write-Host "Is Adult: $($person1.IsAdult())"

# Call static method
[Person]::DisplaySpeciesCount()

# Demonstrate private property interaction
$person1.SetSecretKey("MySecretPassword")
Write-Host "Secret Key: $($person1.GetSecretKey())"


# Powershell 异常处理

try
{
    ##Get-Content C:\utools\collectLogs.bat2 -ErrorAction Stop
    lls
}
catch [System.Management.Automation.CommandNotFoundException]
{
    Write-Host "Error Type: $($_.Exception.GetType().FullName)"
}
finally
{
    Write-Host "cleaning up ..."
}



## 自定义异常

# Define a custom exception class
class CustomFileValidationException : Exception {
    $FilePath
    
    CustomFileValidationException($message, $filePath) : base($message) {
        $this.FilePath = $filePath
    }
}

# Function that throws a custom exception
function Test-FileValidation {
    param(
        [string]$FilePath
    )
    
    try {
        # Check if file exists
        if (-not (Test-Path $FilePath)) {
            # Throw custom exception
            throw [CustomFileValidationException]::new(
                "File does not exist or cannot be accessed", 
                $FilePath
            )
        }
        
        # Check file size
        $fileInfo = Get-Item $FilePath
        if ($fileInfo.Length -eq 0) {
            throw [CustomFileValidationException]::new(
                "File is empty", 
                $FilePath
            )
        }
        
        Write-Host "File is valid: $FilePath"
    }
    catch [CustomFileValidationException] {
        Write-Host "Custom Validation Error:"
        Write-Host "Message: $($_.Exception.Message)"
        Write-Host "File Path: $($_.Exception.FilePath)"
    }
    catch {
        Write-Host "Unexpected error: $_"
    }
}

# Example usage
Test-FileValidation -FilePath "C:\nonexistent\file.txt"
Test-FileValidation -FilePath "C:\empty\file.txt"



# data structures

# Array
$myArray = @("apple", "banana", "cherry")
$myArray.GetType()
# Hashtable
$myHashtable = @{
    "Name" = "John Doe"
    "Age" = 30
    "City" = "New York"
}
$myHashtable.GetType()

# ArrayList
$myArrayList = New-Object System.Collections.ArrayList
$myArrayList.Add("apple") | Out-Null
$myArrayList.Add("banana") | Out-Null
$myArrayList.Add("cherry") | Out-Null
$myArrayList
# Dictionary
$myDictionary = [System.Collections.Generic.Dictionary[string, int]]::new()
$myDictionary.Add("apple", 1)
$myDictionary.Add("banana", 2)
$myDictionary.Add("cherry", 3)
# List
$myList = [System.Collections.Generic.List[string]]::new()
$myList.Add("apple")
$myList.Add("banana")
$myList.Add("cherry")
# Ordered Dictionary
$myOrderedDictionary = [System.Collections.Specialized.OrderedDictionary]::new()
$myOrderedDictionary.Add("Name", "John Doe")
$myOrderedDictionary.Add("Age", 30)
$myOrderedDictionary.Add("City", "New York")

# use powershell simplify syntax to create data structures
$myArray = @("apple", "banana", "cherry")
$myHashtable = @{
    Name = "John Doe"
    Age = 30
    City = "New York"
}
$myArrayList = [System.Collections.ArrayList]@("apple", "banana", "cherry")
$myDictionary = [ordered] @{
    apple = 1
    banana = 2
    cherry = 3
}
$myDictionary

# List
$myList = [System.Collections.Generic.List[string]]@("apple", "banana", "cherry")
# Ordered Dictionary


### other skills
# Powershell load dll

[void][System.Reflection.Assembly]::UnsafeLoadFrom("learning\101\Math.dll")
[Math.methods]::Add(10,20)

$a=New-Object Math.Methods
$a.Compare(10,20)

# others

# Long command with many parameters all on one line
Send-MailMessage -From "admin@example.com" -To "user@example.com" -Subject "Test Email" -Body "This is a test email." -SmtpServer "smtp.example.com" -Port 587 -UseSsl -Credential (Get-Credential) -Attachments "C:\path\to\file.txt" -Priority High -DeliveryNotificationOption OnSuccess, OnFailure

# Equivalent command using splatting for readability
$mailParams = @{
    From                     = "admin@example.com"
    To                       = "user@example.com"
    Subject                  = "Test Email"
    Body                     = "This is a test email."
    SmtpServer               = "smtp.example.com"
    Port                     = 587
    UseSsl                   = $true
    Credential               = (Get-Credential)
    Attachments              = "C:\path\to\file.txt"
    Priority                 = "High"
    DeliveryNotificationOption = "OnSuccess, OnFailure"
}

Send-MailMessage @mailParams

# Powershell - Taking a screenshot winform capture 
[Reflection.Assembly]::LoadWithPartialName("System.Drawing")
function screenshot([Drawing.Rectangle]$bounds, $path) {
   $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
   $graphics = [Drawing.Graphics]::FromImage($bmp)
$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
$bmp.Save($path)
$graphics.Dispose()
   $bmp.Dispose()
}
$bounds = [Drawing.Rectangle]::FromLTRB(0, 0, 1000, 900)
screenshot $bounds "C:\screenshot.png"
Start-Process "C:\screenshot.png"