# Create the list
$computerNames = 'BLUSTRAA01
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
CHIDIACA09'

# Convert it to an String
$ComputerList = $computerNames.Replace("`n",',')

# Split the results, then trim the "spaces,0's and '_'" off the front. Replace the "CA" with a "-" then do the same with "AA".   
$ComputerList.Split(',').TrimStart('_','0',' ').Replace('CA','-').Replace('AA','-')


#Make reusable
function Optimize-List
{
  param(
    [Parameter(Mandatory,HelpMessage = 'As an Array', ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [String[]]$List
  )
  $trimmings = ('_',',','.','\','/','-','@',' ')
  $CommaString = $List.Replace("`n",',')
  $CleanArray = $CommaString.Split(',').Trim($trimmings).TrimStart('0')
  Return $CleanArray
}

Optimize-List -List $computerNames


#Convert it to a hashtable with FQDN's and use it to Ping those names (uses write-host instead of "Ping" for the example)
$FQDNlist = @{} #Hashtable
$ComputerList | ForEach-Object -Process {
  $FQDNlist.$_ = $_.ToLower()+'.domain.com'
}
foreach($key in $FQDNlist.Keys)
{
  Write-Host -Object "Ping: $($FQDNlist.$key) - " -ForegroundColor Cyan -NoNewline
  try
  {
    $result = Test-Connection -ComputerName $($FQDNlist.$key) -Count 1 -Quiet -ErrorAction Stop
    $color = 'Green'
  }
  catch
  {
    $result = 'False'
    $color = 'Red'
  }
  Write-Host -Object "$result" -ForegroundColor $color
}
