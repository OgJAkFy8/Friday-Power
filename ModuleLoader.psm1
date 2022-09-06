$Functionpath = $PSScriptRoot + '\Scripts\'

$FunctionList = Get-ChildItem -Path $Functionpath -Name -File

foreach($function in $FunctionList)
{
  . ($Functionpath + $function)
}

#(Get-Command -Module OMCS.Tools).Name