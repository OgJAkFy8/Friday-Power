<# Extracting the email addresses

    Desktop <a@mail>;Documents <b@mail>;Downloads <c@mail>;Favorites <d@mail>;Links <e@mail>;Music <f@mail>;OneDrive <g@mail>;Pictures <h@mail>;Saved Games<i@mail>;Searches
    <j@mail>;testfile<k@mail>

#>

# Select the list from a group and put it in a variable
$Contacts = 'Desktop <a@mail>;Documents <b@mail>;Downloads <c@mail >; Favorites < d@mail >;Links <e@mail>;Music <f@mail>;OneDrive <g@mail>;Pictures <h@mail>;Saved Games<i@mail>;Searches
<j@mail>;testfile<k@mail>'

# First we split the list into an array
$arrayContacts = $Contacts.Split(';')

# Then we pass it by pipeline to a ForEach-Object statement 
$emailaddresses = $arrayContacts | ForEach-Object -Process {
  $_.split('<')[1].trim(' ','>') 
}

# Lastly we join it back for use in the Outlook "TO:" line
$emailaddresses -join ';'

# Or we can do it all at once with a Foreach-object alias (%)
($Contacts.Split(';') | % {$_.split('<')[1].trim(' ','>') }) -join ';'

# As a function
function Pop-EmailAddress
{
  <#
      .SYNOPSIS
      Extracts the email addresses out of a list from outlook.
  #>
  [CmdletBinding(SupportsShouldProcess)]
  [Alias('Extract-Emails')]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline, HelpMessage = 'List of contacts in Outlook Address bar')]
    [String[]]$Contacts
  )
  $emailaddresses = @()
  # Split the list into an array, so we can loop through it
  $arrayContacts = $Contacts.Split(';')

  # Then we pass it by pipeline to a ForEach-Object statement 
  ForEach($Contact in $arrayContacts) 
  {
    $emailaddresses += $Contact.split('<')[1].trim(' ','>')
  }

  # Join it back for use in the Outlook "TO:" line
  $results = $emailaddresses -join ';'

  Return $results
}

#Now you can do this
'Desktop <a@mail>;Documents <b@mail>;Downloads <c@mail >; Favorites < d@mail >' | Pop-EmailAddress

#or with the alias
Extract-Emails -Contacts $Contacts


