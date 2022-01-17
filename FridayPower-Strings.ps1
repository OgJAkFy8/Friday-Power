<#

Today we are going to use PowerShell (ISE)

Copy the everything in this email between the #Start ---- AND #End ----

    Paste it into PowerShell ISE

    ISE Tricks:
    1. Select any piece of code and press F8 to run it. Multiple lines or even in the comment section
       Example: Select the following: Get-Date
    2. Place your cursor on a line and press F8 to run the whole line 
#>


#Start -------------------------------------------- 
<#
    Welcome again to Friday Power,

    Today we are going to work with strings.  

    First what is a string?
    A string is a series of characters. See the examples below.  I am going to put all of them in single quotes (More on this later)
      'NEDIAC'
      'My Documents'
      '     This string has 5 spaces at each end.     '
      '3.14'
      '42'
      'DIR#n#t$IsAString2'
      'Desktop,Documents,Downloads,Favorites,Links,Music,OneDrive,Pictures,Saved Games,Searches,testfile'

#>


# Put the String into a variable.  It is always best (when possible) to use meaningful varible names
$IsAString1 = 'NEDIAC'
$IsAString2 = 'My Documents'
$NotAstring = 1024
$Sentence = '     This string has 5 spaces at each end.     '
$Pi = '3.14'
$TheAnswer = '42'
$Quotes = 'DIR#n#t$IsAString2'
$LongStringListOfFolders = 'Desktop,Documents,Downloads,Favorites,Links,Music,OneDrive,Pictures,Saved Games,Searches,testfile'

#Remember that we are dealing with strings and each of the above variables are strings.
#Let's start by piping '|' the string to Get-Member.  This is going to give us information our variable. 
$IsAString1 | Get-Member

#Check the first line returned.  You should have "TypeName: System.String"

#For comparison, do the same with $NotAstring
$NotAstring | Get-Member #Note the first line

#Run the Get-Member again on our string variable.  All the methods that you are able to use with the string are listed, as well as all of the properties.
$IsAString1 | Get-Member

#There are a lot of things you can do, so let's get to it.  
#Trim the extra space off the ends
$Sentence.Length #Get the length
$TrimmedSentence = $Sentence.Trim() #Now trim the ends and store it to a new variable
$TrimmedSentence.Length       #Check the new length

#Do the same as above but don't create a new variable.  This is helpful when you need to do something for a task, but don't want to create another variable.
$Sentence.Trim().Length  

' ComputerName.company.com'.TrimEnd('.company.com').TrimStart()   #Here is a computername string with a space in front and the domain.
'####___+++,,,,,,ComputerName'.TrimStart('#','_','+',',')         #Maybe you need to get rid of a bunch of differnent characters

#Let's remove the spaces from the sentence and correct it at the same time.
$Sentence.Trim().Replace('5','0')

#Same as above, but assigning it to a new variable 
$NewSentence = $Sentence.Trim().Replace('5','0')

#Another manipulation
$NewSentence.Replace('0',$TheAnswer)

<#
    The problem is that it doesn't have 42 spaces, so we should correct it.  
    To do that we are going to need 42 spaces. We start by typing ' ' 42 times, but that could lead to typos, it also makes the line of code really long
    Another way to get 42 spaces is to multiply a string 42 times. We'll use both in the next example
#>
('                                          ')+$NewSentence.Replace('0',$TheAnswer)+(' '*42)

#Taking it one more step
$Pad = (' '*42)
$Pad+$NewSentence.Replace('0',$TheAnswer)+$Pad

#There are some other options, but that will be a "Friday Power on Formatting"

<#
    Adding strings is just concatenation as you saw in the last example.  Take the following 
    $Pi = 3.14
    $TheAnswer = 42
    Together you would expect 3.14 + 42 = 45.14

    Let's add them together
#>
$Pi+$TheAnswer 

#Not as expected.  To get this to work you have to convert them to numbers (integers and floating-point decimals)
[float]$Pi+[int]$TheAnswer


<#
    Quotes are important in PowerShell.  There are two types and one that gets confused. ('"`) The Single ('), the Double ("), and the backtick (`)
#>
#Start with single quotes
'DIR#n#t$IsAString2' #Everything in the quotes are treated as a string

#Change it to double quotes
"DIR#n#t$IsAString2" #Allows you to put variables into your output string

#The backtick example. Change the (#) to a (`) left of #1 on the keyboard
"DIR`n`t$IsAString2" #The backtick changes the 'n' to a 'newline' and 't' to a 'tab' character

<#
The backtick has number of functions, but for now just know it is an escape character 
`n = New line (ASCII 13)
`t = Tab (ASCII 9)
#>


<#
    Testing to see if the string contains a series of characters
#>

$LongStringListOfFolders.Contains('Desktop')

$LongStringListOfFolders.EndsWith('Desktop')

$LongStringListOfFolders.StartsWith('Desktop')

#As of right now "$LongString" is still a string, so to get the word "Music", you can't just type $LongString[5].
$LongStringListOfFolders[5]             #See what that gives you

#Convert a string list to an Array, then we have access to each item between the ',' as an indavidual string.
#Of course Arrays are another topic, so we will leave it here.
$LongStringListOfFolders.split(',')[5]  #Now try it again

#But having access to an array means that all that stuff we did before, still works. 
$LongStringListOfFolders.split(',')[5].EndsWith('sic')

'My '+$LongStringListOfFolders.split(',')[5]

$LongStringListOfFolders.split(',')[5].Replace('sic','zak')



#Not really putting all together, but here are some things that you can do:
for($LastOctet = 0;$LastOctet -lt 10;$LastOctet++)
{
  $ip = "192.168.0.$LastOctet"
  Write-Host -Object "Ping: $ip -- Responds:  $(Test-Connection -ComputerName $ip -Count 1 -Quiet)"
}

#Or make it more reusable
function Ping-IpRange
{
  param(
    [Parameter(Mandatory,Position = 0)]
    $First3Octets,
    [Parameter(Mandatory,Position = 1)]
    $FirstAddress,
    [Parameter(Mandatory,Position = 2)]
    $LastAddress
  )
  for($LastOctet = $FirstAddress;$LastOctet -lt $LastAddress;$LastOctet++)
  {
    $ip = "$First3Octets.$LastOctet"
    Write-Host -Object "Ping: $ip -- Responds:  $(Test-Connection -ComputerName $ip -Count 1 -Quiet)"
  }
}
Ping-IpRange -First3Octets 192.168.0 -FirstAddress 0 -LastAddress 10

#Fix a list of text 
$computerNames = 'WCSTRAA01
  ___WCSTRAA02
  WCSTRAA03
  ___WCSTRAA04
  WCSTRAA05
  ___WCSTRAA06
  WCSTRAA07
  ___WCSTRAA08
  000WCSTRAA09
  ___0000NEDIACA01
  000NEDIACA02
  NEDIACA03
  000NEDIACA04
  NEDIACA05
  NEDIACA06
  NEDIACA07
  NEDIACA08
NEDIACA09'.Replace("`n",',')
$ComputerList = $computerNames.Split(',').TrimStart('_','0',' ').Replace('CA','-').Replace('AA','-')

#Send it to the clipboard
$ComputerList | clip.exe

#Make reusable
function Clean-List
{
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [String[]]$List
  )
  $CommaString = $List.Replace("`n",',')
  $CleanArray = $CommaString.Split(',').Trim('_',',','.','\','/','-','@',' ').TrimStart('0')
  Return $CleanArray
}

Clean-List -List $computerNames


#Convert it to a hashtable with FQDN's and use it to Ping those names (uses write-host for the example)
$FQDNlist = @{} #Hashtable
$ComputerList | ForEach-Object -Process {
  $FQDNlist.$_ = $_.ToLower()+'.domain.com'
}
foreach($key in $FQDNlist.Keys)
{
  Write-Host -Object "Ping: $($FQDNlist.$key)" -ForegroundColor Yellow
}

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