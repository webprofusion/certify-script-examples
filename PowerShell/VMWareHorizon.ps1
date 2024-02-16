# This example removes any previous certificate with the same FriendlyName (vdm) then renames the Friendly Name property of the new certificate to vmd. It then restarts the wstunnel service.

param($result)

if ($result.IsSuccess) {

   $thumbprint = $result.ManagedItem.CertificateThumbprintHash # e.g. 2c127d49b4f63d947dd7b91750c9e57751eced0c

   # remove the old cert (by Friendly Name 'vdm') to avoid duplication, if it exists
   Get-ChildItem -Path cert:\LocalMachine\My | Where {$_.FriendlyName.Equals("vdm")} | Remove-Item

   # rename our new certificate
   $cert = Get-ChildItem -Path cert:\LocalMachine\My\$thumbprint

   $cert.FriendlyName ="vdm"

   # restart the wstunnel service to apply certificate
   Restart-Service wstunnel -Force -ErrorAction Stop
}