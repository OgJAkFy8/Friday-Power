<#
The other day someone asked how to create a path from some variables.  

A path is only a string, so you can create it by simply typing the whole thing, but that doesn't scale well, so it is best to use variables.

Below are ways that you can build any string.

The current perferred method is #4, which uses '-f' formatting.  
  Each {x} contains a number, which don't have to be in order, but the list is always 0-X 
  Then list after the '-f' are the order starting from zero.
#>

# End result and option #1
'C:\folder\file.txt'

# Use variables
$folder = 'folder'
$file = 'file.txt'

# Option #2
'C:\'+$folder+'\'+'file'+'.'+'txt'

# Option #3
"$env:HOMEDRIVE\$folder\$file"

# Option #4
'{1}\{0}\{2}' -f $folder, 'C:', $file

# Note: For this to work you need to start with a string.  If you get part of the path from another command you may need to convert it to a string first.



