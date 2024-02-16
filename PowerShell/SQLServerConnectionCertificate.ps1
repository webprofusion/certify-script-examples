# Example script to set SQL Server connection certificate

# Note that some instances of SQL server may require certificate key storage to use the "Microsoft RSA SChannel Cryptographic Provider"
# See an example conversion: https://docs.certifytheweb.com/docs/script-hooks#example-convert-cng-certificate-storage-to-csp-for-exchange-2013

param($result)

# See HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\ for the required instance key
$instanceKey = 'MSSQL15.MSSQLSERVER'  # Change this as required

# -------------------------------------------------------------------------

$registryPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\$instanceKey\MSSQLServer\SuperSocketNetLib"
$oldthumbprint = (Get-Itemproperty -Path $registryPath).Certificate
$newthumbprint = $result.ManagedItem.CertificateThumbprintHash

if ($oldthumb -ne $newthumb) { 

  # apply the new certificate thumbprint to the registry key
  Set-ItemProperty -Path $registryPath -Name 'Certificate' -Value $newthumb

  # optionally restart the SQL service (uncomment if required in this step), correct service name may vary
  # Restart-Service mssqlserver
}