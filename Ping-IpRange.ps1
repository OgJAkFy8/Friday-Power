#Not really putting all together, but here are some things that you can do:
for($LastOctet = 0;$LastOctet -lt 10;$LastOctet++)
{
  $ip = "192.168.0.$LastOctet"
  Write-Host -Object "Ping: $ip -- Responds:  $(Test-Connection -ComputerName $ip -Count 1 -Quiet)"
}

#Or make it more reusable
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

Ping-IpRange -First3Octets 192.168.0 -FirstAddress 0 -LastAddress 10

