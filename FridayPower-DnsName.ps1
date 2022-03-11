#requires -Version 2.0 -Modules DnsClient
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

###################################################################
#Edit this hashtable
$DnsHashTable = @{
  buffalo      = '192.168.0.59'
  'printer.blue' = '192.168.0.59'
}
###################################################################

#Do not change below.  Any modifications will change the results.  
function Test-DnsSettings
{
  <#
      .SYNOPSIS
      Checks a list of Hostnames against Ip Addresses
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true, Position = 0)]
    [Object]$DnsHashTable
  )
  
  foreach($KeyName in $DnsHashTable.Keys)
  {
    Write-Host -Object ('{2}Expected: {2}{0} - {1}' -f $KeyName, $($DnsHashTable.$KeyName), "`n")
    try
    {
      # Test the Ip and return a hostname
      $resolveName = (Resolve-DnsName -Name $($DnsHashTable.$KeyName) -DnsOnly -NoHostsFile -Server 192.168.0.3 -ErrorAction Stop).NameHost
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
        $resolveIp = (Resolve-DnsName -Name $KeyName -Type A -DnsOnly -NoHostsFile -Server 192.168.0.3 -ErrorAction Stop).NameHost
      
        $resolveIp
      }
      catch
      {
        $resolveIp = 'Not Found'
      }
      Write-Host -Object ('{0} - {1}' -f $KeyName, $resolveIp) -ForegroundColor Red
    }
  }
}

Test-DnsSettings -DnsHashTable $DnsHashTable

