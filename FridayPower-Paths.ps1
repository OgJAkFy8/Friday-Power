<#
    Welcome again to Friday Power,

    The other day someone asked how to create a path from some variables.  

    A path is only a string, so you can create it by simply typing the whole thing, but that doesn't scale well.

    Below are ways that you can build any string.

    The current perferred method is #4, which uses '-f' formatting.  
    Each {x} contains a number, which don't have to be in order, but the list is always 0-X 
    Then list after the '-f' are the order starting from zero.
#>

# End result and option #1
'C:\foldername\filename.txt'

# Use variables
$folder = 'foldername'
$file = 'filename.txt'

# Option #2
'C:\'+$folder+'\'+'filename'+'.'+'txt'

# Option #3
"$env:HOMEDRIVE\$folder\$file"

# Option #4
'{1}\{0}\{2}' -f $folder, 'C:', $file


# Sometime you need to might need to pull a path apart
'C:\foldername\filename.txt' | Split-Path        # Get the path
'C:\foldername\filename.txt' | Split-Path -leaf  # Get the filename from full path

