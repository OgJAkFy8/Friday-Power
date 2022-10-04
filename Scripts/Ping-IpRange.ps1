# This function is part of the tool box we are making.
function Ping-IpRange
{
  <#
    .SYNOPSIS
    Tests a range of Ip addresses.

    .DESCRIPTION
    A simple function to test a range of Ip addresses and returns the results to the screen.

    .PARAMETER First3Octets
    First three octets of Ip range.

    .PARAMETER FirstAddress
    First address to test.

    .PARAMETER LastAddress
    Last address to test.

    .EXAMPLE
    Ping-IpRange -First3Octets 192.168.0 -FirstAddress 0 -LastAddress 10
    
    Pings from 1921.68.0.0 to 192.168.0.10

    Ping: 192.168.0.0 -- Responds:  False
    Ping: 192.168.0.1 -- Responds:  True
    Ping: 192.168.0.2 -- Responds:  False
    Ping: 192.168.0.3 -- Responds:  True
    Ping: 192.168.0.4 -- Responds:  False

    .OUTPUTS
    Output to console
  #>


  param(
    [Parameter(Mandatory,HelpMessage='First 3 octets: 192.168.11',Position = 0)]
    [String]$First3Octets,
    [Parameter(Mandatory,HelpMessage='Address to start from. 1-254',Position = 1)]
    [String]$FirstAddress,
    [Parameter(Mandatory,HelpMessage='Address to stop. 1-254',Position = 2)]
    [String]$LastAddress
  )

  $First3Octets = $First3Octets.Trim('. ')
  [int]$FirstAddress = $FirstAddress.Trim('. ')
  [int]$LastAddress  = $LastAddress.Trim('. ')

  for($LastOctet = $FirstAddress;$LastOctet -le $LastAddress;$LastOctet++)
  {
    $ip = "$First3Octets.$LastOctet"
    Write-Host -Object ("Ping: $ip -- Responds: $(Test-Connection -ComputerName $ip -Count 1 -Quiet)")
  }
}

New-Alias -Name 'pr' -Value Ping-IpRange -Description 'Pings Range of Ip Addresses'

