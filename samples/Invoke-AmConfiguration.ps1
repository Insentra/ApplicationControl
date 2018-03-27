# Requires -RunAsAdministrator
<#
    .SYNOPSIS
        Sample commands for creating white listing for Ivanti Application Control.
#>

If (Get-Module ApplicationControl) { Remove-Module ApplicationControl}
Import-Module ApplicationControl -Force -Verbose

# App paths
Import-Module "C:\Users\aaparker\Documents\WindowsPowerShell\ApplicationControl\ApplicationControl" -Force -Verbose

$Path = @("C:\Users\aaparker\AppData\Local\Microsoft\Teams", "C:\Users\aaparker\AppData\Local\Microsoft\TeamsMeetingAddin")
$Path = @("C:\Users\aaparker\AppData\Local\Slack")
$Path = @("C:\Users\aaparker\AppData\Local\Microsoft\OneDrive")
$Path = @("C:\Users\aaparker\AppData\Local\SourceTree", "C:\Users\aaparker\AppData\Local\Atlassian")
$Path = @("C:\Users\aaparker\AppData\Local\GitHubDesktop")
$Path = @("C:\Users\aaparker\AppData\Local\yammerdesktop")
$Path = @("C:\Users\aaparker\AppData\Local\HP", "C:\ProgramData\HP")
$Path = @("C:\Users\aaparker\AppData\Local\Google")
$Path = @("C:\Users\aaparker\AppData\Local\GoToMeeting", "C:\Users\aaparker\AppData\Local\GoTo Opener")

# Create configuration
$Version = "\bv?[0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)?\b"
$Values = @(" ", "", $Null)
$Files = @()

ForEach ($Folder in $Path) {
    $AppFiles = Get-AcFileMetadata -Verbose -Path $Folder
    $NoMetadata = $AppFiles | Where-Object {
        ($Values -contains $_.Vendor) -and `
        ($Values -contains $_.Company) -and `
        ($Values -contains $_.Product) -and `
        ($Values -contains $_.Description)
    }
    
    $NoMetadata | ForEach-Object { $_.Path  = $_.Path -replace "wpasqc01", "*" }
    $NoMetadata | ForEach-Object { $_.Path  = $_.Path -replace $Version, "*" }

    $Metadata = $AppFiles | Where-Object { $_.Vendor -gt 1 -or $_.Company -gt 1 -or $_.Product -gt 1 -or $_.Description -gt 1 }
    $UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata -Verbose
    $RegExFiles = ConvertTo-RegExPath -Files $UniqueFiles -Path $Folder -Verbose
    $Files += $NoMetadata
    $Files += $RegExFiles
}
New-AcAampConfiguration -AccessibleFiles $Files -Path "C:\Temp\Configs\$(Split-Path $Path[0] -Leaf).aamp" -Verbose
