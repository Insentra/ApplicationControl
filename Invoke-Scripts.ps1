
$Folder = "C:\Users\aaron\AppData\Local\Microsoft\Teams", "C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin"
$Certs = . "\\Mac\Home\Documents\GitHub\ApplicationControl\Get-DigitalSignatures.ps1" -Path $Folder -Unique -Verbose
$Unsigned = . "\\Mac\Home\Documents\GitHub\ApplicationControl\Get-DigitalSignatures.ps1" -Path $Folder -Verbose | Where-Object { $_.Status -eq "NotSigned" }
$Unsigned = . "\\Mac\Home\Documents\GitHub\ApplicationControl\Get-FileMetadata.ps1" -Verbose -Path $Unsigned.Path
. "\\Mac\Home\Documents\GitHub\ApplicationControl\New-AampConfiguration.ps1" -AccessibleFiles $Unsigned -AccessibleFolders $Certs -SignedFiles $Certs -Verbose


