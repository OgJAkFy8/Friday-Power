<#
    I had a tough time getting my head wrapped aroud OOP (Object-oriented Programming) after learning POP (Procedural Oriented Programming).  

    There is much more to it, but in a nut shell, OOP uses classes and objects to create models based on the real world environment.

    I am going to use the New-Item and Get-ChildItem as an example.

    First we are going to create a new object named "myTestFile.txt"

    Then we are going to look at the different things that are available to objects

#>

# The New-Item creates an object by the name of myTestFile.txt.  
# Now we that have our object, let's see what can be done.
New-Item -Path .\myTestFile.txt -ItemType File


Get-ChildItem -Path .\myTestFile.txt | Get-Member 




while($i -lt $($files.Count))
{
  Write-Host -Object ('File {0}' -f $($i+1))
  Write-Host -Object ('{0,14} {1,-20}' -f 'Name :', $files[$i].Name )
  Write-Host -Object ('{0,14} {1,-20}' -f 'BaseName :', $files[$i].BaseName )
  Write-Host -Object ('{0,14} {1,-20}' -f 'Extension :', $files[$i].Extension )
  Write-Host -Object ('{0,14} {1,-20}' -f 'FullName :', $files[$i].FullName )
  Write-Host -Object ('{0,14} {1,-20}' -f 'CreationTime :', $files[$i].CreationTime )
  Write-Host -Object ('{0,14} {1,-20}' -f 'Length :', $files[$i].Length )
  
  Write-Host -Object ('~'*20)
  $i++
}





