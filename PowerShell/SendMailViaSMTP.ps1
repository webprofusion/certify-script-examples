# example showing how to send an email if the renewal has failed, via SMTP in PowerShell

param($result)

if (!$result.IsSuccess) {
   $EmailFrom = "username@gmail.com"
   $EmailTo = "username@gmail.com"
   $Subject = "Cert Request Failed: " + $result.ManagedItem.RequestConfig.PrimaryDomain
   $Body = "Error: " + $result.Message
   $SMTPServer = "smtp.gmail.com"
   $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
   $SMTPClient.EnableSsl = $true
   $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("username@gmail.com", "password");
   $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
   write-output "Sent notification email"
}