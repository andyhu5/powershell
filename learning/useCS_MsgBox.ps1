$csharpCode = @"
using System;
using System.Windows.Forms;

public class MessageBoxHelper
{
    public static void ShowMessage(string message)
    {
        MessageBox.Show(message, "PowerShell C# Demo", MessageBoxButtons.YesNo, MessageBoxIcon.Information);
    }
}
"@

# 编译并引用 System.Windows.Forms
Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies "System.Windows.Forms"

# 调用 C# 方法显示消息框
[MessageBoxHelper]::ShowMessage("Hello from PowerShell and C#!")