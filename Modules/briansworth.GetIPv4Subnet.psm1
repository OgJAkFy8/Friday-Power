Function ConvertIPv4ToInt 
{
  [CmdletBinding()]
  Param(
    [String]$IPv4Address
  )
  Try
  {
    $IPAddress = [IPAddress]::Parse($IPv4Address)

    $bytes = $IPAddress.GetAddressBytes()
    [Array]::Reverse($bytes)

    [System.BitConverter]::ToUInt32($bytes,0)
  }
  Catch
  {
    Write-Error -Exception $_.Exception `
    -Category $_.CategoryInfo.Category
  }
}

Function ConvertIntToIPv4 
{
  [CmdletBinding()]
  Param(
    [uint32]$Integer
  )
  Try
  {
    $bytes = [System.BitConverter]::GetBytes($Integer)
    [Array]::Reverse($bytes)
    ([IPAddress]($bytes)).ToString()
  }
  Catch
  {
    Write-Error -Exception $_.Exception `
    -Category $_.CategoryInfo.Category
  }
}

Function Convert-CIDRToNetMask 
{
  <#
      .SYNOPSIS
      Converts a CIDR to a netmask

      .EXAMPLE
      Convert-CIDRToNetMask -PrefixLength 26
    
      Returns: 255.255.255.192/26

      .NOTES
      To convert back use "Convert-NetMaskToCIDR" 
  #>


  [CmdletBinding()]
  [Alias('ToMask')]
  Param(
    [ValidateRange(0,32)]
    [int16]$PrefixLength = 0
  )
  $bitString = ('1' * $PrefixLength).PadRight(32,'0')

  $strBuilder = New-Object -TypeName Text.StringBuilder

  for($i = 0;$i -lt 32;$i += 8)
  {
    $8bitString = $bitString.Substring($i,8)
    $null = $strBuilder.Append(('{0}.' -f [Convert]::ToInt32($8bitString,2)))
  }

  $strBuilder.ToString().TrimEnd('.')
}

Function Convert-NetMaskToCIDR 
{
  <#
      .SYNOPSIS
      Converts a netmask to a CIDR

      .EXAMPLE
      Convert-NetMaskToCIDR -SubnetMask 255.255.255.192
    
      Returns: 26

      .NOTES
      To convert back use "Convert-CIDRToNetMask" 
  #>


  [CmdletBinding()]
  [Alias('ToCIDR')]
  Param(
    [String]$SubnetMask = '255.255.255.0'
  )
  $byteRegex = '^(0|128|192|224|240|248|252|254|255)$'
  $invalidMaskMsg = ('Invalid SubnetMask specified [{0}]' -f $SubnetMask)
  Try
  {
    $netMaskIP = [IPAddress]$SubnetMask
    $addressBytes = $netMaskIP.GetAddressBytes()

    $strBuilder = New-Object -TypeName Text.StringBuilder

    $lastByte = 255
    foreach($byte in $addressBytes)
    {
      # Validate byte matches net mask value
      if($byte -notmatch $byteRegex)
      {
        Write-Error -Message $invalidMaskMsg `
        -Category InvalidArgument `
        -ErrorAction Stop
      }
      elseif($lastByte -ne 255 -and $byte -gt 0)
      {
        Write-Error -Message $invalidMaskMsg `
        -Category InvalidArgument `
        -ErrorAction Stop
      }

      $null = $strBuilder.Append([Convert]::ToString($byte,2))
      $lastByte = $byte
    }

    ($strBuilder.ToString().TrimEnd('0')).Length
  }
  Catch
  {
    Write-Error -Exception $_.Exception `
    -Category $_.CategoryInfo.Category
  }
}

Function Convert-IPv4AddressToBinaryString 
{
  <#
      .SYNOPSIS
      Converts an IP v4 Address to Binary String 

  #>


  Param(
    [IPAddress]$IPAddress = '0.0.0.0'
  )
  $addressBytes = $IPAddress.GetAddressBytes()

  $strBuilder = New-Object -TypeName Text.StringBuilder
  foreach($byte in $addressBytes)
  {
    $8bitString = [Convert]::ToString($byte,2).PadRight(8,'0')
    $null = $strBuilder.Append($8bitString)
  }
  Write-Output -InputObject $strBuilder.ToString()
}

Function Add-IntToIPv4Address 
{
  <#
      .SYNOPSIS
      Add an integer to an IP Address and get the new IP Address.

      .DESCRIPTION
      Add an integer to an IP Address and get the new IP Address.

      .PARAMETER IPv4Address
      The IP Address to add an integer to.

      .PARAMETER Integer
      An integer to add to the IP Address. Can be a positive or negative number.

      .EXAMPLE
      Add-IntToIPv4Address -IPv4Address 10.10.0.252 -Integer 10

      10.10.1.6

      Description
      -----------
      This command will add 10 to the IP Address 10.10.0.1 and return the new IP Address.

      .EXAMPLE
      Add-IntToIPv4Address -IPv4Address 192.168.1.28 -Integer -100

      192.168.0.184

      Description
      -----------
      This command will subtract 100 from the IP Address 192.168.1.28 and return the new IP Address.
  #>
  Param(
    [String]$IPv4Address,

    [int64]$Integer
  )
  Try
  {
    $ipInt = ConvertIPv4ToInt -IPv4Address $IPv4Address `
    -ErrorAction Stop
    $ipInt += $Integer

    ConvertIntToIPv4 -Integer $ipInt
  }
  Catch
  {
    Write-Error -Exception $_.Exception `
    -Category $_.CategoryInfo.Category
  }
}

function Get-CidrFromHostCount
{
  <#
      .SYNOPSIS
      Returns the CIDR number for a host count that will support the number of hosts you entered.
  #>
  [OutputType([Int])]
  param(
    [Parameter(Mandatory,ValueFromPipeline,HelpMessage = 'Integer between 1 - 4294967293')]
    [ValidateScript({
          $_ -gt 0
    })]
    [long]$HostCount
  )
  Begin{}
  Process{
    #Calculate available host addresses 
    $i = $MaxHosts = 0
    do
    {
      $i++
      $MaxHosts = ([math]::Pow(2,$i) - 2)
      $Prefix = 32 - $i 
    }
    until ($MaxHosts -ge $HostCount)
  }
  End{
    $PrefixLength = [PSCustomObject]@{
      PrefixLength = $Prefix
    }
    $PrefixLength
  }
}

Function Get-IPv4Subnet 
{
  <#
      .SYNOPSIS
      Get information about an IPv4 subnet based on an IP Address and a subnet mask or prefix length

      .DESCRIPTION
      Get information about an IPv4 subnet based on an IP Address and a subnet mask or prefix length

      .PARAMETER IPAddress
      The IP Address to use for determining subnet information. 

      .PARAMETER PrefixLength
      The prefix length of the subnet.

      .PARAMETER SubnetMask
      The subnet mask of the subnet.

      .EXAMPLE
      Get-IPv4Subnet -IPAddress 192.168.34.76 -SubnetMask 255.255.128.0

      CidrID       : 192.168.0.0/17
      NetworkID    : 192.168.0.0
      SubnetMask   : 255.255.128.0
      PrefixLength : 17
      HostCount    : 32766
      FirstHostIP  : 192.168.0.1
      LastHostIP   : 192.168.127.254
      Broadcast    : 192.168.127.255

      Description
      -----------
      This command will get the subnet information about the IPAddress 192.168.34.76, with the subnet mask of 255.255.128.0

      .EXAMPLE
      Get-IPv4Subnet -IPAddress 10.3.40.54 -PrefixLength 25

      CidrID       : 10.3.40.0/25
      NetworkID    : 10.3.40.0
      SubnetMask   : 255.255.255.128
      PrefixLength : 25
      HostCount    : 126
      FirstHostIP  : 10.3.40.1
      LastHostIP   : 10.3.40.126
      Broadcast    : 10.3.40.127

      Description
      -----------
      This command will get the subnet information about the IPAddress 10.3.40.54, with the subnet prefix length of 25.
      Prefix length specifies the number of bits in the IP address that are to be used as the subnet mask.

  #>
  [CmdletBinding(DefaultParameterSetName = 'PrefixLength')]
  Param(
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
        ValueFromRemainingArguments = $false,
        HelpMessage = 'IP Address in the form of XXX.XXX.XXX.XXX',
    Position = 0)]
    [IPAddress]$IPAddress,

    [Parameter(Position = 1,ParameterSetName = 'PrefixLength',ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true)]
    [Int16]$PrefixLength = 24,

    [Parameter(Mandatory = $true,Position = 1,ParameterSetName = 'SubnetMask')]
    [IPAddress]$SubnetMask,
    
    [Parameter(Mandatory = $true,Position = 1,ParameterSetName = 'Hosts',
        HelpMessage = 'Number of hosts in need of IP Addresses')]
    [Int64]$HostCount
  )
  Begin{}
  Process{
    Try
    {
      if($PrefixLength)
      {
        $MaxHosts = [math]::Pow(2,(32-$PrefixLength)) - 2
      }
      if($HostCount)
      {
        $PrefixLength = (Get-CidrFromHostCount -HostCount $HostCount).PrefixLength
        $MaxHosts = [math]::Pow(2,(32-$PrefixLength)) - 2
      }
      
      if($PSCmdlet.ParameterSetName -eq 'SubnetMask')
      {
        $PrefixLength = Convert-NetMaskToCIDR -SubnetMask $SubnetMask `
        -ErrorAction Stop
      }
      else
      {
        $SubnetMask = Convert-CIDRToNetMask -PrefixLength $PrefixLength `
        -ErrorAction Stop
      }
      
      $netMaskInt = ConvertIPv4ToInt -IPv4Address $SubnetMask     
      $ipInt = ConvertIPv4ToInt -IPv4Address $IPAddress
      
      $networkID = ConvertIntToIPv4 -Integer ($netMaskInt -band $ipInt)

      $broadcast = Add-IntToIPv4Address -IPv4Address $networkID `
      -Integer ($MaxHosts+1)

      $firstIP = Add-IntToIPv4Address -IPv4Address $networkID -Integer 1
      $lastIP = Add-IntToIPv4Address -IPv4Address $broadcast -Integer (-1)

      if($PrefixLength -eq 32)
      {
        $broadcast = $networkID
        $firstIP = $null
        $lastIP = $null
        $MaxHosts = 0
      }

      $outputObject = New-Object -TypeName PSObject 

      $memberParam = @{
        InputObject = $outputObject
        MemberType  = 'NoteProperty'
        Force       = $true
      }
      Add-Member @memberParam -Name CidrID -Value ('{0}/{1}' -f $networkID, $PrefixLength)
      Add-Member @memberParam -Name NetworkID -Value $networkID
      Add-Member @memberParam -Name SubnetMask -Value $SubnetMask
      Add-Member @memberParam -Name PrefixLength -Value $PrefixLength
      Add-Member @memberParam -Name HostCount -Value $MaxHosts
      Add-Member @memberParam -Name FirstHostIP -Value $firstIP
      Add-Member @memberParam -Name LastHostIP -Value $lastIP
      Add-Member @memberParam -Name Broadcast -Value $broadcast

      Write-Output -InputObject $outputObject
    }
    Catch
    {
      Write-Error -Exception $_.Exception `
      -Category $_.CategoryInfo.Category
    }
  }
  End{}
}

Export-ModuleMember -Function Get-IPv4Subnet, Convert-NetMaskToCIDR, Convert-CIDRToNetMask, Add-IntToIPv4Address, Get-CidrFromHostCount, Convert-IPv4AddressToBinaryString
