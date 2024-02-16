param($result)  

# adapt paths and passwords as required, assumes keytool is in the system path
# this examples uses -noprompt to avoid the process hanging on prompts and also redirects output to a single stream otherwise keytool will output to the powershell error stream

# update these parameters as required
$src_password =""
$dest_password ="examplepwd"
$dest_jks_file="C:\temp\mykeystore.jks"


keytool -noprompt -importkeystore -srckeystore $result.ManagedItem.CertificatePath -srcstoretype pkcs12 -srcstorepass $src_password -destkeystore $dest_jks_file -deststoretype JKS -deststorepass $dest_password *>&1
