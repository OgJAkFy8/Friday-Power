<#
The question is how to get all of the .csv files in a directory.  

Most of us know 'DIR' or 'ls' to get a list of files and folders at the command line.  
You can still use that in PowerShell, but it is an aliases for Get-ChildItem.

Get-ChildItem is so much more powerful than the CLI commands that we have come to know and love.  

When you use Get-ChildItem it returns what looks like a list of file, but what it really returns is an Object of files.
And that object can be viewed or manipulated in different ways.


#>


# The default cmdlet
Get-ChildItem

# Now get all of the properties of the first five items
Get-ChildItem -File | Select-Object -Property * -First 5

# Refine the list of properties to return and store in a variable.
# Use the variable to list only file names without extensions
# Show the creation time of the third objet. (0,1,2)
$FileList = Get-ChildItem -File | Select-Object -Property Name, CreationTime, BaseName, Extension -First 5
$FileList.BaseName
$FileList[2].CreationTime


# Store all of the properties of the first 5 files
# Loop through the list and display the 
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



gci -Name *.txt

