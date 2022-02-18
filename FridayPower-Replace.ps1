<#
Replace 
#>

'This_is_a_string_with_spaces.'.Replace('_', ' ')


$String = @"
Line one
Line two
Line three
"@

$String | Out-File c:\temp\ReplaceFile.txt
(Get-Content c:\temp\ReplaceFile.txt -Raw) -Replace ' ', '_' | Set-Content c:\temp\ReplaceFile.txt

Get-Content c:\temp\ReplaceFile.txt 