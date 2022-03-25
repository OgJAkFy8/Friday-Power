<#
Replace 
#>

# Simple replace
'This_is_a_string_with_spaces.'.Replace('_', ' ')

# You can put two "replace" statements in one line
'This_is_a_string_with_spaces.'.Replace('_', ' ').Replace('string','sentence')


# You can use the "replace" statement on files too
$String = @"
Line one
Line two
Line three
"@

$String | Out-File c:\temp\ReplaceFile.txt # This makes our file
Get-Content C:\temp\ReplaceFile.txt # This shows what is in it currently

# To make changes to a file
(Get-Content c:\temp\ReplaceFile.txt -Raw) -Replace 'Line', 'This is sentence' | Set-Content c:\temp\ReplaceFile.txt

# View the new file
Get-Content c:\temp\NewReplaceFile.txt # This shows the changes

# To make changes to a file and create a new one.
$Oldfile = (Get-Content c:\temp\ReplaceFile.txt -Raw) -Replace 'Line', 'This is sentence' 
$Oldfile | Set-Content c:\temp\NewReplaceFile.txt

