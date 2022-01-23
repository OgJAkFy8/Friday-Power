#requires -Version 3.0
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

