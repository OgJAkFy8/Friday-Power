function Get-UserPasswordExpirationDate
{
  <# 
    .SYNOPSIS
    User Password Expiration Date
 
    .DESCRIPTION
    Returns the expiration date of an AD user's password.

    .PARAMETER AdUser
    At this time a single AD username.

    .EXAMPLE
    Get-UserPasswordExpirationDate -AdUser myusername_ad
    
    Returns the password expiration date of myusername_ad

    .NOTES
    .LINK

    .INPUTS
    Single String.

    .OUTPUTS
    String
  #>

  [CmdletBinding(SupportsShouldProcess = $true,ConfirmImpact = 'Low')]

  param
  (
    [Parameter(Mandatory = $true,HelpMessage = 'Must be an AD username', ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true,Position = 0)]
    [String]$AdUser
  )

  $userInfo = Get-ADUser $AdUser -Properties *
  if($($userInfo.PasswordNeverExpires) -eq $false)
  {
    $userInfo |
    Select-Object -Property DisplayName, msDS-UserPasswordExpiryTimeComputed |
    Select-Object -Property 'Displayname', @{
      Name       = 'ExpiryDate'
      Expression = {
        [datetime]::FromFileTime($_.'msDS-UserPasswordExpiryTimeComputed')
      }
    }
  }
  Else
  {
    $userInfo | Select-Object -Property DisplayName, PasswordNeverExpires
  }
}

<# Doubleliner to get all users who have passwordneverexpires set to false and display the dates their passwords expire.
    Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties DisplayName, msDS-UserPasswordExpiryTimeComputed |
    Select-Object -Property 'Displayname', @{Name = 'ExpiryDate'; Expression = {[datetime]::FromFileTime($_.'msDS-UserPasswordExpiryTimeComputed')}}
#>

