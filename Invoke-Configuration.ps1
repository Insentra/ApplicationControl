If (Get-Module ApplicationControl) { Remove-Module ApplicationControl}
Import-Module ApplicationControl -Verbose

# Microsoft Teams
$Folder = "C:\Users\aaron\AppData\Local\Microsoft\Teams", "C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin"
$Certs = Get-AcDigitalSignature -Path $Folder -Unique -Verbose
$Unsigned = Get-AcDigitalSignature -Path $Folder -Verbose | Where-Object { $_.Status -eq "NotSigned" }
$Unsigned = Get-AcFileMetadata -Verbose -Path $Unsigned.Path
New-AcAampConfiguration -AccessibleFiles $Unsigned -AccessibleFolders $Certs -SignedFiles $Certs -Verbose


# HP Quality Center
Import-Module ApplicationControl -Force -Verbose
$Path = "C:\Users\aparker\AppData\Local\HP", "C:\ProgramData\HP"
$Files = Get-AcFileMetadata -Verbose -Path $Path -Include '*.exe', '*.dll', '*.ocx'
$NoMetadata = $Files | Where-Object { $_.Vendor -le 1 -and $_.Company -le 1 -and $_.Product -le 1 -and $_.Description -le 1 }
$Metadata = $Files | Where-Object { $_.Vendor -gt 1 -or $_.Company -gt 1 -or $_.Product -gt 1 -or $_.Description -gt 1 }
$UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata
$UniqueFiles | ForEach { $_.Path  = $_.Path -replace "hostname", "*" }
$UniqueFiles | New-AcAampConfiguration -Path C:\Temp\Configuration.aamp -Verbose

# Working on getting RegEx paths, but does not add duplicate paths
For ($i = 0; $i -le ($UniqueFiles.Count - 1); $i++) {
	$Type = Split-Path $UniqueFiles[$i].Path -Leaf
	Switch ($Type.Substring($Type.Length - 4).ToLower()) {
		".dll" { $UniqueFiles[$i].Path = "$($Path)\\.*\\*.dll" }
		".exe" { $UniqueFiles[$i].Path = "$($Path)\\.*\\*.exe" }
	}
	$UniqueFiles[$i].Path = ConvertTo-EnvironmentPath -Path $UniqueFiles[$i].Path
}
$UniqueFiles | ForEach { $_.Path = $_.Path -replace [regex]::escape('%LOCALAPPDATA%\HP'), [regex]::escape('%LOCALAPPDATA%\HP') }
$UniqueFiles += $NoMetadata