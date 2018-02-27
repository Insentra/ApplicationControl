If (Get-Module ApplicationControl) { Remove-Module ApplicationControl}
Import-Module ApplicationControl -Verbose

$Folder = "C:\Users\aaron\AppData\Local\Microsoft\Teams", "C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin"

$Certs = Get-AcDigitalSignature -Path $Folder -Unique -Verbose
$Unsigned = Get-AcDigitalSignature -Path $Folder -Verbose | Where-Object { $_.Status -eq "NotSigned" }
$Unsigned = Get-AcFileMetadata -Verbose -Path $Unsigned.Path
New-AcAampConfiguration -AccessibleFiles $Unsigned -AccessibleFolders $Certs -SignedFiles $Certs -Verbose