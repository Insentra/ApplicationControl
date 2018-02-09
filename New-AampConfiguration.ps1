Function New-AampConfiguration {
  <#
.SYNOPSIS
  Creates an Ivanti Application Control configuration from an array of inputs.
    
.DESCRIPTION
  Works with Get-DigitalSignatures and Get-FileMetadata to create an Ivanti Application Control configuration.
  Intended for making it easier to define an application and create a rule set automatically for copying into a detailed configuration.

  Adds Accessible files with metadata to the Everyone group rule.

.NOTES
  Name: New-AampConfiguration.ps1
  Author: Aaron Parker
  Twitter: @stealthpuppy

.LINK
  http://stealthpuppy.com

.OUTPUTS
  [System.Array]

.PARAMETER AccessibleFiles

.EXAMPLE
  .\New-AampConfiguration.ps1 -AccessibleFiles $Files -Path "C:\Temp\Configuration.aamp"

  Description:
  Adds files and metadata in the array $Files to a new Application Control configuration at "C:\Temp\Configuration.aamp".
#>
  [CmdletBinding(SupportsShouldProcess = $False)]
  Param (
      [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True, `
              HelpMessage = 'Specify the array of accessible files with metadata to add.')]
      [array]$AccessibleFiles,

      [Parameter(Mandatory = $False, Position = 1, ValueFromPipeline = $False, `
              HelpMessage = 'Specify a path to the configuration to output.')]
      [string]$Path = "C:\Temp\Configuration.aamp"
  )

  Begin {
      # Variables
      $GroupRule = "Everyone"

      Function ConvertTo-EnvironmentPath {
          <#
      .SYNOPSIS
        Replaces strings in a file path with environment variables.
    #>
          Param (
              [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $False)]
              [string]$Path
          )
          $RegExLocalAppData = "^[a-zA-Z]:\\Users\\.*\\AppData\\Local\\"
          $RegExAppData = "^[a-zA-Z]:\\Users\\.*\\AppData\\Roaming\\"
          $RegExTemp = "^[a-zA-Z]:\\Users\\.*\\AppData\\Local\\Temp\\"
          $RegExProgramData = "^[a-zA-Z]:\\ProgramData\\"
          $RegExProgramFiles = "^[a-zA-Z]:\\Program Files\\"
          $RegExProgramFilesx86 = "^[a-zA-Z]:\\Program Files (x86)\\"
          $RegExSystemRoot = "^[a-zA-Z]:\\Windows\\"
          $RegExPublic = "^[a-zA-Z]:\\Users\\Public\\"
  
          Switch -Regex ($Path) {
              { $_ -match $RegExLocalAppData } { $Path = $Path -replace $RegExLocalAppData, "%LOCALAPPDATA%\" }
              { $_ -match $RegExAppData } { $Path = $Path -replace $RegExAppData, "%APPDATA%\" }
              { $_ -match $RegExTemp } { $Path = $Path -replace $RegExRoamingAppData, "%TEMP%\" }
              { $_ -match $RegExProgramData } { $Path = $Path -replace $RegExProgramData, "%ProgramData%\" }
              { $_ -match $RegExProgramFiles } { $Path = $Path -replace $RegExProgramFiles, "%ProgramFiles%\" }
              { $_ -match $RegExProgramFilesx86 } { $Path = $Path -replace $RegExProgramFilesx86, "%ProgramFiles(x86)%\" }
              { $_ -match $RegExSystemRoot } { $Path = $Path -replace $RegExSystemRoot, "%SystemRoot%\" }
              { $_ -match $RegExPublic } { $Path = $Path -replace $RegExPublic, "%PUBLIC%\" }
          }
          $Path
      }

      # Create the configuration; Create the configuration helper
      Write-Verbose "Loading object 'AM.Configuration.5'."
      Try { $Configuration = New-Object -ComObject 'AM.Configuration.5' -ErrorAction SilentlyContinue } Catch { Throw "Unable to load COM Object 'AM.Configuration.5'" }
      Write-Verbose "Loading object 'AM.ConfigurationHelper.1'."
      Try { $ConfigurationHelper = New-Object -ComObject 'AM.ConfigurationHelper.1' -ErrorAction SilentlyContinue } Catch { Throw "Unable to load COM Object 'AM.ConfigurationHelper.1'" }

      # Create default configuration
      $ConfigurationXml = $ConfigurationHelper.DefaultConfiguration
      $Configuration.ParseXML($ConfigurationXml)
  }
  Process {
      ForEach ($file in $AccessibleFiles) {
          # Add a file to the list of accessible files.
          Write-Verbose "Adding $(ConvertTo-EnvironmentPath -Path $file.Path)"
          $AccessibleFile = $Configuration.CreateInstanceFromClassName("AM.File")
          $AccessibleFile.Path = $(ConvertTo-EnvironmentPath -Path $file.Path)
          $AccessibleFile.CommandLine = $(ConvertTo-EnvironmentPath -Path $file.Path)
          $AccessibleFile.Description = $file.Description
          $AccessibleFile.Metadata.CompanyName = $file.Company
          $AccessibleFile.Metadata.CompanyNameEnabled = $True
          $AccessibleFile.Metadata.ProductName = $file.Product
          $AccessibleFile.Metadata.ProductNameEnabled = $True
          $AccessibleFile.Metadata.FileDescription = $file.Description
          $AccessibleFile.Metadata.FileDescriptionEnabled = $True  
          $Configuration.GroupRules.Item($GroupRule).AccessibleFiles.Add($AccessibleFile.Xml()) | Out-Null
          Remove-Variable AccessibleFile
      }
  }
  End {
      Write-Verbose "Saving configuration to: $Path"
      $ConfigurationHelper.SaveLocalConfiguration($Path, $Configuration.Xml())
      $Path
  }
}