# Application Control
Scripts for retreiving application information for application whitelisting


## Get-DigitalSignatures
Gets digital signatures from .exe and .dll files from a specified path and sub-folders. Retreives the certificate thumbprint, certificate name, certificate expiry, certificate validity and file path and outputs the results. Output includes files that are not signed.

### Example
Return the unique certificates across all files in the folders defined in path. This allows us to easily see how many individual certificates are using in a specific application.

Running the script against a folder or set of folders with the following command will show all files and certificates on each signed file (with unsigned files shown as NotSigned).

    $Path = 'C:\Users\aaron\AppData\Local\Microsoft\Teams', 'C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin'
    Get-DigitalSignatures -Path $Path | Out-GridView

![All files returned with Get-DigitalSignatures](https://raw.githubusercontent.com/aaronparker/ApplicationControl/master/img/DigitalSignature-All.PNG "All files returned with Get-DigitalSignatures")

Running the same command with the -Unique we can return a list of unique certificates across all files.

    $Path = 'C:\Users\aaron\AppData\Local\Microsoft\Teams', 'C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin'
    Get-DigitalSignatures -Path $Path -Unique | Out-GridView

![Unique certificates returned with Get-DigitalSignatures](https://raw.githubusercontent.com/aaronparker/ApplicationControl/master/img/DigitalSignature-Unique.PNG "Unique certificates returned with Get-DigitalSignatures")

Some files might not be signed, so we can filter the results to return all files that are not signed.

    $Path = 'C:\Users\aaron\AppData\Local\Microsoft\Teams', 'C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin'
    Get-DigitalSignatures -Path $Path | Where-Object { $_.Status -eq "NotSigned" } | Out-GridView

![Files returned with Get-DigitalSignatures and filtered for unsigned files](https://raw.githubusercontent.com/aaronparker/ApplicationControl/master/img/DigitalSignature-NotSigned.PNG "Files returned with Get-DigitalSignatures and filtered for unsigned files")

## Get-FileMetadata
 Gets file metadata from files in a target folder. Returns file Path, Description, Product name, Company Name.

### Example
 In this example, we can return all file metadata for exe and dll files in the folders specified in the $Path variable. Using the output from the Get-DigitalSignatures function above, we can view metadata for all unsigned files.

    $Path = 'C:\Users\aaron\AppData\Local\Microsoft\Teams', 'C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin'
    Get-DigitalSignatures -Path $Path | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata | Out-GridView

![Metadata returned for unsigned files filtered out of Get-DigitalSignatures](https://raw.githubusercontent.com/aaronparker/ApplicationControl/master/img/FileMetadata-NotSigned.PNG "Metadata returned for unsigned files filtered out of Get-DigitalSignatures")

## New-AampConfiguration
Take the output from Get-FileMetadata and add file paths with metadata to the Accessible items in the Everyone group rule.
Makes it easier to create an application definition and copy into your working configuration.

### Example
Microsoft Teams includes two application paths and most executables are signed; however, a number of DLLs are unsigned but do have identifying metadata. In this example we can retrieve a list of signed executables with Get-DigitalSignatures, but filter on those files that are not signed. We can then pass those files to Get-FileMetadata and input the data into a temp configuration with New-AampConfiguration.

    $Path = 'C:\Users\aaron\AppData\Local\Microsoft\Teams', 'C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin'
    $Files = Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose
    $Files | New-AampConfiguration -Path C:\Temp\Configuration.aamp

Open the temporary configuration and copy and paste into your working config.

![File definitions imported into a temporary configuration](https://raw.githubusercontent.com/aaronparker/ApplicationControl/master/img/AampConfiguration.PNG "File definitions imported into a temporary configuration")

## ToDo
Update New-AampConfiguration to create folder rules with Vendor (or trust code-signing certificates for folders with signed executables).
