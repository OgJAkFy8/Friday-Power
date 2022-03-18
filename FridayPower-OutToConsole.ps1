<#
    Outputs to the console
    
    When creating scripts there are interactive and non-Interactive.  
    When starting out we create scripts that we can interact with and getting the status of a scripts process is
    important.  As we do more, we will stop showing so much to the screen and start capturing the data to a file
    and errors to the screen.  Then we will send everything to a file/log.
    
    Here are a number of different examples of outputs you can use to interact with. 
    Keeping in mind that these cmdlets can do more complex tasks or be more complex to use.

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


# Create a file to work with
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

