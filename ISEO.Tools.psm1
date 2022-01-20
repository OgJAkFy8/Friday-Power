Clear-Host
Write-Host "Loading module - ISEO.Tools " -NoNewline
for($i=0;$i -lt 5;$i++){Sleep 1; Write-Host '. ' -NoNewline -ForegroundColor Green}

function Ping-IpRange
{
  param(
    [Parameter(Mandatory,Position = 0)]
    $First3Octets,
    [Parameter(Mandatory,Position = 1)]
    $FirstAddress,
    [Parameter(Mandatory,Position = 2)]
    $LastAddress
  )
  for($LastOctet = $FirstAddress;$LastOctet -lt $LastAddress;$LastOctet++)
  {
    $ip = "$First3Octets.$LastOctet"
    Write-Host -Object "Ping: $ip -- Responds:  $(Test-Connection -ComputerName $ip -Count 1 -Quiet)"
  }
}



# At the very bottom of the module script type the following and save it.  This should always be the last line in your module.
Export-ModuleMember Ping-IpRange

