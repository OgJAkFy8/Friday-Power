# Another Tool for our toolbox
function Pop-EmailAddress
{
  <#
      .SYNOPSIS
      Simple extraction function for the email addresses out of a list from outlook.  Extracting the email addresses from a list of contacts

      .EXAMPLE
      'Desktop <a@mail>;Documents <b@mail>;Downloads <c@mail >; Favorites < d@mail >' | Pop-EmailAddress

      .EXAMPLE
      $Contacts = 'Desktop <a@mail>;Documents <b@mail>;Downloads <c@mail >; Favorites < d@mail >'
      Extract-Emails -Contacts $Contacts

      .NOTES
      Last week I needed to get everyone's email address as a semicolon separated list.

      I didn't want to waste time stripping off the names, spaces, special characters. So I expanded the email group in the Outlook "To" line.

      That gave me a group of contacts that looked like this:
      Desktop <a@mail>;Documents <b@mail>;Downloads <c@mail>;Favorites <d@mail>;Links <e@mail>;Music <f@mail>;OneDrive <g@mail>;Pictures <h@mail>;Saved Games<i@mail>;Searches
      <j@mail>;testfile<k@mail>

      .LINK
      https://github.com/OgJAkFy8/Friday-Power/blob/main/Pop-EmailAddresses.ps1

      .INPUTS
      String

      .OUTPUTS
      Array
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




