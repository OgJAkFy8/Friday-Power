* Assigning integers and strings to variables
* Using a **for loop**
* Using **Test-Connection** cmdlet
### Simple Example
```PowerShell
for($LastOctet = 0;$LastOctet -lt 10;$LastOctet++)
{
  $ip = "192.168.0.$LastOctet"
  Write-Host -Object "Ping: $ip -- Responds:  $(Test-Connection -ComputerName $ip -Count 1 -Quiet)"
}

```

### As an advanced function
* Mandatory Parameters
* For loop
* Test-Connection cmdlet

```PowerShell
function Ping-IpRange
{
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
    $ip = "$First3Octets.$LastOctet"
    Write-Host -Object ("Ping: $ip -- Responds: $(Test-Connection -ComputerName $ip -Count 1 -Quiet)")
  }
}

Ping-IpRange -First3Octets 192.168.0 -FirstAddress 0 -LastAddress 10
```
