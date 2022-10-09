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

function Show-Subnet 
{
  <#
      .SYNOPSIS
      Provides a quick reference for subnet information.

      .DESCRIPTION
      Returns the CIDR, Subnet, Total Address and Class based on parameters selected.

      .PARAMETER Filter
      How you want to filter the output either CIDR,Subnet or Class .

      .PARAMETER Value
      Describe parameter -Value.

      .EXAMPLE
      Show-Subnet
      Default returns all of the information
      
      .EXAMPLE
      Show-Subnet -Filter CIDR -Value 20
      
      Class B
      CIDR  Subnet          Total Addresses 
      /16   255.255.0.0     65,534          
      /17   255.255.128.0   32,766          
      /18   255.255.192.0   16,382          
      /19   255.255.224.0   8,190           
      *** /20   255.255.240.0   4,094 ***          
      /21   255.255.248.0   2,046           
      /22   255.255.252.0   1,022           
      /23   255.255.254.0   510  
      

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Show-Subnet
  #>

  [CmdletBinding(DefaultParametersetName = 'None')]
  param(    
    [Parameter(ParametersetName = 'one',HelpMessage = 'Mandatory if using Value',Mandatory = $true,Position = 0)]
    [ValidateSet('Class','CIDR','Subnet')]
    [String]$Filter,
    [Parameter(ParametersetName = 'one',HelpMessage = 'Mandatory if using Filter',Mandatory = $true,Position = 1)]
    [String]$Value
  )

  function Select-ClassList
  {
    <#
        .SYNOPSIS
        Help filter for Switch
    #>
    param
    (
      [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Data to filter')]
      [Object]$InputObject,
      [AllowNull()]
      [Parameter(Mandatory,HelpMessage = 'From main body Value')]
      [String]$Value
    )
    process
    {
      if ($InputObject.Class -eq $Value)
      {
        $InputObject
      }
    }
  }

  $Column23 = '{0,-16}'
  $Column1 = '/{0,-5}'
  $sc = $null
  $OutputHighlightColor = @{
    BackgroundColor = 'DarkGreen'
  }
  
  $SubnetJson = '
    [
    {
    "Class":  "A",
    "CIDR":  "8",
    "Subnet":  "255.0.0.0",
    "TotalAddresses":  "16,777,214"
    },
    {
    "Class":  "A",
    "CIDR":  "9",
    "Subnet":  "255.128.0.0",
    "TotalAddresses":  "8,388,606"
    },
    {
    "Class":  "A",
    "CIDR":  "10",
    "Subnet":  "255.192.0.0",
    "TotalAddresses":  "4,194,302"
    },
    {
    "Class":  "A",
    "CIDR":  "11",
    "Subnet":  "255.224.0.0",
    "TotalAddresses":  "2,097,150"
    },
    {
    "Class":  "A",
    "CIDR":  "12",
    "Subnet":  "255.240.0.0",
    "TotalAddresses":  "1,048,574"
    },
    {
    "Class":  "A",
    "CIDR":  "13",
    "Subnet":  "255.248.0.0",
    "TotalAddresses":  "524,286"
    },
    {
    "Class":  "A",
    "CIDR":  "14",
    "Subnet":  "255.252.0.0",
    "TotalAddresses":  "262,142"
    },
    {
    "Class":  "A",
    "CIDR":  "15",
    "Subnet":  "255.254.0.0",
    "TotalAddresses":  "131,070"
    },
    {
    "Class":  "B",
    "CIDR":  "16",
    "Subnet":  "255.255.0.0",
    "TotalAddresses":  "65,534"
    },
    {
    "Class":  "B",
    "CIDR":  "17",
    "Subnet":  "255.255.128.0",
    "TotalAddresses":  "32,766"
    },
    {
    "Class":  "B",
    "CIDR":  "18",
    "Subnet":  "255.255.192.0",
    "TotalAddresses":  "16,382"
    },
    {
    "Class":  "B",
    "CIDR":  "19",
    "Subnet":  "255.255.224.0",
    "TotalAddresses":  "8,190"
    },
    {
    "Class":  "B",
    "CIDR":  "20",
    "Subnet":  "255.255.240.0",
    "TotalAddresses":  "4,094"
    },
    {
    "Class":  "B",
    "CIDR":  "21",
    "Subnet":  "255.255.248.0",
    "TotalAddresses":  "2,046"
    },
    {
    "Class":  "B",
    "CIDR":  "22",
    "Subnet":  "255.255.252.0",
    "TotalAddresses":  "1,022"
    },
    {
    "Class":  "B",
    "CIDR":  "23",
    "Subnet":  "255.255.254.0",
    "TotalAddresses":  "510"
    },
    {
    "Class":  "C",
    "CIDR":  "24",
    "Subnet":  "255.255.255.0",
    "TotalAddresses":  "254"
    },
    {
    "Class":  "C",
    "CIDR":  "25",
    "Subnet":  "255.255.255.128",
    "TotalAddresses":  "126"
    },
    {
    "Class":  "C",
    "CIDR":  "26",
    "Subnet":  "255.255.255.192",
    "TotalAddresses":  "62"
    },
    {
    "Class":  "C",
    "CIDR":  "27",
    "Subnet":  "255.255.255.224",
    "TotalAddresses":  "30"
    },
    {
    "Class":  "C",
    "CIDR":  "28",
    "Subnet":  "255.255.255.240",
    "TotalAddresses":  "14"
    },
    {
    "Class":  "C",
    "CIDR":  "29",
    "Subnet":  "255.255.255.248",
    "TotalAddresses":  "6"
    },
    {
    "Class":  "C",
    "CIDR":  "30",
    "Subnet":  "255.255.255.252",
    "TotalAddresses":  "2"
    },
    {
    "Class":  "C",
    "CIDR":  "31",
    "Subnet":  "255.255.255.254",
    "TotalAddresses":  "0"
    },
    {
    "Class":  "C",
    "CIDR":  "32",
    "Subnet":  "255.255.255.255",
    "TotalAddresses":  "0"
    }
    ]
  '
  
  $subnetList = $SubnetJson | ConvertFrom-Json
  
  Switch ($Filter) {
    Class
    {
      $list = $subnetList | Where-Object -FilterScript {
        $_.Class -eq $Value
      }
    }
    CIDR
    {
      $list = $subnetList | Select-ClassList -Value ($subnetList | Where-Object -FilterScript {
          $_.cidr -eq $Value
      }).class
    }
    Subnet
    {
      $list = $subnetList | Select-ClassList -Value ($subnetList | Where-Object -FilterScript {
          $_.Subnet -eq $Value
      }).class
    }
    Default 
    {
      $list = $subnetList
    }
  }
  
  foreach($SubnetRcd in $list)
  {
    $cc = $SubnetRcd.class 
    if($sc -ne $cc)
    {
      Write-Host -Object "`n"
      Write-Host -Object ('{0,16} {1}' -f 'Class', $cc) -ForegroundColor Green
      Write-Host -Object ('{0,-6}{1,-16}{2,-16}' -f 'CIDR', 'Subnet', 'Total Addresses' ) -ForegroundColor White
      $sc = $cc
    }
    if(($SubnetRcd.$Filter -eq $Value) -and ($Filter -ne 'Class'))
    {
      Write-Host -Object ($Column1 -f $SubnetRcd.CIDR) -NoNewline @OutputHighlightColor
      Write-Host -Object ($Column23 -f $SubnetRcd.Subnet) -NoNewline @OutputHighlightColor
      Write-Host -Object ($Column23 -f $SubnetRcd.TotalAddresses) @OutputHighlightColor
    }
    Else
    {
      Write-Host -Object ($Column1 -f $SubnetRcd.CIDR) -NoNewline 
      Write-Host -Object ($Column23 -f $SubnetRcd.Subnet) -NoNewline 
      Write-Host -Object ($Column23 -f $SubnetRcd.TotalAddresses)
    }
  }
}



# At the very bottom of the module script type the following and save it.  This should always be the last line in your module.
Export-ModuleMember -Function Convert-ListToArray, Format-SendToEmailList, Get-DayFromDate-Day, Get-UserPasswordExpirationDate, Show-Subnet  -Verbose

#New-Alias -Name 'pr' -Value Ping-IpRange -Description 'Pings Range of Ip Addresses'
