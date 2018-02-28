# Application Control

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

## Get-AcDigitalSignature

Gets digital signatures from .exe and .dll files from a specified path and sub-folders. Retreives the certificate thumbprint, certificate name, certificate expiry, certificate validity and file path and outputs the results. Output includes files that are not signed.

### Example

Return the unique certificates across all files in the folders defined in path. This allows us to easily see how many individual certificates are using in a specific application.

Running the script against a folder or set of folders with the following command will show all files and certificates on each signed file (with unsigned files shown as NotSigned).

    $Path = 'C:\Users\aaron\AppData\Local\Microsoft\Teams', 'C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin'
    Get-AcDigitalSignature -Path $Path | Out-GridView

![All files returned with Get-AcDigitalSignature](https://raw.githubusercontent.com/aaronparker/ApplicationControl/master/img/DigitalSignature-All.PNG "All files returned with Get-AcDigitalSignatures")

Running the same command with the -Unique we can return a list of unique certificates across all files.

    $Path = 'C:\Users\aaron\AppData\Local\Microsoft\Teams', 'C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin'
    Get-AcDigitalSignature -Path $Path -Unique | Out-GridView

![Unique certificates returned with Get-AcDigitalSignatures](https://raw.githubusercontent.com/aaronparker/ApplicationControl/master/img/DigitalSignature-Unique.PNG "Unique certificates returned with Get-AcDigitalSignatures")

Some files might not be signed, so we can filter the results to return all files that are not signed.

    $Path = 'C:\Users\aaron\AppData\Local\Microsoft\Teams', 'C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin'
    Get-AcDigitalSignature -Path $Path | Where-Object { $_.Status -eq "NotSigned" } | Out-GridView

![Files returned with Get-AcDigitalSignatures and filtered for unsigned files](https://raw.githubusercontent.com/aaronparker/ApplicationControl/master/img/DigitalSignature-NotSigned.PNG "Files returned with Get-AcDigitalSignatures and filtered for unsigned files")

## Get-AcFileMetadata

Gets file metadata from files in a target folder. Returns file Path, Description, Product name, Company Name.

### Example

In this example, we can return all file metadata for exe and dll files in the folders specified in the $Path variable. Using the output from the Get-AcDigitalSignatures function above, we can view metadata for all unsigned files.

    $Path = 'C:\Users\aaron\AppData\Local\Microsoft\Teams', 'C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin'
    Get-AcDigitalSignature -Path $Path | Where-Object { $_.Status -eq "NotSigned" } | Get-AcFileMetadata | Out-GridView

![Metadata returned for unsigned files filtered out of Get-AcDigitalSignatures](https://raw.githubusercontent.com/aaronparker/ApplicationControl/master/img/FileMetadata-NotSigned.PNG "Metadata returned for unsigned files filtered out of Get-AcDigitalSignatures")

## New-AcAampConfiguration

Take the output from Get-AcFileMetadata and add file paths with metadata to the Accessible items in the Everyone group rule.
Makes it easier to create an application definition and copy into your working configuration.

### Example

Microsoft Teams includes two application paths and most executables are signed; however, a number of DLLs are unsigned but do have identifying metadata. In this example we can retrieve a list of signed executables with Get-AcDigitalSignatures, but filter on those files that are not signed. We can then pass those files to Get-AcFileMetadata and input the data into a temp configuration with New-AcAampConfiguration.

    $Path = 'C:\Users\aaron\AppData\Local\Microsoft\Teams', 'C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin'
    $Files = Get-AcDigitalSignature -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-AcFileMetadata -Verbose
    $Files | New-AcAampConfiguration -Path C:\Temp\Configuration.aamp

Open the temporary configuration and copy and paste into your working config.

![File definitions imported into a temporary configuration](https://raw.githubusercontent.com/aaronparker/ApplicationControl/master/img/AampConfiguration.PNG "File definitions imported into a temporary configuration")

## To Do

* Update New-AcAampConfiguration to create folder rules with Vendor (or trust code-signing certificates for folders with signed executables)
* Enable sorting of file paths to determine common metadata so that white listing rules can be simplified
