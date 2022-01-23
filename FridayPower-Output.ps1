<#
    Welcome again to Friday Power,

    Output Options
    
    Here are some different output options and ways you can use them. 
    I have to be honest, when I was putting this together, I wasn't sure if I should start with the default stuff or the most used. 
    In an effort to reduce the amount of information, I chose the later by way of editing, so there may be some copy/paste issues.
    
    For the most part, I am going to show basic use examples.  Keeping in mind that these cmdlets can do more complex tasks or be more complex to use.  
    
    An example might be the "out-file -append" which Adds the output to the end of an existing file. 
    If no Encoding is specified, the cmdlet uses the default encoding. That encoding may not match the encoding of the target file.
    So you may have to force your encoding by using the "-Encoding" to specify the type of encoding for the target file. The default value is unicode.

    Another one is the Out-Host -Paging flag doesn't work for powershell_ise.exe. Use powershell.exe

    Note about Parameters:
    You'll see that I try not to use short cuts or aliases when writing.  
    Even if a parameter is posistion based, it is best practice to use the parameter.  
    It does make your code longer, but I feel it is better for learning.
    Example (Both are valid):
      Write-Host "Hello World!"
      Write-Host -Object "Hello World!" 


      Microsoft Reference:
      https://docs.microsoft.com/

#>  

# Change your working directory to something meaningful.
CD h:\ScriptTesting                  # 'Change Directory' is a PowerShell Alias for:
Set-Location -Path h:\ScriptTesting

# Let's start with the most commonly used ones.
# Clear-Host simply clears the screen
Clear-Host

# Write-Host primary purpose is to produce for-(host)-display-only output, such as printing colored text
# Although this is most often used.  It is not always the best practice. Unless you need to display an output for interaction of the user, it would be best to use "Write-Verbose" instead.  This allows the user to choose if they want to see an output or not.
Write-Host "My Username is: $env:USERNAME" -ForegroundColor Green

Write-Host -Object 'My Computer name is: ' -ForegroundColor Red -NoNewline 
Write-Host -Object $env:COMPUTERNAME -ForegroundColor DarkBlue -BackgroundColor Yellow

Write-Host -Object ('My', 'Homepath', 'is:', $env:HOMEPATH) -Separator ' ' -ForegroundColor Cyan


# Out-File is sort of self explanatory.  The switches need some.  
Get-Alias | Out-File .\PS-AliasList.txt
Get-Alias | Out-File -FilePath .\PS-AliasList.txt -NoClobber # NoClobber prevents an existing file from being overwritten. This should thow an error.
Get-Alias | Out-File -FilePath .\PS-AliasList.txt -Append    # Adds the output to the end of an existing file.
Get-Alias | Out-File -FilePath .\PS-AliasList.txt -Force     # Force overwrites an existing file, even if read-only.


# Write-Output as discribed by Microsoft:
# Writes the specified objects to the pipeline. If Write-Output is the last command in the pipeline, the objects are displayed in the console. 
Write-Output (Get-Content -Path .\PS-AliasList.txt)
Write-Output -InputObject (Get-Content -Path .\PS-AliasList.txt) | ForEach-Object -Process {
  if($_ -notmatch 'Get')
  {
    Write-Host -Object $_ -ForegroundColor Red
  }else
  {
    Write-Host -Object $_ -ForegroundColor Green
  }
}


# Out-Gridview is our graphic output, and can be used to choose one or more items
# It has a lot more features that we explore, so Get-Help Out-GridView or Bing it
Get-Printer | Out-GridView                     # As a display (Same as OutputMode None)
Get-Printer | Out-GridView -OutputMode Single  # As a Single selector
Get-Printer | Out-GridView -PassThru           # The PassThru parameter is equivalent to using the Multiple value of the OutputMode parameter.


# Export-Csv Converts objects into a series of comma-separated value (CSV) strings and saves the strings to a file
Get-Alias | Export-Csv -Path .\PS-AliasList.csv.txt

# So now you can import the CSV as such
$AliasData = Import-Csv -Path .\PS-AliasList.csv.txt
$AliasData.Name
 
# Out-Printer is like Out-Host, but to the printer.  
# There is no formatting and it is a little tricky, because you need to know the exact name of the printer you want to use.
# Of course you could use Get-Printer or add " | Out-Gridview" to get the name. 
$PrinterName = (Get-Printer | Out-GridView -Title 'Select the printer you want to print to' -OutputMode Single).Name

# Another option uses the Default printer, but could be pointed to OneNote or PDF
# $PrinterName = Get-WmiObject -Query " SELECT * FROM Win32_Printer WHERE Default=$true" 
Get-History | Select-Object -First 50 | Out-Printer -Name $PrinterName


# In an effort to keep this somewhat short, here are some nice to know ones.

# Out-Null sends any outputs to nothing or null. A good use for this is when creating an empty file/folder
New-Item -Name 'PS-Verbs.txt' -ItemType File -Force             # Try this first. 
$null = New-Item -Name 'PS-Verbs.txt' -ItemType File -Force     # Now this

# Out-Default is added automatically to the end of every pipeline. While Out-Default is not intended to be run directly by the end user, it can be.
Get-Process | Select-Object -First 5
Get-Process | Select-Object -First 5 | Out-Default

# Out-Host is another one that is implied, but used to ensure the output is to the host
Get-Service | Out-Host
Get-Service | Out-Host -Paging # This will error out if you are using it in the ISE. Use the plain PowerShell window


# The next isn't so much an output, but it does help at times.
# Tee-Object allows you to save, send to pipeline (if used as the last command it will output to console)
Tee-Object -InputObject (Get-Verb) -FilePath .\PS-Verbs.txt          # Save to file and show on console
Get-History | Tee-Object -Variable TeeHistory | Out-File -FilePath .\PS-HistoryTee.txt    # Save to variable $TeeHistory (note: no "$") and save to a file
$TeeVerbs | Select -last 5 | Format-Table  # Call the variable

# Another Tee-Object Example
# Saves ALL printers to variable and then saves only OneNote Printers to file
Get-Printer | Tee-Object -Variable AllPrinters | Where-Object -Property Name -Match -Value 'One' | Out-File -FilePath .\OneNote-Printers.txt 
$AllPrinters # Call the variable


# Write-Progress displays a progress bar in a PowerShell command window that depicts the status of a running command or script
for ($i = 1; $i -le 100; $i++ )
{
  Write-Progress -Activity 'Search in Progress' -Status "$i% Complete:" -PercentComplete $i
  Start-Sleep -Milliseconds 50
}


# Special use outputs for your scripts
# These are helpful, but mostly when you are writing longer scripts.
Write-Debug -Message 'Debug' -Debug
Write-Error -Message 'This is an Error' -Category InvalidData
Write-Information -MessageData 'This is Information' -InformationAction Continue
Write-Verbose -Message 'This is Verbose' -Verbose
Write-Warning -Message 'This is a Warning' -WarningAction Continue




