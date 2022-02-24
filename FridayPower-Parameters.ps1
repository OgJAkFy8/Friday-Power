<# Parameters 
    Even if a parameter is position based, it is best practice to use the parameter.
    It does make your code longer.  
    The other thing I try not to use are short cuts or aliases, because I feel it is better for documentation. 
    
#>

# Example of position-based parameters (Both are valid):
Write-Host 'Hello World!' # Position 0 is the object to print
Write-Host -Object 'Hello World!' -ForegroundColor Cyan # Foreground color is not position based, so you need to use it.

