
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
CHIDIACA09'.Replace("`n",',')

#Fix a list of text 
$ComputerList = $computerNames.Split(',').TrimStart('_','0',' ').Replace('CA','-').Replace('AA','-')


#Make reusable
function Optimize-List
{
  param(
    [Parameter(Mandatory,HelpMessage='As an Array', ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [String[]]$List
  )
  $CommaString = $List.Replace("`n",',')
  $CleanArray = $CommaString.Split(',').Trim('_',',','.','\','/','-','@',' ').TrimStart('0')
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
  Write-Host -Object "Ping: $($FQDNlist.$key)" -ForegroundColor Yellow
}
