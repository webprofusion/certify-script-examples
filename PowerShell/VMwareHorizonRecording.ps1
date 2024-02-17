#-----------------------------------------------#
#------VMware Horizon Recording Server----------#
#------Author: Taylor D. Marchetta--------------#
#------Verison 3.0.0----------------------------#
#-----------------------------------------------#

param($result)

if ($result.IsSuccess) {

    # Define necessary variables
    $pfxPath = $result.ManagedItem.CertificatePath # Update with correct path to pfx file
    $targetMachine = "<target.domain.com>"  # Update with correct target machine name
    # Specify the credentials for authentication
    $username = "<DOMAIN\username>" # Update with correct services account
    $password = ConvertTo-SecureString "<Your Password>" -AsPlainText -Force # Update with correct password
    $credential = New-Object System.Management.Automation.PSCredential($username, $password) # Create credential object
    $remotePath = "C:\Temp\file.pfx" # Update with correct path to save pfx file
    $certStoreLocation = "Cert:\LocalMachine\My" # Update with correct cert store location
    $thumbprint = $result.ManagedItem.CertificateThumbprintHash # Update with correct thumbprint

    $base64Pfx = [Convert]::ToBase64String((Get-Content -Path $pfxPath -Encoding Byte))
    $scriptBlock = {
        param($base64Pfx, $remotePath, $thumbprint, $certStoreLocation)
        try {
            $bytes = [Convert]::FromBase64String($base64Pfx)
            [System.IO.File]::WriteAllBytes($remotePath, $bytes)

            # Import the new certificate
            Import-PfxCertificate -FilePath $remotePath -CertStoreLocation $certStoreLocation

            # Set friendly name for the certificate
            $certFriendlyName = 'HorizonSessionRecordingServer'

            # Remove the old cert (by Friendly Name 'HorizonSessionRecordingServer') to avoid duplication, if it exists
            Get-ChildItem -Path $certStoreLocation | Where-Object { $_.FriendlyName.Equals($certFriendlyName) } | Remove-Item

            # rename our new certificate
            $cert = Get-ChildItem -Path cert:\LocalMachine\My\$thumbprint

            $cert.FriendlyName = $certFriendlyName

            # Restart the VMware Horizon Recording Server service
            Restart-Service "VMware Horizon Recording Server" -Force -ErrorAction Stop
        }
        catch {
            Write-Error "An error occurred: $_"
        }
    }

    $resultsOut = Invoke-Command -ComputerName $targetMachine -ScriptBlock $scriptBlock -ArgumentList $base64Pfx, $remotePath, $thumbprint, $certStoreLocation -Credential $credential

    # Display results
    $resultsOut
}