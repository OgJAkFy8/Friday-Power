<# 
    Extracting the email addresses
    Last week I needed to get everyone's email address as a semicolon separated list.

    I didn't want to waste time stripping off the names, spaces, special characters. So I expanded the email group in the Outlook "To" line.

    That gave me a group of contacts that looked like this:
    Desktop <a@mail>;Documents <b@mail>;Downloads <c@mail>;Favorites <d@mail>;Links <e@mail>;Music <f@mail>;OneDrive <g@mail>;Pictures <h@mail>;Saved Games<i@mail>;Searches
    <j@mail>;testfile<k@mail>
 
#>

# Select the list from a group and put it in a variable
$Contacts = 'Desktop <a@mail>;Documents <b@mail>;Downloads <c@mail >; Favorites < d@mail >;Links <e@mail>;Music <f@mail>;OneDrive <g@mail>;Pictures <h@mail>;Saved Games<i@mail>;Searches
<j@mail>;testfile<k@mail>'

# Split the list into an array
$arrayContacts = $Contacts.Split(';')

# Then we pass it by pipeline to a ForEach-Object statement loop (For Loop)
# Split it on the '<' and take the second part and trim the spaces and '>' off if it
$emailaddresses = $arrayContacts | ForEach-Object -Process {
  $_.split('<')[1].trim(' ','>') 
}

# Join it back for use in the Outlook "TO:" line
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


