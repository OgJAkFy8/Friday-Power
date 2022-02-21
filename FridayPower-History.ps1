<#
    Welcome again to Friday Power,

    How about a little history? 
    
    When you run a cmdlet, it stores it in the command history.  Here is how to do a Total Recall.

    Get-History
    Clear-History - Clear the 
    Add-History - Import a list of username/passwords
    Invoke-History - Run a specific command by line ID   
#>  

# To get started with some history
# Run the following commands:
Get-Printer
Get-ChildItem -File
Get-Alias
Get-Verb
Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object -FilterScript {
  $_.HasPrivateKey
}  
(Get-CimInstance -ClassName CIM_NetworkAdapter -Property *).MacAddress

#-----------------------------

# Searching backwards
# Press the Up or Down arrow to step through the older commands.  


# What if you want to see them all?
# You can use the following cmdlet
Get-History # The default cmdlet displays everything to the screen.

# You can also grab just the commands that worked.
Get-History -Id 1, 3, 4 

# Search for a specific command
Get-History | Where-Object -FilterScript {
  $_.CommandLine -like '*Printer'
}

# Show all of the properties.
Get-History | Format-List -Property *

# You can save all of the history or just select commands
# Let's say you have created a script through trial and error.  
# You can send that history to a file.  I like csv files, but you can use Out-file or export-clixml too.
Get-History | Export-Csv -Path ".\PSHistory($(Get-Date -UFormat %Y%m%d)).csv"

# You can also grab just the commands that worked.
Get-History -Id 1, 3, 4 | Export-Clixml -Path ".\PSHistory($(Get-Date -UFormat %Y%m%d)).xml"

# Now clear the history
Clear-History


# Import (Append) it back to the same or new PowerShell window.  
# NOTE: If you are just clearing and re-adding, your numbers will start where they left off before the clear
Add-History -InputObject (Import-Clixml -Path .\history.xml)



########## More Reading #########

# Get a specific command based on it's ID and run it.
# You can get the command
Get-History -Id 2

# To run that command
Invoke-History -Id 2 -WhatIf

# F8 Button
<# 
  This method works under the condition that you can remember the certain command partially.
  Type the part of the command that you can recall then press F8 on the keyboard. 
  "Get" + F8
  Keep pressing F8 until you find the command you need.
  #>

# By default, the PowerShell in Windows 10 saves the last 4096 commands that are stored in a plain text file located in the profile of each user (ISE is in a separate file)
Get-Content $env:USERPROFILE\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt


