function Start-Dots
{
  <#
      .SYNOPSIS
      Shows start dots
  #>
  if (-not (Test-Path -Path variable:global:psISE))
  {
    Clear-Host
    $i = 0 
    do 
    { 
      Start-Sleep -Milliseconds 100
      Write-Host -Object '.  ' -NoNewline -ForegroundColor ('Green', 'Red', 'Cyan', 'Yellow' | Get-Random)
      $i++
    }
    until (($i -gt 20) -or [System.Console]::KeyAvailable)  
    Write-Host -Object "`n"
  }
}

Start-Dots

function Convert-ListToArray
{
  <#
      .SYNOPSIS
      Removes the unwanted characters from a list.

      .PARAMETER List
      The list of data to be cleaned up

      .EXAMPLE
      Optimize-List -List Value
      Removes the unwanted data as discribed in the code

      .NOTES
      Simple function for our tool box

      .INPUTS
      List of something that needs to be cleaned up
      $computerNames = 'WCSTRAA01
      ___WCSTRAA02
      WCSTRAA03
      ___WCSTRAA04
      WCSTRAA05
      ___WCSTRAA06
      WCSTRAA07
      ___WCSTRAA08
      000WCSTRAA09
      ___0000NEDIACA01
      000NEDIACA02
      NEDIACA03
      000NEDIACA04
      NEDIACA09'

      .OUTPUTS
      Optimized list as an array
  #>

  param(
    [Parameter(Mandatory = $true,HelpMessage = 'List', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [String[]]$List
  )
  $trimmings = ('_', ',', '.', '\', '/', '-', '@', ' ')
  $CommaString = $List.Replace("`n",',')

  $CleanArray = $CommaString.Split(',').Trim($trimmings).TrimStart('0')
  Return $CleanArray
}

function Format-SendToEmailList
{
  <#
      .SYNOPSIS
      Simple extraction function for the email addresses out of a list from outlook.  Extracting the email addresses from a list of contacts

      .EXAMPLE
      'Desktop <a@mail>;Documents <b@mail>;Downloads <c@mail >; Favorites < d@mail >' | Pop-EmailAddress

      .EXAMPLE
      $Contacts = 'Desktop <a@mail>;Documents <b@mail>;Downloads <c@mail >; Favorites < d@mail >'
      Extract-Emails -Contacts $Contacts

      .NOTES
      Last week I needed to get everyone's email address as a semicolon separated list.

      I didn't want to waste time stripping off the names, spaces, special characters. So I expanded the email group in the Outlook "To" line.

      That gave me a group of contacts that looked like this:
      Desktop <a@mail>;Documents <b@mail>;Downloads <c@mail>;Favorites <d@mail>;Links <e@mail>;Music <f@mail>;OneDrive <g@mail>;Pictures <h@mail>;Saved Games<i@mail>;Searches
      <j@mail>;testfile<k@mail>

      .LINK
      https://github.com/OgJAkFy8/Friday-Power/blob/main/Pop-EmailAddress.ps1

      .INPUTS
      String

      .OUTPUTS
      Array
  #>

  [CmdletBinding(SupportsShouldProcess)]
  [Alias('Extract-Emails')]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline, HelpMessage = 'List of contacts in Outlook Address bar')]
    [String[]]$Contacts
  )
  $emailaddresses = @()
  # Split the list into an array, so we can loop through it
  $arrayContacts = $Contacts.Split(';')

  # Then we pass it by pipeline to a ForEach-Object statement 
  ForEach($Contact in $arrayContacts) 
  {
    $emailaddresses += $Contact.split('<')[1].trim(' ','>')
  }

  # Join it back for use in the Outlook "TO:" line
  $results = $emailaddresses -join ';'

  Return $results
}

function Get-DayFromDate 
{
  <#
     .SYNOPSIS
    Returns the day of the week for the next X number of years for a specific date

    .DESCRIPTION
    Want to know what day your anniversary, birthday or holiday is on?  Use the Get-Day function and choose how many years to look ahead.  

    .PARAMETER Date
    The date as 6/19/1865

    .PARAMETER NumYears
    How many years to look ahead.  The default is 5.

    .EXAMPLE
    Get-Day 2/14/2022 -NumYears 3
    Finds what day Valentine's Day is on for the next three years

    .NOTES
    None at this time
  #>


  param
  (
    [Parameter(Mandatory,HelpMessage = 'Enter date. Ex: 7/4/1776')]
    [String]$Date,
    [Int]$NumYears = 5
  )

  $Sepr = '-'
  $OutputFormat = '{0,-4} | {2,-11} | {1}'
  
  [Int]$Year = Get-Date -Date $Date -Format yyyy
  $Day = Get-Date -Date $Date -Format dd
  $Month = Get-Date -Date $Date -Format MM

  Write-Output -InputObject ($OutputFormat -f 'Year', 'Julian', 'Day of Week')
  Write-Output -InputObject ($OutputFormat -f $($Sepr*4), $($Sepr*6), $($Sepr*11))
  for($i = 0;$i -lt $NumYears;$i++)
  {
    $Julian = Get-Date -Date $Date -UFormat %j
    $dayofweek = (Get-Date -Date $Date).dayofweek
  
    Write-Output -InputObject ($OutputFormat -f $Year, $Julian, $dayofweek)
    
    $Year = $Year + 1
    $Date = Get-Date -Date (('{0} / {1} / {2}' -f $Month, $Day, $Year))
  }
}

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




# At the very bottom of the module script type the following and save it.  This should always be the last line in your module.
Export-ModuleMember -Alias * -Function Convert-ListToArray, Format-SendToEmailList, Get-DayFromDate-Day, Get-UserPasswordExpirationDate  -Verbose 

