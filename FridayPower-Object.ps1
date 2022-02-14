<#
Most of us know 'DIR' or 'ls' to get a list of files and folders at the command line.  
You can still use that in PowerShell, but it is an alias for Get-ChildItem.

And Get-ChildItem is so much more powerful than the CLI commands that we have come to know and love.

When you use Get-ChildItem it returns what looks like a list of file, but what it really returns is an Object of files.
And that object can be manipulated in different ways.

#>

Get-ChildItem


$files = Get-ChildItem -File | Select-Object -Property * -First 3
$i = 0

while($i -lt $($files.Count))
{
  Write-Host -Object ('File {0}' -f $($i+1))
  Write-Host -Object ('{0,14} {1,-20}' -f 'Name :', $files[$i].Name )
  Write-Host -Object ('{0,14} {1,-20}' -f 'BaseName :', $files[$i].BaseName )
  Write-Host -Object ('{0,14} {1,-20}' -f 'Extension :', $files[$i].Extension )
  Write-Host -Object ('{0,14} {1,-20}' -f 'FullName :', $files[$i].FullName )
  Write-Host -Object ('{0,14} {1,-20}' -f 'CreationTime :', $files[$i].CreationTime )
  Write-Host -Object ('{0,14} {1,-20}' -f 'Length :', $files[$i].Length )
  
  Write-Host -Object ('~'*20)
  $i++
}

Get-ChildItem -File | Select-Object -Property Name, CreationTime, Length -First 10






