#requires -Version 3.0
function Get-Friday13th 
{
  <#
      .SYNOPSIS
      the months that have a Friday the 13th by year for the next X number of years starting with the one specified

      .DESCRIPTION
      Returns the months that have a Friday the 13th by year for the next X number of years (Default is 5) specified

      .PARAMETER StartingYear
      The year as in 1865

      .PARAMETER NumYears
      How many years to look ahead.  The default is 5.

      .EXAMPLE
      Get-Friday13th  2022 -NumYears 3
      Finds what months have a Friday the thirteenth for the next three years

      .NOTES
      None at this time
  #>
  [CmdletBinding(PositionalBinding = $false,ConfirmImpact = 'Medium')]
  param
  (
    [Parameter(Mandatory,HelpMessage = 'Enter year. Ex: 1984')]
    [Int]$StartingYear,
    [Int]$NumYears = 5,
    [Switch]$Friday13thCountByMonth,
    [Switch]$OutJSON
  )
  $BadLuckMonths = [Ordered]@{
    January   = 0
    February  = 0
    March     = 0
    April     = 0
    May       = 0
    June      = 0
    July      = 0
    August    = 0
    September = 0
    October   = 0
    November  = 0
    December  = 0
  }

  $AllYears = [Ordered]@{}
  [Int]$EndingYear = $StartingYear + $NumYears
  
  # Process
  for($Year = $StartingYear;$Year -le $EndingYear;$Year++)
  {   
    $OneYear = @{}
    for($i = 1;$i -le 12;$i++)
    {
      $Thirteenth = Get-Date -Date ('{0}/13/{1}' -f $i, $Year)
      $dayofweek = $Thirteenth.dayofweek
      $Julian = $Thirteenth.DayOfYear
      $Month = Get-Date -Date $Thirteenth -Format MMMM
      if($dayofweek -eq 'Friday')
      {
        $BadLuckMonths[$Month] = [int]$BadLuckMonths[$Month] + 1
        $OneYear.Add($Month,$Julian)
      }
    }
    $AllYears.Add($Year,$OneYear)
  }

  # Output
  
  if(-Not ($PSBoundParameters['OutJSON']) -and (-not $Friday13thCountByMonth))
  {
    $Sepr = '-'
    $OutputFormat = '{0,-9} : {2,-6} : {1}'
    Write-Output -InputObject ('Dates of Friday the 13th from {0} through {1}' -f $StartingYear, $EndingYear)
    Write-Output -InputObject ($OutputFormat -f 'Month', 'Julian Day', 'Year')
    Write-Output -InputObject ($OutputFormat -f $($Sepr*9), $($Sepr*6), $($Sepr*4))
    foreach($keyYear in $AllYears.Keys)
    {
      foreach($keyMonth in $AllYears.$keyYear.Keys)
      {
        Write-Output -InputObject ($OutputFormat -f $keyMonth, $($AllYears.$keyYear.$keyMonth), $keyYear )
      }
    }
  }
  else
  {
    Write-Host -Object 'Months by year'
    [pscustomobject]$AllYears | ConvertTo-Json
  }

  if($Friday13thCountByMonth ) 
  {
    Write-Verbose -Message 'Count of months with Friday the Thirteens by year'
    $BadLuckMonths
  }

}
