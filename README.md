# Application Control
Scripts for retreiving application information for application whitelisting

# Get-DigitalSignatures
Gets digital signatures from .exe and .dll files from a specified path and sub-folders. Retreives the certificate thumbprint, certificate name, certificate expiry, certificate validity and file path and outputs the results. Output includes files that are not signed.

## Example
Return the unique certificates across all files in the folders defined in path. This allows us to easily see how many individual certificates are using in a specific application.

    $Path = 'C:\Users\aaparker\AppData\Local\Microsoft\Teams', 'C:\Users\aaparker\AppData\Local\Microsoft\TeamsMeetingAddin'
    Get-DigitalSignatures -Path $Path Unique -Verbose

# Get-FileMetadata
 Gets file metadata from files in a target folder. Returns file Path, Description, Product name, Company Name.

 ## Example
 In this example, we can return all file metadata for exe and dll files in the folders specified in the $Path variable

    $Path = 'C:\Users\aaparker\AppData\Local\Microsoft\Teams', 'C:\Users\aaparker\AppData\Local\Microsoft\TeamsMeetingAddin'
    $Path | Get-FileMetadata -Verbose | Out-GridView


# New-AampConfiguration
Take the output from Get-FileMetadata and add file paths with metadata to the Accessible items in the Everyone group rule.
Makes it easier to create an application definition and copy into your working configuration.

## Example
Microsoft Teams includes two application paths and most executables are signed; however, a number of DLLs are unsigned but do have identifying metadata assigned to them. In this example we can retrieve a list of signed executables with Get-DigitalSignatures, but filter on those files that are not signed. We can then pass those files to Get-FileMetadata and input the data into a temp configuration with New-AampConfiguration.

    $Path = 'C:\Users\aaparker\AppData\Local\Microsoft\Teams', 'C:\Users\aaparker\AppData\Local\Microsoft\TeamsMeetingAddin'
    $Files = Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose
    $Files | New-AampConfiguration -Path C:\Temp\Configuration.aamp -Verbose

# ToDo
Update New-AampConfiguration to create folder rules with Vendor (or trust code-signing certificates for folders with signed executables).