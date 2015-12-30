# TemporaryDirectory - Create temporary directory object that tracks the path
#                      created with Delete method to clean up.

# Copyright (c) 2015 Trevor Barnett <mr.ullet@gmail.com>
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

Export-ModuleMember New-TemporaryDirectory
