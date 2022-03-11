$resolveDNS = @{
  buffalo = '192.168.0.59'
  printer = '192.168.0.59'
  #random = '192.168.0.3'
}

foreach($KeyName in $resolveDNS.Keys)
{
  Write-Host -Object ('{2}Expected: {2}{0} - {1}' -f $KeyName, $($resolveDNS.$KeyName), "`n")
  try
  {
    # Test the Ip and return a hostname
    $resolveName = (Resolve-DnsName -Name $($resolveDNS.$KeyName) -DnsOnly -NoHostsFile -Server 192.168.0.3 -ErrorAction Stop).NameHost
  }
  catch
  {
    $resolveName = 'Not Found'
  }
  if($resolveName -eq $KeyName)
  {
    Write-Host -Object ('{0} - {1}' -f $resolveName, $($resolveDNS.$resolveName)) -ForegroundColor Green
  }else
  {
   Write-Host -Object ('{1} = {0}' -f $resolveName, $($resolveDNS.$KeyName)) -ForegroundColor Yellow
  
    try
  {
    $resolveIp = (Resolve-DnsName -Name $KeyName -Type A -DnsOnly -NoHostsFile -Server 192.168.0.3 -ErrorAction Stop).NameHost
  }
  catch
  {
    $resolveIp = 'Not Found'
  }
  Write-Host -Object ('{0} - {1}' -f $KeyName,$resolveIp) -ForegroundColor Red
  }
}
