If (Get-Module ApplicationControl) { Remove-Module ApplicationControl}
Import-Module ApplicationControl -Force -Verbose

# HP Quality Center
$Path = "C:\Users\aparker\AppData\Local\HP", "C:\ProgramData\HP"
$Files = @()
ForEach ($Folder in $Path) {
    $AppFiles = Get-AcFileMetadata -Verbose -Path $Folder -Include '*.exe', '*.dll', '*.ocx'
    $NoMetadata = $AppFiles | Where-Object { $_.Vendor -le 1 -and $_.Company -le 1 -and $_.Product -le 1 -and $_.Description -le 1 }
    $Metadata = $AppFiles | Where-Object { $_.Vendor -gt 1 -or $_.Company -gt 1 -or $_.Product -gt 1 -or $_.Description -gt 1 }
    $UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata -Verbose
    $RegExFiles = ConvertTo-RegExPath -Files $UniqueFiles -Path $Folder -Verbose
    $Files += $NoMetadata
    $Files += $RegExFiles
    Remove-Variable AppFiles, NoMetadata, Metadata, UniqueFiles, RegExFiles
}
New-AcAampConfiguration -AccessibleFiles $Files -Path C:\Temp\HPQC.aamp -RegEx -Verbose
Remove-Variable AppFiles, NoMetadata, Metadata, UniqueFiles, RegExFiles, Files

# Micrsosoft Teams
$Path = "C:\Users\aaron\AppData\Local\Microsoft\Teams", "C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin"
$Files = @()
ForEach ($Folder in $Path) {
    $AppFiles = Get-AcFileMetadata -Verbose -Path $Folder -Include '*.exe', '*.dll', '*.ocx'
    $NoMetadata = $AppFiles | Where-Object { $_.Vendor -le 1 -and $_.Company -le 1 -and $_.Product -le 1 -and $_.Description -le 1 }
    $Metadata = $AppFiles | Where-Object { $_.Vendor -gt 1 -or $_.Company -gt 1 -or $_.Product -gt 1 -or $_.Description -gt 1 }
    $UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata -Verbose
    $RegExFiles = ConvertTo-RegExPath -Files $UniqueFiles -Path $Folder -Verbose
    $Files += $NoMetadata
    $Files += $RegExFiles
    Remove-Variable AppFiles, NoMetadata, Metadata, UniqueFiles, RegExFiles
}
New-AcAampConfiguration -AccessibleFiles $Files -Path C:\Temp\MicrosoftTeams.aamp -RegEx -Verbose
Remove-Variable AppFiles, NoMetadata, Metadata, UniqueFiles, RegExFiles, Files

#Slack
$Path = "C:\Users\aaron\AppData\Local\Slack"
$Files = @()
ForEach ($Folder in $Path) {
    $AppFiles = Get-AcFileMetadata -Verbose -Path $Folder -Include '*.exe', '*.dll', '*.ocx'
    $NoMetadata = $AppFiles | Where-Object { $_.Vendor -le 1 -and $_.Company -le 1 -and $_.Product -le 1 -and $_.Description -le 1 }
    $Metadata = $AppFiles | Where-Object { $_.Vendor -gt 1 -or $_.Company -gt 1 -or $_.Product -gt 1 -or $_.Description -gt 1 }
    $UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata -Verbose
    $RegExFiles = ConvertTo-RegExPath -Files $UniqueFiles -Path $Folder -Verbose
    $Files += $NoMetadata
    $Files += $RegExFiles
    Remove-Variable AppFiles, NoMetadata, Metadata, UniqueFiles, RegExFiles
}
New-AcAampConfiguration -AccessibleFiles $Files -Path C:\Temp\Slack.aamp -RegEx -Verbose
Remove-Variable AppFiles, NoMetadata, Metadata, UniqueFiles, RegExFiles, Files