<#
    .SYNOPSIS
    Output code to go with Wiki

    .NOTES
    Here are a number of different output examples. Keeping in mind that these cmdlets can do more complex tasks or be more complex to use.

    Note about Parameters: Even if a parameter is position based, it is best practice to use the parameter. I try not to use short cuts or aliases, because I feel it is better for learning. It does make your code longer.

    Example of position-based parameters (Both are valid):
    Write-Host "Hello World!"
    Write-Host -Object "Hello World!"

    .LINK
    https://github.com/OgJAkFy8/Friday-Power/wiki/Output-Options

#>  

# Change your working directory to something meaningful.
CD h:\ScriptTesting                  # 'Change Directory' is a PowerShell Alias for:
Set-Location -Path h:\ScriptTesting

# Clear-Host simply clears the screen
Clear-Host
Clear # Alias
Clr # Alias

# Write-Host
# The primary purpose is to produce for-(host)-display-only output, such as printing colored text.
Write-Host "My Username is: $env:USERNAME" -ForegroundColor Green
Write-Host -Object 'My Computer name is: ' -ForegroundColor Red -NoNewline 
Write-Host -Object $env:COMPUTERNAME -ForegroundColor DarkBlue -BackgroundColor Yellow
Write-Host -Object ('My', 'Homepath', 'is:', $env:HOMEPATH) -Separator ' ' -ForegroundColor Cyan


# Out-File 
# Is self explanatory.  
Get-Alias | Out-File .\PS-AliasList.txt
Get-Alias | Out-File -FilePath .\PS-AliasList.txt -NoClobber # NoClobber prevents an existing file from being overwritten. This should thow an error.
Get-Alias | Out-File -FilePath .\PS-AliasList.txt -Append    # Adds the output to the end of an existing file.
Get-Alias | Out-File -FilePath .\PS-AliasList.txt -Force     # Force overwrites an existing file, even if read-only.


# Write-Output 
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


# Out-Gridview 
Get-Printer | Out-GridView                     # As a display (Same as OutputMode None)
Get-Printer | Out-GridView -OutputMode Single  # As a Single selector
Get-Printer | Out-GridView -PassThru           # The PassThru parameter is equivalent to using the Multiple value of the OutputMode parameter.


# Export-Csv 
Get-Alias | Export-Csv -Path .\PS-AliasList.csv.txt

# So now you can import the CSV as such
$AliasData = Import-Csv -Path .\PS-AliasList.csv.txt
$AliasData.Name
 
# Out-Printer 
# You need to know the name of the printer, so use Get-Printer or both it with Out-Gridview to get the name. 
$PrinterName = (Get-Printer | Out-GridView -Title 'Select the printer you want to print to' -OutputMode Single).Name

# Another option uses the Default printer, but could be pointed to OneNote or PDF
$PrinterName = Get-WmiObject -Query "SELECT * FROM Win32_Printer WHERE Default=$true" 

# Whichever method you use to get the printer's name you can use it as such
Get-History | Select-Object -First 50 | Out-Printer -Name $PrinterName



# Extra Information - nice to know outputs

# Out-Null sends any outputs to nothing or null. 
New-Item -Name 'PS-Verbs.txt' -ItemType File -Force             # Try this first. 
$null = New-Item -Name 'PS-Verbs.txt' -ItemType File -Force     # Now this


# The next isn't so much an output, but it does help at times.
# Tee-Object allows you to save, send to pipeline (if used as the last command it will output to console)
Tee-Object -InputObject (Get-Verb) -FilePath .\PS-Verbs.txt          # Save to file and show on console
Get-History | Tee-Object -Variable TeeHistory | Out-File -FilePath .\PS-HistoryTee.txt    # Save to variable $TeeHistory (note: no "$") and save to a file
$TeeHistory | Select -last 5 | Format-Table  # Call the variable

# Another Tee-Object Example
# Saves ALL printers to variable and then saves only OneNote Printers to file
Get-Printer | Tee-Object -Variable AllPrinters | Where-Object -Property Name -Match -Value 'One' | Out-File -FilePath .\OneNote-Printers.txt 
$AllPrinters # Call the variable


# Write-Progress displays a progress bar in a PowerShell command window that depicts the status of a running command or script
for ($i = 1; $i -le 100; $i++ )
{
  Write-Progress -Activity 'Search in Progress' -Status ('{0}% Complete:' -f $i) -PercentComplete $i
  Start-Sleep -Milliseconds 50
}

# Special use outputs when you are writing longer scripts.
Write-Debug -Message 'Debug' -Debug
Write-Error -Message 'This is an Error' -Category InvalidData
Write-Information -MessageData 'This is Information' -InformationAction Continue
Write-Verbose -Message 'This is Verbose' -Verbose
Write-Warning -Message 'This is a Warning' -WarningAction Continue

