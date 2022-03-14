#requires -Version 2.0 -Modules DnsClient
[CmdletBinding(SupportsShouldProcess = $true,ConfirmImpact = 'Low',DefaultParameterSetName = 'IpAddressList')]

param
(
  [Parameter(Mandatory = $true,HelpMessage = 'Must be an Array of Ip Addresses', ValueFromPipeline = $true,
  ValueFromPipelineByPropertyName = $true,Position = 0,ParameterSetName = 'IpAddressList')]
  [Object]$IpAddressList,
  [Parameter(Mandatory = $true,ValueFromPipeline = $false,
  ValueFromPipelineByPropertyName = $true,HelpMessage = 'Hashtable with DnsNames and IpAddresses',ParameterSetName = 'DnsHashTable')]
  [Object]$DnsHashTable
)
#$IpAddressList
<#
    .SYNOPSIS
    Checks a list of Hostnames against Ip Addresses

    .DESCRIPTION
    Checks a list of Hostnames against Ip Addresses.  
    It it best to use this directly from the ISE, because you can change the data and run the code with ease.

    .EXAMPLE
    Make the changes to the hash table: $DnsHashTable
    CTRL+A (Select All)
    Press F8 to run the selection
    
    .NOTE
    Edit the "$resolveDNS" hashtable with your own data.

    Here is the template
    $DnsHashTable = @{
    buffalo = '192.168.0.59'
    'printer.blue' = '192.168.0.59'
    }
#>

<###################################################################
    #Edit this hashtable
    $DnsHashTable = @{
    buffalo = '192.168.0.59'
    pbworks = '208.96.18.237'
    }
###################################################################>

#Do not change below.  Any modifications will change the results.  
begin
{
function Compare-DnsNameToIp
{
  <#
      .SYNOPSIS
      Checks a list of Hostnames against Ip Addresses
  #>
  [CmdletBinding(SupportsShouldProcess = $true,ConfirmImpact = 'Low')]

  param
  (
    [Parameter(Mandatory = $true,HelpMessage = 'Must be a hashtable.  See Help for example', ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true,Position = 0)]
    [Object]$DnsHashTable
  )
  

  foreach($KeyName in $DnsHashTable.Keys)
  {
    Write-Host -Object ('{2}Expected: {2}{0} - {1}' -f $KeyName, $($DnsHashTable.$KeyName), "`n")
    try
    {
      # Test the Ip and return a hostname
      $resolveName = (Resolve-DnsName -Name $($DnsHashTable.$KeyName) -DnsOnly -NoHostsFile -ErrorAction Stop).NameHost
    }
    catch
    {
      $resolveName = 'Not Found'
    }
    if($resolveName -eq $KeyName)
    {
      Write-Host -Object ('{0} - {1}' -f $resolveName, $($DnsHashTable.$resolveName)) -ForegroundColor Green
    }
    else
    {
      Write-Host -Object ('{1} = {0}' -f $resolveName, $($DnsHashTable.$KeyName)) -ForegroundColor Yellow
      
      try
      {
        $resolveIp = (Resolve-DnsName -Name $KeyName -Type A -DnsOnly -NoHostsFile -ErrorAction Stop).NameHost
      
        $resolveIp.GetType().Name
      }
      catch
      {
        $resolveIp = 'Not Found'
      }
      Write-Host -Object ('{0} - {1}' -f $KeyName, $resolveIp) -ForegroundColor Red
    }
  }
}
function Request-DnsNameFromIp
{
  [CmdletBinding(SupportsShouldProcess = $true,ConfirmImpact = 'Low')]

  param
  (
    [Parameter(Mandatory = $true,HelpMessage = 'Must be an Array of Ip Addresses', ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true,Position = 0)]
    [Object]$IpAddressList
  )
  BEGIN{
    $MsgNotFound = 'Not Found'
  }
  PROCESS{  foreach($IpAddress in $IpAddressList)
    {
      Write-Host -Object ('{1}Testing: {1}{0} - ' -f $IpAddress, "`n") -NoNewline
      try
      {
        # Test the Ip and return a hostname
        $resolveName = (Resolve-DnsName -Name $($IpAddress) -DnsOnly -NoHostsFile -ErrorAction Stop).NameHost
      }
      catch
      {
        $resolveName = $MsgNotFound
      }
      if($resolveName -ne $MsgNotFound)
      {
        Write-Host -Object ('{0}' -f $resolveName) -ForegroundColor Green
      }
      else
      {
        Write-Host -Object ('{0}' -f $resolveName) -ForegroundColor Red
      }
    }
  }
  END{}
}
}
process{
if($IpAddressList)
{
  Request-DnsNameFromIp -IpAddressList $IpAddressList
}
if($DnsHashTable)
{
  Compare-DnsNameToIp -DnsHashTable $DnsHashTable
}
}

END{}