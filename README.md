# Application Control
Scripts for retreiving application information for application whitelisting

# Get-DigitalSignatures
Gets digital signatures from .exe and .dll files from a specified path and sub-folders. Retreives the certificate thumbprint, certificate name, certificate expiry, certificate validity and file path and outputs the results. Output includes files that are not signed.

# Get-FileMetadata
 Gets file metadata from files in a target folder. Returns file Path, Description, Product name, Company Name.

# New-AampConfiguration
Take the output from Get-FileMetadata and add file paths with metadata to the Accessible items in the Everyone group rule.
Makes it easier to create an application definition and copy into your working configuration.