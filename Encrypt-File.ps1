if(-Not (Test-Path -Path Cert:\CurrentUser\My\BC07CD0F1718E6F7F10A22E3C42585B14E6571ED)){
  New-SelfSignedCertificate -DnsName MyDocumentEncryption -FriendlyName MyDocumentEncryption -CertStoreLocation 'Cert:\CurrentUser\My' -KeyUsage KeyEncipherment,DataEncipherment, KeyAgreement -Type DocumentEncryptionCert
}

'SecretPassword!@#$' | Protect-CmsMessage -To CN=MyDocumentEncryption -OutFile .\Password1

Get-CmsMessage -Path .\Password1
Unprotect-CmsMessage -Path .\Password1


