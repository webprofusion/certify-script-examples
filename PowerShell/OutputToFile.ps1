# Logs the result object as JSON to the given path

param($result)  
$logpath = "c:\temp\ps-test.txt"

$date = Get-Date

Add-Content $logpath ("-------------------------------------------------");
Add-Content $logpath ("Script Run Date: " + $date)
Add-Content $logpath ($result | ConvertTo-Json)