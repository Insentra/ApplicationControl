If (Get-Module ApplicationControl) { Remove-Module ApplicationControl}
Import-Module ApplicationControl -Force -Verbose

# HP Quality Center
$Path = "C:\Users\aparker\AppData\Local\HP", "C:\ProgramData\HP"
$UniqueFiles | ForEach { $_.Path  = $_.Path -replace "hostname", "*" }

# Micrsosoft Teams
$Path = "C:\Users\aaron\AppData\Local\Microsoft\Teams", "C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin"
$Files = Get-AcFileMetadata -Verbose -Path $Path -Include '*.exe', '*.dll', '*.ocx'
$NoMetadata = $Files | Where-Object { $_.Vendor -le 1 -and $_.Company -le 1 -and $_.Product -le 1 -and $_.Description -le 1 }
$Metadata = $Files | Where-Object { $_.Vendor -gt 1 -or $_.Company -gt 1 -or $_.Product -gt 1 -or $_.Description -gt 1 }
$UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata
For ($i = 0; $i -le ($UniqueFiles.Count - 1); $i++) {
	$Type = Split-Path $UniqueFiles[$i].Path -Leaf
	Switch ($Type.Substring($Type.Length - 4).ToLower()) {
		".dll" { $UniqueFiles[$i].Path = "$($Path)\\.*\\*.dll" }
		".exe" { $UniqueFiles[$i].Path = "$($Path)\\.*\\*.exe" }
		".ocx" { $UniqueFiles[$i].Path = "$($Path)\\.*\\*.ocx" }
	}
	$UniqueFiles[$i].Path = ConvertTo-EnvironmentPath -Path $UniqueFiles[$i].Path
}
$UniqueFiles | ForEach { $_.Path = $_.Path -replace [regex]::escape('%LOCALAPPDATA%\Microsoft\Teams'), [regex]::escape('%LOCALAPPDATA%\Microsoft\Teams') }
$UniqueFiles += $NoMetadata
$UniqueFiles | New-AcAampConfiguration -Path C:\Temp\Configuration.aamp -Verbose -RegEx


#Slack
$Path = "C:\Users\aaron\AppData\Local\Slack"
$Files = Get-AcFileMetadata -Verbose -Path $Path -Include '*.exe', '*.dll'
$NoMetadata = $Files | Where-Object { $_.Vendor -le 1 -and $_.Company -le 1 -and $_.Product -le 1 -and $_.Description -le 1 }
$Metadata = $Files | Where-Object { $_.Vendor -gt 1 -or $_.Company -gt 1 -or $_.Product -gt 1 -or $_.Description -gt 1 }
$UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata
For ($i = 0; $i -le ($UniqueFiles.Count - 1); $i++) {
	$Type = Split-Path $UniqueFiles[$i].Path -Leaf
	Switch ($Type.Substring($Type.Length - 4).ToLower()) {
		".dll" { $UniqueFiles[$i].Path = "$($Path)\\.*\\*.dll" }
		".exe" { $UniqueFiles[$i].Path = "$($Path)\\.*\\*.exe" }
	}
	$UniqueFiles[$i].Path = ConvertTo-EnvironmentPath -Path $UniqueFiles[$i].Path
}
$UniqueFiles | ForEach { $_.Path = $_.Path -replace [regex]::escape('%LOCALAPPDATA%\Microsoft\Teams'), [regex]::escape('%LOCALAPPDATA%\Microsoft\Teams') }
$UniqueFiles += $NoMetadata
$UniqueFiles | New-AcAampConfiguration -Path C:\Temp\Configuration.aamp -Verbose -RegEx