<#
    Outputs to a file
    
    When creating scripts there are interactive and non-Interactive.  
    When starting out we create scripts that we can interact with and getting the status of a scripts process is
    important and fun.  As we do more, we will stop showing so much to the screen and start capturing the data to a file.  Then we will send everything to a file/Report/log.
    
    Here are examples of outputs to a file. 

#>  

# Out-File 
# Is self explanatory.  
Get-Alias | Out-File .\PS-AliasList.txt
Get-Alias | Out-File -FilePath .\PS-AliasList.txt -NoClobber # NoClobber prevents an existing file from being overwritten. This should thow an error.
Get-Alias | Out-File -FilePath .\PS-AliasList.txt -Append    # Adds the output to the end of an existing file.
Get-Alias | Out-File -FilePath .\PS-AliasList.txt -Force     # Force overwrites an existing file, even if read-only.


# Export-Csv 
Get-Alias | Export-Csv -Path .\PS-AliasList.csv

# So now you can import the CSV as such
$AliasData = Import-Csv -Path .\PS-AliasList.csv
$AliasData.Name


# Export-Clixml
# Use this to export to an xml file
Get-Alias | Export-Clixml .\PS-AliasList.xml

# To save it as an HTML file, you will use Out-File
# But you need to convert the data first
Get-Alias | ConvertTo-Html | Out-File .\PS-AliasList.html







# The next isn't so much an output, but it does help at times.
# Tee-Object allows you to save, send to pipeline (if used as the last command it will output to console)
Tee-Object -InputObject (Get-Verb) -FilePath .\PS-Verbs.txt          # Save to file and show on console
Get-History | Tee-Object -Variable TeeHistory | Out-File -FilePath .\PS-HistoryTee.txt    # Save to variable $TeeHistory (note: no "$") and save to a file
$TeeHistory | Select -last 5 | Format-Table  # Call the variable

# Another Tee-Object Example
# Saves ALL printers to variable and then saves only OneNote Printers to file
Get-Printer | Tee-Object -Variable AllPrinters | Where-Object -Property Name -Match -Value 'One' | Out-File -FilePath .\OneNote-Printers.txt 
$AllPrinters # Call the variable
