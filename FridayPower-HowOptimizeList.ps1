# Start by assigning the list to a variable   
$computerNames = ('BLUSTRAA01
  ___BLUSTRAA02
  BLUSTRAA03
  ___BLUSTRAA04
  BLUSTRAA05
  ___BLUSTRAA06
  BLUSTRAA07
  ___BLUSTRAA08
  000BLUSTRAA09
  ___0000CHIDIACA01
  000CHIDIACA02
  CHIDIACA03
  000CHIDIACA04
  CHIDIACA05
  CHIDIACA06
  CHIDIACA07
  CHIDIACA08
CHIDIACA09')


# Replace the "newline" (`n) with a comma (,)
$List = $computerNames.Replace("`n",',')

# Convert to array
$ArrayList = $List.Split(',')

# Now you can clean it up.  Remove the '_',0 and ' '(space) from the front and Replace the CA and AA with a '-' (dash)
$ArrayList.TrimStart('_','0',' ').Replace('CA','-').Replace('AA','-')


# As a single line
$computerNames.Replace("`n",',').Split(',').TrimStart('_','0',' ').Replace('CA','-').Replace('AA','-')


# As a function
function Optimize-List
{
  <#
      .SYNOPSIS
      Simple function to clean up a list of items, by removing the unwanted characters
  #>

  param(
    [Parameter(Mandatory,HelpMessage = 'As an Array', ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [String[]]$List
  )
  $trimmings = ('_', ',', '.', '\', '/', '-', '@', ' ')
  $CommaString = $List.Replace("`n",',')
  $CleanArray = $CommaString.Split(',').Trim($trimmings).TrimStart('0')
  Return $CleanArray
}

# Test Again
Optimize-List -List $computerNames
