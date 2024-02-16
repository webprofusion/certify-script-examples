# This is adapted from a community example: https://community.certifytheweb.com/t/sql-server-reporting-services-ssrs/332/7
# This script gets the report server config object the checks if an existing cert is bound it removes that, then creates the new binding.

param($result)

$ssrsServerName = "RS_MSSQLSERVER"
$ssrsReportManagerName = "ReportManager"
$ssrsReportWebServiceName = "ReportServerWebService"

$httpsPort = 443
$ipAddress = "0.0.0.0"

# Find the ssrsServerName by running:
# Get-WmiObject -namespace root\Microsoft\SqlServer\ReportServer -class __Namespace
# take the value of the name field

$version = (Get-WmiObject –namespace root\Microsoft\SqlServer\ReportServer\$ssrsServerName  –class __Namespace).Name
$rsConfig = Get-WmiObject –namespace "root\Microsoft\SqlServer\ReportServer\$ssrsServerName\$version\Admin" -class MSReportServer_ConfigurationSetting

# the cert thumbnail of the newest certificate
$newthumb = $result.ManagedItem.CertificateThumbprintHash.ToLower()

# check the cert thumbnail of the currently bound certificate (if any)

$oldthumb = ''

try {
   $oldthumb = $rsConfig.ListSSLCertificateBindings(1033).CertificateHash.Item([array]::LastIndexOf($rsConfig.ListSSLCertificateBindings(1033).Application, $ssrsReportManagerName))

   if ($oldthumb -ne $newthumb) {      
      $rsConfig.RemoveSSLCertificateBindings($ssrsReportManagerName, $oldthumb, $ipAddress, $httpsport, 1033) 
      $rsConfig.RemoveSSLCertificateBindings($ssrsReportWebServiceName, $oldthumb, $ipAddress, $httpsport, 1033)
   }
} catch {}

$rsConfig.CreateSSLCertificateBinding($ssrsReportManagerName, $newthumb, $ipAddress, $httpsport, 1033)
$rsConfig.CreateSSLCertificateBinding($ssrsReportWebServiceName, $newthumb, $ipAddress, $httpsport, 1033)