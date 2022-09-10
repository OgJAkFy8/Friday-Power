 <#
      .SYNOPSIS
      Open Minded Common Sense script from Knarr Studio  

      .LINK
      https://github.com/OgJAkFy8/Friday-Power/blob/main/Modules/OMCS.FileEncryption.psm1
  #>

function Protect-TextFile
{
  <#
      .SYNOPSIS
      A nice way to secure those desktop notes.
      Encrypts a file using a local "DocumentEncryption" cert.  

      .DESCRIPTION
      This is a quick way to encrypt files that you want to keep secure, but shouldn't be the only copy of the data.  
      This relys on a local cert that could be lost if the computer is reimaged or your profile is deleted.

      .PARAMETER InputFile
      File to be encrypted.  Suggest keeping it simple and use a text (.txt) file.

      .EXAMPLE
      Protect-File -InputFile Value
      Encrypts the file "Value.txt" and renames it to "Value.cqr".

      .NOTES
      Currently None
  #>

  [CmdletBinding(SupportsShouldProcess,ConfirmImpact = 'High')]
  param(
    [Parameter(Mandatory,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
    HelpMessage = 'File to encrypt')]
    [Alias('InputFile')]
    [String[]]$Name
  )
  Begin{
    $SecureExt = '.cqr'
    $CertHash = Get-ChildItem -Path Cert:\CurrentUser\My\
    $CertThumb = $CertHash.GetEnumerator().Where({
        $_.Subject -match 'MyDocumentEncryption'
    }).thumbprint

    if(-Not (Test-Path -Path ('Cert:\CurrentUser\My\{0}' -f $CertThumb)))
    {
      New-SelfSignedCertificate -DnsName MyDocumentEncryption -FriendlyName MyDocumentEncryption -CertStoreLocation 'Cert:\CurrentUser\My' -KeyUsage KeyEncipherment, DataEncipherment, KeyAgreement -Type DocumentEncryptionCert
    }
  }
  Process{
    foreach($InputFile in $Name)
    {
      $InputFile = (Get-ItemProperty $InputFile).Name

      $ext = (Get-ItemProperty -Path $InputFile).Extension
      if($ext -ne 'txt')
      {
        Write-Warning -Message ('{0} in not a "txt" file and may not be able to be unencrypted' -f $InputFile)
        $ans = Read-Host -Prompt 'Type "YES" to continue'
        if($ans -ne 'yes')
        {
          Write-Host -Object 'Exiting...' -ForegroundColor Cyan
          Break
        }
      }
      Write-Host -Object ('Encrypting {0}' -f $InputFile) -ForegroundColor Red
      $CqrFile = ($InputFile).Replace($ext,$SecureExt)
      Rename-Item -Path (Get-ItemProperty $InputFile).Name -NewName $CqrFile -Force

      $InputFile = (Get-ItemProperty -Path $CqrFile).FullName
      Get-Content -Path $InputFile | Protect-CmsMessage -To CN=MyDocumentEncryption -OutFile $InputFile
    }
  }
  End{}
}

function Unprotect-TextFile
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

  [CmdletBinding(SupportsShouldProcess,ConfirmImpact = 'High')]
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
    $ClearTextFile = ($InputFile).Replace('.cqr','.txt')
    Rename-Item -Path $InputFile -NewName $ClearTextFile
    $ClearText | Out-File -FilePath $ClearTextFile -Force
  }
  else
  {
    Return $ClearText
  }
}

function New-TestTextFiles
{
  <#
      .SYNOPSIS
      Creates a series of 1 to 25 (default 5) test files named TestTextFilet-0.txt to TestTextFile-4.txt.

      .EXAMPLE
      New-TestFiles
      In the current directory it creates 5 test files

      .EXAMPLE
      New-TestFiles -Amount 25
      In the current directory it creates 25 test files

      .INPUTS
      None

      .OUTPUTS
      Name          
      ----          
      TestTextFile-0.txt
      TestTextFile-1.txt
      TestTextFile-2.txt
      TestTextFile-3.txt
      TestTextFile-4.txt
  #>

  param(
    [Parameter(HelpMessage = 'Total amount of test files to create 1 - 20')]
    [ValidateScript({
          If($_ -le 20)
          {
            $true
          }
          Else
          {
            Throw 'Amount must be between 1 - 20'
          }
    })][int]$Amount = 5
    )

  $srv = Get-Service | Select-Object -First 10
  for($i = 0;$i -lt $Amount;$i++)
  {
    $srv |
    Out-File  -FilePath ('.\TestTextFile-{0}.txt' -f $i)
  }
  #('.\TestTextFile-{0}.cqr' -f (Get-Date -UFormat %j%M%S))
}

Export-ModuleMember -Function Protect-TextFile, Unprotect-TextFile, New-TestTextFiles
