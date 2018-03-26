<#
    .SYNOPSIS
        Sample commands for creating white listing for Ivanti Application Control.
#>

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

# Micrsosoft Teams
$Path = "C:\Users\aaron\AppData\Local\Microsoft\Teams", "C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin"
$Files = @()
ForEach ($Folder in $Path) {
    $AppFiles = Get-AcFileMetadata -Verbose -Path $Folder
    $NoMetadata = $AppFiles | Where-Object { $_.Vendor -le 1 -and $_.Company -le 1 -and $_.Product -le 1 -and $_.Description -le 1 }
    $Metadata = $AppFiles | Where-Object { $_.Vendor -gt 1 -or $_.Company -gt 1 -or $_.Product -gt 1 -or $_.Description -gt 1 }
    $UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata -Verbose
    $RegExFiles = ConvertTo-RegExPath -Files $UniqueFiles -Path $Folder -Verbose
    $Files += $NoMetadata
    $Files += $RegExFiles
    Remove-Variable AppFiles, NoMetadata, Metadata, UniqueFiles, RegExFiles
}
New-AcAampConfiguration -AccessibleFiles $Files -Path C:\Temp\MicrosoftTeams.aamp -RegEx -Verbose

#Slack
$Path = "C:\Users\aaron\AppData\Local\Slack"
$Files = @()
ForEach ($Folder in $Path) {
    $AppFiles = Get-AcFileMetadata -Verbose -Path $Folder
    $NoMetadata = $AppFiles | Where-Object { $_.Vendor -le 1 -and $_.Company -le 1 -and $_.Product -le 1 -and $_.Description -le 1 }
    $Metadata = $AppFiles | Where-Object { $_.Vendor -gt 1 -or $_.Company -gt 1 -or $_.Product -gt 1 -or $_.Description -gt 1 }
    $UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata -Verbose
    $RegExFiles = ConvertTo-RegExPath -Files $UniqueFiles -Path $Folder -Verbose
    $Files += $NoMetadata
    $Files += $RegExFiles
    Remove-Variable AppFiles, NoMetadata, Metadata, UniqueFiles, RegExFiles
}
New-AcAampConfiguration -AccessibleFiles $Files -Path C:\Temp\Slack.aamp -RegEx -Verbose

$Path = "C:\Users\aaron\AppData\Local\Microsoft\OneDrive"
$Path = "C:\Users\aaron\AppData\Local\SourceTree", "C:\Users\aaron\AppData\Local\Atlassian"
$Path = "C:\Users\aaron\AppData\Local\GitHubDesktop"
$Path = "C:\Users\aaron\AppData\Local\yammerdesktop"
$Files = @()
ForEach ($Folder in $Path) {
    $AppFiles = Get-AcFileMetadata -Verbose -Path $Folder
    $NoMetadata = $AppFiles | Where-Object { $_.Vendor -le 1 -and $_.Company -le 1 -and $_.Product -le 1 -and $_.Description -le 1 }
    $Metadata = $AppFiles | Where-Object { $_.Vendor -gt 1 -or $_.Company -gt 1 -or $_.Product -gt 1 -or $_.Description -gt 1 }
    $UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata -Verbose
    $RegExFiles = ConvertTo-RegExPath -Files $UniqueFiles -Path $Folder -Verbose
    $Files += $NoMetadata
    $Files += $RegExFiles
    Remove-Variable AppFiles, NoMetadata, Metadata, UniqueFiles, RegExFiles
}
New-AcAampConfiguration -AccessibleFiles $Files -Path C:\Temp\Yammer.aamp -RegEx -Verbose


# ----------
$Values = @(" ", "", $Null)
$Less = $Files | Where-Object {
    ($Values -contains $_.Vendor) -or `
    ($Values -contains $_.Company) -or `
    ($Values -contains $_.Product) -or `
    ($Values -contains $_.Description)
}
$NoMetadata = $Files | Where-Object {
    ($Values -contains $_.Vendor) -and `
    ($Values -contains $_.Company) -and `
    ($Values -contains $_.Product) -and `
    ($Values -contains $_.Description)
}
$Metadata = $Files | Where-Object {
    ($Values -notcontains $_.Vendor) -and `
    ($Values -notcontains $_.Company) -and `
    ($Values -notcontains $_.Product) -and `
    ($Values -notcontains $_.Description)
}

$String = "C:\Users\aaron\AppData\Local\Microsoft\Teams\current\resources\meeting-addin\1.0.17306.2\x64\Microsoft.Applications.Telemetry.Windows.dll"
$Version = "\bv?[0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)?\b"
$String -replace $Version, "*"