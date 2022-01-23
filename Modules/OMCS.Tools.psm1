Clear-Host
Write-Host 'Loading my very own module ' -NoNewline
for($i=0;$i -lt 5;$i++){Start-Sleep -Seconds 1; Write-Host '. ' -NoNewline -ForegroundColor Green}

function Ping-IpRange
{
  <#
    .SYNOPSIS
    Tests a range of Ip addresses.

    .DESCRIPTION
    A simple function to test a range of Ip addresses and returns the results to the screen.

    .PARAMETER First3Octets
    First three octets of Ip range.

    .PARAMETER FirstAddress
    First address to test.

    .PARAMETER LastAddress
    Last address to test.

    .EXAMPLE
    Ping-IpRange -First3Octets 192.168.0 -FirstAddress 0 -LastAddress 10
    
    Pings from 1921.68.0.0 to 192.168.0.10

    Ping: 192.168.0.0 -- Responds:  False
    Ping: 192.168.0.1 -- Responds:  True
    Ping: 192.168.0.2 -- Responds:  False
    Ping: 192.168.0.3 -- Responds:  True
    Ping: 192.168.0.4 -- Responds:  False

    .OUTPUTS
    Output to console
  #>


  param(
    [Parameter(Mandatory,HelpMessage='First 3 octets: 192.168.11',Position = 0)]
    [String]$First3Octets,
    [Parameter(Mandatory,HelpMessage='Address to start from. 1-254',Position = 1)]
    [int]$FirstAddress,
    [Parameter(Mandatory,HelpMessage='Address to stop. 1-254',Position = 2)]
    [int]$LastAddress
  )
  for($LastOctet = $FirstAddress;$LastOctet -lt $LastAddress;$LastOctet++)
  {
    $ip = ('{0}.{1}' -f $First3Octets, $LastOctet)
    Write-Host -Object (('Ping: {0} -- Responds: {1}' -f $ip, (Test-Connection -ComputerName $ip -Count 1 -Quiet)))
  }
}

function Optimize-List
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

function Pop-EmailAddress
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


function Get-Day 
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
  $OutputFormat = '{0,-4} : {2,-11} : {1}'
  
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


















# At the very bottom of the module script type the following and save it.  This should always be the last line in your module.
Export-ModuleMember -Function Ping-IpRange, Optimize-List, Pop-EmailAddress, Get-Day

