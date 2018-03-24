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
$UniqueFiles = $UniqueFiles | ConvertTo-RegExPath -Path $Path
$UniqueFiles += $NoMetadata
$UniqueFiles | New-AcAampConfiguration -Path C:\Temp\Configuration.aamp -Verbose -RegEx


#Slack
$Path = "C:\Users\aaron\AppData\Local\Slack"
$Files = Get-AcFileMetadata -Verbose -Path $Path -Include '*.exe', '*.dll'
$NoMetadata = $Files | Where-Object { $_.Vendor -le 1 -and $_.Company -le 1 -and $_.Product -le 1 -and $_.Description -le 1 }
$Metadata = $Files | Where-Object { $_.Vendor -gt 1 -or $_.Company -gt 1 -or $_.Product -gt 1 -or $_.Description -gt 1 }
$UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata
$UniqueFiles = $UniqueFiles | ConvertTo-RegExPath -Path $Path
$UniqueFiles += $NoMetadata
$UniqueFiles | New-AcAampConfiguration -Path C:\Temp\Configuration.aamp -Verbose -RegEx