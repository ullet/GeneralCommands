# GeneralCommands

Simple Windows PowerShell Module of miscellaneous commands including:
* create and manage temporary directories
* set, update and delete environment variables

## How to install
1. Download master.zip for this repository
2. Extract the contents to a new folder named "GeneralCommands" inside your
   WindowsPowerShell\Modules folder.

## How to use

```PowerShell
Import-Module GeneralCommands

# Create new unique temporary directory
$tmpDir = New-TemporaryDirectory

# Get the path of the temporary directory
Write-Host $tmpDir.Path

# Clean up the temporary directory
$tmpDir.Delete()

# Path cleared after delete
if ($tmpDir.Path -eq $null)
{
  Write-Host 'Path is now $null'
}

# Delete again does nothing
$tmpDir.Delete()
if ($tmpDir.Path -eq $null)
{
  Write-Host 'Path is still $null'
}
```
