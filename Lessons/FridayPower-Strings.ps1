<#
    A string is a series of characters. See the examples below.  I am going to put all of them in single quotes (More on this later)
      'NEDIAC'
      'My Documents'
      '     This string has 5 spaces at each end.     '
      '3.14'
      '42'
      'DIR#n#t$IsAString2'
      'Desktop,Documents,Downloads,Favorites,Links,Music,OneDrive,Pictures,Saved Games,Searches,testfile'
#>


# Assign a string to a variable
# Use meaningful varible names
$IsAString1 = 'NEDIAC'
$IsAString2 = 'My Documents'
$NotAstring = 1024
$Sentence = '     This string has 5 spaces at each end.     '
$Pi = '3.14'
$TheAnswer = '42'
$Quotes = 'DIR#n#t$IsAString2'
$LongStringListOfFolders = 'Desktop,Documents,Downloads,Favorites,Links,Music,OneDrive,Pictures,Saved Games,Searches,testfile'

# Use Get-Member to get the properties and methods of objects.  # Note the first line returned
$IsAString1 | Get-Member 
$NotAstring | Get-Member

#Get the length
$Sentence.Length 

#Trim the extra space off the ends
$TrimmedSentence = $Sentence.Trim() # Trim the ends and store it to a new variable
$Sentence.Trim().Length # Trim and check length

# Trim each end of specific sequence
' ComputerName.company.com'.TrimEnd('.company.com').TrimStart()   #Here is a computername string with a space in front and the domain.
'####___+++,,,,,,ComputerName'.TrimStart('#','_','+',',')         #Maybe you need to get rid of a bunch of differnent characters

#Let's remove the spaces from the sentence and correct it at the same time.
$Sentence.Trim().Replace('5','0')
$NewSentence = $Sentence.Trim().Replace('5','0') # assigning it to a new variable 

# Create padding for you output<#
$Pad = (' '*42)

# Adding two or more strings together
$Pi+$TheAnswer 

# Converting to Numbers
[float]$Pi+[int]$TheAnswer

Combining the above
$Pad = (' '*[int]$TheAnswer)
$NewSentence = $Pad+$Sentence.Replace('0',$TheAnswer)+$Pad

# Quotes are important in PowerShell.  
'DIR#n#t$IsAString2' # Start with single quotes / Everything in the quotes are treated as a string
"DIR#n#t$IsAString2" # Change it to double quotes / Allows you to put variables into your output string
"DIR`n`t$IsAString2" # Change the (#) to a (`) left of #1 on the keyboard / The backtick changes the 'n' to a 'newline' and 't' to a 'tab' character

# Search String
$LongStringListOfFolders.Contains('Desktop')
$LongStringListOfFolders.EndsWith('Desktop')
$LongStringListOfFolders.StartsWith('Desktop')

# Pull item from string
$LongStringListOfFolders[5]             #See what that gives you

#Convert a string list to an Array
$ArrayString = $LongStringListOfFolders.split(',') 
$ArrayString[5] 

# Other manipulations
$LongStringListOfFolders.split(',')[5].EndsWith('sic')
'My '+$LongStringListOfFolders.split(',')[5]
$LongStringListOfFolders.split(',')[5].Replace('sic','zak')





### END ###

<###
Extra Information: The Backtick (`) operator is an escape character or word-wrap operator.  
The later I am not a fan of because, it is not always clear if it is a single quote, a spec on your screen or dead pixel. It isn't always clearer in print, like a PowerShell text book.

"`$IsAString2`tis`t$IsAString2"

"This `"string`" `$uses `r`n Backticks '``'"
'This "string" $uses {0}{1} Formatting {2}' -f "`r","`n","'``'"

As used as above it is an escape character 
`n = New line (ASCII 13)
`t = Tab (ASCII 9)
`r = Carriage Return (ASCII 10)

It is also called word-wrap operator and used when you need to write a script on multiple lines for easy reading. Often used with online examples. 
But, there are better ways to handle these situations.
So this:
Get-Printer | Select-Object -Property * | Select-Object Name,Type,PrinterStatus

Can become this:
Get-Printer `
| Select-Object `
 -Property * `
| Select-Object Name,Type,PrinterStatus

Or you can use the '|' pipe to separate lines:
Get-Printer | 
  Select-Object -Property * | 
  Select-Object Name,Type,PrinterStatus

And for our Ping-IpRange example
Ping-IpRange -First3Octets 192.168.0 -FirstAddress 0 -LastAddress 10

Could be:
$Splat = @{
  First3Octets = '192.168.0'
  FirstAddress = 0
  LastAddress  = 5
}
Ping-IpRange @Splat

Remember this is about making the code more readable with shorter lines.
 ###>

 #End -------------------------------------------- 
