If (Get-Module ApplicationControl) { Remove-Module ApplicationControl}
Import-Module ApplicationControl -Verbose

$Folder = "C:\Users\aaron\AppData\Local\Microsoft\Teams", "C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin"

$Certs = Get-DigitalSignatures -Path $Folder -Unique -Verbose
$Unsigned = Get-DigitalSignatures.ps1 -Path $Folder -Verbose | Where-Object { $_.Status -eq "NotSigned" }
$Unsigned = Get-FileMetadata.ps1 -Verbose -Path $Unsigned.Path
New-AampConfiguration.ps1 -AccessibleFiles $Unsigned -AccessibleFolders $Certs -SignedFiles $Certs -Verbose