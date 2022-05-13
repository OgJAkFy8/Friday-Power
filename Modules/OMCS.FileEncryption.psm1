function Protect-File
{
  <#
      .SYNOPSIS
      A nice way to secure those desktop notes.
      Encrypts a file using a local "DocumentEncryption" cert.  

      .DESCRIPTION
      This is a quick way to encrypt files that you want to keep secure, but shouldn't be the only copy of the data.  
      This relys on a local cert that could be lost if the computer is reimaged or your profile is deleted.

      .PARAMETER InputFile
      File to be encrypted.  Suggest keeping is simple and use a text (.txt) file.

      .EXAMPLE
      Protect-File -InputFile Value
      Encrypts the file "Value.txt" and renames it to "Value.cqr".

      .NOTES
      Currently None
  #>

  [CmdletBinding(SupportsShouldProcess,ConfirmImpact = 'Low')]
  param(
    [Parameter(Mandatory,HelpMessage = 'File to encrypt')]
    [String]$InputFile
  )

  $SecureExt = '.cqr'
  $ext = (Get-ItemProperty -Path $InputFile).Extension
  $CqrFile = ($InputFile).Replace($ext,$SecureExt)
  Rename-Item -Path $InputFile -NewName $CqrFile

  $CertHash = Get-ChildItem -Path Cert:\CurrentUser\My\
  $CertThumb = $CertHash.GetEnumerator().Where({
      $_.Subject -match 'MyDocumentEncryption'
  }).thumbprint

  if(-Not (Test-Path -Path ('Cert:\CurrentUser\My\{0}' -f $CertThumb)))
  {
    New-SelfSignedCertificate -DnsName MyDocumentEncryption -FriendlyName MyDocumentEncryption -CertStoreLocation 'Cert:\CurrentUser\My' -KeyUsage KeyEncipherment, DataEncipherment, KeyAgreement -Type DocumentEncryptionCert
  }
  $InputFile = (Get-ItemProperty -Path $CqrFile).FullName
  Get-Content -Path $InputFile | Protect-CmsMessage -To CN=MyDocumentEncryption -OutFile $InputFile
}

function Unprotect-File
{
  <#
      .SYNOPSIS
      Unprotects files encrypted using the Protect-File function

      .DESCRIPTION
      Add a more complete description of what the function does.

      .PARAMETER InputFile
      The file to be unencrypted.  File must have CQR extension.

      .PARAMETER Replace
      If this switch is on the .cqr files will be replaced with .txt files.

      .EXAMPLE
      Unprotect-File -InputFile Value.cqr -Replace
      Unencrypts and over writes the file "value.cqr" and saves it as "value.txt" 

      .EXAMPLE
      Unprotect-File -InputFile Value.cqr 
      Unencrypts the file "value.cqr" to the console and does not change the orginal encrypted (.cqr) file.

      .EXAMPLE
      Unprotect-File -InputFile Value.cqr | Out-File "NewTextFile.txt"
      Unencrypts the file "value.cqr" and sends it to "NewTextFile.txt" keeping the original encrypted (.cqr) file intact.

      .NOTES
      Currently none
  #>

  [CmdletBinding(SupportsShouldProcess,ConfirmImpact = 'Low')]
  param(
    [Parameter(Mandatory,HelpMessage = 'File needs to have CQR extension')]
    [ValidateScript({
          If($_ -match '.cqr')
          {
            $true
          }
          Else
          {
            Throw 'Input file needs to have CQR extension'
          }
    })][String]$InputFile,
    [Parameter(Mandatory = $false)]
    [Switch]$Replace
  )

  $ClearText = Unprotect-CmsMessage -Path $InputFile

  if($Replace)
  {
    $ClearTextFile = ($InputFile).Replace('cqr','.txt')
    Rename-Item -Path $InputFile -NewName $ClearTextFile
    $ClearText | Out-File -FilePath $ClearTextFile -Force
  }
  else
  {
    Return $ClearText
  }
}

function New-TestFiles
{
  <#
      .SYNOPSIS
      Creates 5 test files named PassTest-0.txt to PassTest-4.txt.

      .EXAMPLE
      New-TestFiles
      In the current directory it creates a series of 5 test files

      .INPUTS
      None

      .OUTPUTS
      Name          
      ----          
      PassTest-0.txt
      PassTest-1.txt
      PassTest-2.txt
      PassTest-3.txt
      PassTest-4.txt
  #>

  $srv = Get-Service | Select-Object -First 10
  for($i = 0;$i -lt 5;$i++)
  {
    $srv |
    Out-File  -FilePath ('.\PassTest-{0}.txt' -f $i)
  }
  #('.\PassTest-{0}.cqr' -f (Get-Date -UFormat %j%M%S))
}

Export-ModuleMember -Function Protect-File, Unprotect-File, New-TestFiles
