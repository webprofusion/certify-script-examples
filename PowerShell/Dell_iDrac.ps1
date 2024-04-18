#-----------------------------------------------#
#------CTW_iDrac--------------------------------#
#------Author: Taylor D. Marchetta--------------#
#------Verison 1.0.2----------------------------#
#-----------------------------------------------#

# Defines variables for iDRAC hostname, credentials, and certificate files.
# Uploads new SSL certificate and key to the iDRAC using racadm.
# Resets iDRAC after uploading new certificate.

# Define necessary variables
$hostname = "idrac-dell.com"
$username = "root"
$password = "calvin"
$fullchainfile = "fullchain.pem"
# End of variables

try {
    $serverCertFile = Get-ChildItem -Path "C:\CTW\Certs\$($hostname)\$($fullchainfile)" -ErrorAction Stop
} catch {
    Write-Error "Failed to get the server certificate file: $_"
    exit
}

try {
    $serverKeyFile = Get-ChildItem -Path "C:\CTW\Certs\$($hostname)\privkey.pem" -ErrorAction Stop
} catch {
    Write-Error "Failed to get the server key file: $_"
    exit
}

# Upload new certificate and key to iDRAC
racadm.exe -S -r "$hostname" -u "$username" -p "$password" sslkeyupload -t 1 -f "$serverKeyFile"
racadm.exe -S -r "$hostname" -u "$username" -p "$password" sslcertupload -t 1 -f "$serverCertFile"
# Reset iDRAC
racadm.exe -S -r "$hostname" -u "$username" -p "$password" racreset