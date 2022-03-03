# Parameters 
Most PowerShell commands, such as cmdlets, functions, and scripts, rely on parameters to allow users to select options or provide input. The parameters follow the command name and have the following form:

The name of the parameter is preceded by a hyphen (-), which signals to PowerShell that the word following the hyphen is a parameter name. The parameter name and value can be separated by a space or a colon character. Some parameters do not require or accept a parameter value. Other parameters require a value, but do not require the parameter name in the command.

* Even if a parameter is position based, it is best practice to use the parameter, even if it does make your code longer.   
### Example of position-based parameters (Both are valid):
Write-Host 'Hello World!' # Position 0 is the object to print
Write-Host -Object 'Hello World!' -ForegroundColor Cyan # Foreground color is not position based, so you need to use it.

