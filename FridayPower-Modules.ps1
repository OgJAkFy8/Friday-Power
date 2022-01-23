<#

Today we are going to use BOTH PowerShell (console) and PowerShell (ISE), so open both

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

    Today we are going to work with modules.  

    First what is a module?
    A module is a package that contains PowerShell members, such as cmdlets, providers, functions, workflows, variables, and aliases. 

    You might use modules more than you think. When you Get-AdUser, Get-VM, Get-Printer, Resolve-DNSName.
    Each of those are built into a module.

    We are going to start building our own module that will have the tools that we are going to make over the next 52 weeks. ;-)
#>

# Find the modules that are currently loaded
Get-Module

# To see a list of modules that are available
Get-module -ListAvailable

<#
 When you call a cmdlet that isn't loaded it will look for the module in the locations that are listed.
 If it doesn't exist in the list, you will need to install it.  
 We are not going to cover that right now, because many of those are out on the internet and we don't have easy access to that.


 The cool thing is that we can build our own modules. So, let's get started.

 1. Create a folder where you want to house your scripts.  #>
 md $env:userprofile\Documents\MyScripts
 
 #2. Open a new tab in ISE and save it as $env:userprofile\Documents\MyScripts\OMCS.Tools.psm1  (Note the extension "psm1" not "ps1"
 #3. In that file, type the following and save it:
 
    Clear-Host
    Write-Host "Loading module - OMCS.Tools " -NoNewline
    for($i=0;$i -lt 5;$i++){Sleep 1; Write-Host '. ' -NoNewline -ForegroundColor Green}

# Congratulations, you have just created your very own module

# Either in the console window of the ISE or open a normal PowerShell window
# Navigate to the folder you saved it.  

cd $env:userprofile\Documents\MyScripts

# Check again to see what modules you have loaded
Get-Module

# Now load your module
Import-Module .\OMCS.Tools.psm1

# Verify it loaded
Get-Module OMCS.Tools #Don't worry about the Version or ExportedCommands right now.

# Now unload your module
Remove-Module OMCS.Tools

# And check again
Get-Module 

# A quick function test.  At the console type:
Get-Item -Path Function:\Ping-IpRange

# If you got a return
Remove-Item -Path Function:\Ping-IpRange


# That is a good start.  Now let's start adding some commands to make it useful
# Open or Edit OMCS.Tools.psm1 copy and paste the following function into it and save it

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

# At the very bottom of the module script type the following and save it.  This should always be the last line in your module.
Export-ModuleMember Ping-IpRange


# Import your module again
Import-Module .\OMCS.Tools.psm1 -Force # You don't need to use "-force” because it isn't loaded.  But using force allows you to "overwrite" if it was loaded. 

# Check to see if your module loaded, then check to see if your function loaded
Get-Module OMCS.Tools 
Get-Item -Path Function:\Ping-IpRange  # Note the source

# Leaving PowerShell ISE open 
# Close and reopen the PowerShell console.
# When it has opened back up check to see what modules are loaded.
Get-Module

# You should not see your module.  
# That's okay, you can always reload by navigating to the Script folder and import it: Import-Module .\OMCS.Tools.psm1



### --------------------- The following is about loading your module "tool kit" at start-up. ------------------ ###
# This will increase the amount of time it takes to start PowerShell, but you may find that the little extra time is worth having your tools available immediately.

# There are a couple things to keep in mind, if you are going to load it at start-up.
#1. As mentioned, it is going to increase your start-up time.
#2. Your module (psm1) will have to stay put or you will have to rewrite your $Profile file
#3. You can add functions to your "tool box" and those functions will automatically be loaded.  Remember GIGO, so don't use untested functions.

# This is a one liner that will add the line to your profile.
# In your PowerShell console paste or type the following:
Add-Content -Value "Import-Module $((Get-Item .\OMCS.Tools.psm1).FullName)" -Path $profile

<# Now close and open PowerShell again.  This time when you open it, you should see your module loading:

Loading module - OMCS.Tools .  .  .  .

#>
