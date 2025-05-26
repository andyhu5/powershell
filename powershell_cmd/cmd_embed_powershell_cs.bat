<# :
echo "CMD script is running..."
chcp 65001 &cls&echo off&cd /d "%~dp0"&rem encoding ANSI
powershell -NoProfile -ExecutionPolicy bypass "[IO.File]::ReadAllText(\"%~f0\",[Text.Encoding]::GetEncoding('GB2312'))|Invoke-Expression"
exit /b 0
#>
write-host 

$csharpCode = @"
    using System;
    using System.Runtime.InteropServices;
    public class DllWrapper
    {
        [DllImport(@"C:\Users\sheng\source\repos\usePersonLibrary\x64\Release\Person.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
        public static extern string Test(string msg);

        [DllImport(@"C:\Users\sheng\source\repos\usePersonLibrary\x64\Release\Person.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
        public static extern int Add(int m,int n);
    }
"@

try {
    # Attempt to compile the C# code
    Add-Type -TypeDefinition $csharpCode -Language CSharp
    Write-Host "C# code compiled successfully."

    # Example usage of the compiled code
    $result = [DllWrapper]::Test("Hello from PowerShell")
    Write-Host "Result from C++ DLL: $result"

    $sum = [DllWrapper]::Add(5, 10)
    Write-Host "Sum from C++ DLL: $sum"
}
catch {
    Write-Host "Error compiling C# code: $_"
}