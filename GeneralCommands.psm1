# GeneralCommands - A collection of miscellaneous PowerShell commands.
#                   Including commands to:
#                   - Create temporary directory
#                   - Get/Set environment variables

# Copyright (c) 2015, 2016 Trevor Barnett <mr.ullet@gmail.com>
# Released under terms of the MIT License.  See LICENSE for details.

function New-TemporaryDirectory {
param (
  $tempRoot = $env:temp
)
  return New-Module -AsCustomObject -ScriptBlock {
    param (
      $tempRoot
    )

    function Create
    {
      do
      {
        $path = Join-Path $tempRoot ('{' + [guid]::NewGuid() + '}')
      }
      while (Test-Path $path) # just in case already exists
      New-Item -ItemType Container $path | Out-Null
      return $path
    }

    function Delete
    {
      # Only delete temp dirs but not the root temp directory.
      if ($this.Path -ne $null -and
          $this.Path -ne $tempRoot -and
          $this.Path.StartsWith($tempRoot))
      {
        Remove-Item -Path $this.Path -Recurse -Force
      }
      Clear-Variable Path -Scope Script -Force
    }

    $tempRoot = $tempRoot.Trim()

    Set-Variable Path (Create) -option ReadOnly

    Export-ModuleMember -Variable Path
    Export-ModuleMember Delete
  } -ArgumentList $tempRoot
}

function Clear-EnvironmentVariable {
param (
  [Parameter(Mandatory = $true)]
  [String] $Variable,
  [EnvironmentVariableTarget] $Target = [EnvironmentVariableTarget]::Process
)
  $Target | ForEach-Object {
    [Environment]::SetEnvironmentVariable($Variable, $null, $_)
  }
}

function Get-EnvironmentVariable {
param (
  [Parameter(Mandatory = $true)]
  [String] $Variable,
  [EnvironmentVariableTarget] $Target = [EnvironmentVariableTarget]::Process
)
  [Environment]::GetEnvironmentVariable($Variable, $Target)
}

function New-EnvironmentVariable {
param (
  [Parameter(Mandatory = $true)]
  [String] $Variable,
  [Parameter(Mandatory = $true)]
  [String] $Value,
  [EnvironmentVariableTarget[]] $Target = [EnvironmentVariableTarget]::Process
)
  # Do not set variable for any target if already exists for even one target
  $Target | ForEach-Object {
    if (Get-EnvironmentVariable $Variable $_) {
      throw "Environment variable '$Variable' already set for target " +
            "'$Target'. Use Set-EnvironmentVariable where variable exists " +
            "or may already exist."
    }
  }
  Set-EnvironmentVariable $Variable $Value $Target
}

function Set-EnvironmentVariable {
param (
  [Parameter(Mandatory = $true)]
  [String] $Variable,
  [Parameter(Mandatory = $true)]
  [String] $Value,
  [EnvironmentVariableTarget[]] $Target = [EnvironmentVariableTarget]::Process
)
  $Target | ForEach-Object {
    [Environment]::SetEnvironmentVariable($Variable, $Value, $_)
  }
}

Export-ModuleMember New-TemporaryDirectory
Export-ModuleMember Clear-EnvironmentVariable
Export-ModuleMember Get-EnvironmentVariable
Export-ModuleMember New-EnvironmentVariable
Export-ModuleMember Set-EnvironmentVariable
