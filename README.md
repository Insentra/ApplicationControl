# Application Control

A module for retrieving application information for application control and allow listing purposes with tools such as Ivanti Application Manager and Microsoft AppLocker.

## Module

This repository contains a folder named ApplicationControl. The folder needs to be installed into one of your PowerShell Module Paths. To see the full list of available PowerShell Module paths, use `$env:PSModulePath.split(';')` in a PowerShell console.

Common PowerShell module paths include:

* Current User: `%USERPROFILE%\Documents\WindowsPowerShell\Modules\`
* All Users: `%ProgramFiles%\WindowsPowerShell\Modules\`
* OneDrive: `$env:OneDrive\Documents\WindowsPowerShell\Modules\`

### Manual Installation

1. Download the `master branch` to your workstation.
2. Copy the contents of the ApplicationControl folder onto your workstation into the desired PowerShell Module path.
3. Open a Powershell console with the Run as Administrator option.
4. Run [`Set-ExecutionPolicy`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6) using the parameter `RemoteSigned` or `Bypass`.

Once installation is complete, you can validate that the module exists by running `Get-Module -ListAvailable ApplicationControl`. To use the module when it is located in one of the locations above, load it with:

```powershell
Import-Module ApplicationControl
```

The module can be loaded from a specific path if it is not in one of the default locations:

```powershell
Import-Module C:\Temp\ApplicationControl
```

## Examples

### Ivanti Application Control

Here is an example using the module to create an Ivanti Application Control configuration for Microsoft Teams. This application uses the [Electron](https://electronjs.org/) framework and [Squirell](https://electronjs.org/docs/api/auto-updater) for in process updates, making allow listing a challenge because the application installs and updates in the user profile and in the user context. This example trawls the application folders and find unique metadata to turn into an Ivanti Application Control configuration using RegEx paths to simplify the configuration as much as possible.

```powershell
Import-Module ApplicationControl -Force
$Path = "C:\Users\aaron\AppData\Local\Microsoft\Teams", "C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin"
$Files = @()
foreach ($Folder in $Path) {
    $AppFiles = Get-AcFileMetadata -Verbose -Path $Folder
    $UniqueFiles = Select-AcUniqueMetadata -FileList $AppFiles -Verbose
    $RegExFiles = ConvertTo-RegExPath -Files $UniqueFiles -Path $Folder -Verbose
    $Files += $RegExFiles
    Remove-Variable AppFiles, NoMetadata, Metadata, UniqueFiles, RegExFiles
}
New-AcAampConfiguration -AccessibleFiles $Files -Path C:\Temp\MicrosoftTeams.aamp -Verbose
```
