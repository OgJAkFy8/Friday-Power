<#
    Welcome again to Friday Power,

    Filtering outputs - Or getting the data you want. 
    
    When you run a cmdlet to get some output the data isn't always what you need and most often too much information.  So we are going to filter our output 
    to get the information we want.  This example is using the services on our system, but it could be anything

    And we are going to show how changing the order can affect the output.
     
#>  

# Let's start with the simple default.
# Using just the default output provides some information.
Get-Service

# That worked, but let's get just the first five.
Get-Service | select -First 5

# Now with all of the properties
Get-Service | Select -Property * -First 5

# Change the list to a table 
Get-Service | Select -Property * -First 5 | Format-Table

# Now with ONLY dependent services or Not "Win32OwnProcess". 
Get-Service | Where DependentServices -NE $null | Select -Property * -First 5 | Format-Table
Get-Service | Where-Object ServiceType -NE 'Win32OwnProcess' | Select-Object -Property * -First 5 | Format-Table

<# 
# Where did I get "ServiceType"?  From the Get-Member command the alias 'gm'
# The Get-Member command shows you all sorts of good information about the piped command
    Method - is sort of an action word
    Property - is like a setting
#>
Get-Service | gm 

# Now we can see that "Status" will give the current state
Get-Service | Where Status -EQ 'Stopped'

#Again, Not real helpful.  Should they be stopped? And do we need the "Stopped" column?
Get-Service | Where-Object Status -EQ 'Stopped' | Select StartType,Name,DisplayName

#Again, helpful information, but they are only the ones that are stopped, so do we need the "Stopped" and "DisplayName" columns?
# Up until this time I have been using an "Alias" for the "Where" and "Select" statements.  I am going to expand them in this example to "Where-Object" and "Select-Object"
# I am also going to add a little more code and then explain
Get-Service | Where-Object{($_.Name -Like 'Ado*') -and ($_.StartType -eq 'Automatic')} | Select-Object StartType,Name,@{Label = "Depended On" ; Expression = {$_.ServicesDependedOn}}
<#
- Get-Service - Default cmdlet
- Where-Object{  } - This is where we filter the information we are looking for.  Information from the pipe is sent using "$_" variable
- ($_.Name -Like 'Ado*') -and ($_.StartType -eq 'Automatic') - We want to find the ("Services.Name" that is like 'Ado*') AND (Services.StartType that equal 'Automatic')
- Select-Object - The items that we want sent to the output.
- @{Label = "Depended On" ; Expression = {$_.ServicesDependedOn}} - This allows us to change the name of our output column from "ServicesDependedOn" to "Depended On"
#>

############################################

# Importance of order.  When sending something to a pipe the order is important. The next three commands, have the same commands, but in different orders 
# They all get the list of services first, but then they do different things in different orders causing the output to be just a little different.


# Get the list of services and sort on DisplayName. Take that list and select only ones that have Dependent services.  Lastly, select the first five in the list.  
Get-Service | sort DisplayName | Where DependentServices -NE $null | select -First 5
Write-Host '-'

# This one gets the list of services that have dependent services, then it takes the first five and finally sorts them 
Get-Service | Where DependentServices -NE $null | select -First 5  | sort DisplayName
Write-Host '-'

# Again, get the list of services, but only take the first five.  Now sort sort those five by DisplayName and of those ones that have Dependent services
Get-Service | select -First 5 | sort DisplayName | Where DependentServices -NE $null

# Let's do it again, but show the dependent services in the output
Get-Service | Where DependentServices -NE $null | Select -First 5 | Select Name,Status,DependentServices
#{________}   {_______________________________}  {_______________}  {__________________________________}
#  Main Cmdlet    Where-Object Statement         select amount       Select what you want to capture



