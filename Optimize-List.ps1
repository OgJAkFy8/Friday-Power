function Optimize-List
{
  <#
      .SYNOPSIS
      Removes the unwanted characters from a list.

      .DESCRIPTION
      Add a more complete description of what the function does.

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
      NEDIACA09'.Replace("`n",',')

      .OUTPUTS
      Optimized list as an array
  #>


  param(
    [Parameter(Mandatory = $true,HelpMessage = 'List', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [String[]]$List
  )
  $CommaString = $List.Replace("`n",',')
  $CleanArray = $CommaString.Split(',').Trim('_',',','.','\','/','-','@',' ').TrimStart('0')
  Return $CleanArray
}

