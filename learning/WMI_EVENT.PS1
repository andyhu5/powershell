#Set up a hash table for parameters
$filterParams = @{
    Computername = $env:COMPUTERNAME
    QueryLanguage = 'WQL'
    Query = "select * from __instanceCreationEvent within 2 where targetInstance isa 'win32_Volume' AND TargetInstance.DriveType=2"
    EventNamespace = 'root\CIMV2'
    Namespace = 'root\subscription'
    Name = 'USBDrvFilter'
}
$consumerParams = @{
    Computername = $env:COMPUTERNAME
    ConsumerType = 'CommandLine'
    ExecutablePath = 'c:\\Windows\System32\cmd.exe'
    CommandLineTemplate = "C:\\Windows\\system32\\cmd.exe /c echo hello > %TargetInstance.DriveLetter\\test.txt%"
    Name = 'USBConsumer'
}


#Create the Filter and Consumer
$filterResult = New-WmiEventFilter @filterParams
$consumerResult = New-WmiEventConsumer @consumerParams


$bindingParams = @{
    Computername = $env:COMPUTERNAME
    Filter = $filterResult
    Consumer = $consumerResult
}
 
#Create the binding
$bindingResult = New-WmiFilterToConsumerBinding @bindingParams


##Removing WMI Subscriptions using Remove-WMIObject
#Filter
Get-WMIObject -Namespace root\Subscription -Class __EventFilter -Filter "Name='USBDrvFilter'" | 
    Remove-WmiObject -Verbose
 
#Consumer
Get-WMIObject -Namespace root\Subscription -Class LogFileEventConsumer -Filter "Name='USBConsumer'" | 
    Remove-WmiObject -Verbose
 
#Binding
Get-WMIObject -Namespace root\Subscription -Class __FilterToConsumerBinding -Filter "__Path LIKE '%USBDrvFilter%'"  | 
    Remove-WmiObject -Verbose
