<#
    I had a tough time getting my head wrapped around OOP (Object-oriented Programming) after learning POP (Procedural Oriented Programming).  

    There is much more to it, but in a nut shell, OOP uses classes and objects to create models based on the real world environment.

    I am going to use the New-Item and Get-ChildItem as an example.

    First we are going to create a new file or "object" named "myTestFile.txt"

    Then we are going to look at the different things that are available to objects

#>

# The New-Item creates an object by the name of myTestFile.txt.  
# Now we that have our object, let's see what can be done.
New-Item -Path .\myTestFile.txt -ItemType File
Get-ChildItem -Path .\myTestFile.txt | Get-Member | Out-File .\myTestFile.txt

Get-ChildItem -Path .\myTestFile.txt | Get-Member 



$file = Get-ChildItem -Path .\myTestFile.txt

# Properties are things that describe the object
Write-Host -Object 'This is a list of some of the Properties of the file'
Write-Host -Object ('{0,15} {1,-20}' -f 'Name :', $file.Name )
Write-Host -Object ('{0,15} {1,-20}' -f 'BaseName :', $file.BaseName )
Write-Host -Object ('{0,15} {1,-20}' -f 'Extension :', $file.Extension )
Write-Host -Object ('{0,15} {1,-20}' -f 'FullName :', $file.FullName )
Write-Host -Object ('{0,15} {1,-20}' -f 'CreationTime :', $file.CreationTime )
Write-Host -Object ('{0,15} {1,-20}' -f 'Length :', $file.Length )
Write-Host -Object ('{0,15} {1,-20}' -f 'Exists :', $file.Exists )
Write-Host -Object ('{0,15} {1,-20}' -f 'DirectoryName :', $file.DirectoryName )

  
Write-Host -Object ('~'*20)


Write-Host -Object 'Below are the things we can do to the file or the "Methods"'



$file.GetAccessControl().Owner

$file.CreationTime.DayOfWeek
