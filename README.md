# Application Control

[![Build status](https://ci.appveyor.com/api/projects/status/bq59wmi4vd8h2uvq/branch/master?svg=true)](https://ci.appveyor.com/project/aaronparker/applicationcontrol/branch/master)

A module for retreiving application information for application control and white listing purposes with tools such as Ivanti Application Manager and Microsoft AppLocker.

## Module

This repository contains a folder named ApplicationControl. The folder needs to be installed into one of your PowerShell Module Paths. To see the full list of available PowerShell Module paths, use $env:PSModulePath.split(';') in a PowerShell console.

Common PowerShell module paths include:

* Current User: `%USERPROFILE%\Documents\WindowsPowerShell\Modules\`
* All Users: `%ProgramFiles%\WindowsPowerShell\Modules\`
* OneDrive: `$env:OneDrive\Documents\WindowsPowerShell\Modules\`

### Manual Installation

1. Download the `master branch` to your workstation.
2. Copy the contents of the ApplicationControl folder onto your workstation into the desired PowerShell Module path.
3. Open a Powershell console with the Run as Administrator option.
4. Run `Set-ExecutionPolicy` using the parameter `RemoteSigned` or `Bypass`.

Once installation is complete, you can validate that the module exists by running `Get-Module -ListAvailable ApplicationControl`. To use the module, load it with:

    Import-Module ApplicationControl

## Example

Here is an example using the module to create an Ivanti Application Control configuration for Microsoft Teams. This application uses the [Electron](https://electronjs.org/) framework and [Squirell](https://electronjs.org/docs/api/auto-updater) for in process updates, making white listing a challenge because the application installs and updates in the user profile and in the user context. This example trawls the application folders and find unique metadata to turn into an Ivanti Application Control configuration using RegEx paths to simplify the configuration as much as possible.

```powershell
Import-Module ApplicationControl -Force -Verbose
$Path = "C:\Users\aaron\AppData\Local\Microsoft\Teams", "C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin"
$Files = @()
ForEach ($Folder in $Path) {
    $AppFiles = Get-AcFileMetadata -Verbose -Path $Folder -Include '*.exe', '*.dll', '*.ocx'
    $NoMetadata = $AppFiles | Where-Object { $_.Vendor -le 1 -and $_.Company -le 1 -and $_.Product -le 1 -and $_.Description -le 1 }
    $Metadata = $AppFiles | Where-Object { $_.Vendor -gt 1 -or $_.Company -gt 1 -or $_.Product -gt 1 -or $_.Description -gt 1 }
    $UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata -Verbose
    $RegExFiles = ConvertTo-RegExPath -Files $UniqueFiles -Path $Folder -Verbose
    $Files += $NoMetadata
    $Files += $RegExFiles
    Remove-Variable AppFiles, NoMetadata, Metadata, UniqueFiles, RegExFiles
}
New-AcAampConfiguration -AccessibleFiles $Files -Path C:\Temp\MicrosoftTeams.aamp -RegEx -Verbose
Remove-Variable AppFiles, NoMetadata, Metadata, UniqueFiles, RegExFiles, Files
```