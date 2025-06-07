using System.Management.Automation;

namespace MyBinaryModule
{
    [Cmdlet(VerbsCommon.Get, "CustomGreeting")]
    public class GetCustomGreeting : PSCmdlet
    {
        [Parameter(Mandatory = true, Position = 0)]
        public string Name { get; set; }

        protected override void ProcessRecord()
        {
            WriteObject($"Hello, {Name}! This is a binary module in PowerShell!");
        }
    }

    [Cmdlet(VerbsDiagnostic.Test, "SystemInfo")]
    public class TestSystemInfo : PSCmdlet
    {
        protected override void ProcessRecord()
        {
            WriteObject($"Running on {System.Environment.OSVersion}");
        }
    }

}