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
$Path = @("C:\Users\aaparker\AppData\Roaming\Mozilla")

# Create configuration
$Version = "\bv?[0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)?\b"
$Files = @()
ForEach ($Folder in $Path) {
    $AppFiles = Get-AcFileMetadata -Verbose -Path $Folder
    
    $NoMetadata = $AppFiles | Where-Object { (Test-AcMetadata $_) -eq $False }
    $Metadata = $AppFiles | Where-Object { Test-AcMetadata $_ }
    
    $NoMetadata | ForEach-Object { $_.Path  = $_.Path -replace "<server>", "*" }
    $NoMetadata | ForEach-Object { $_.Path  = $_.Path -replace $Version, "*" }

    $UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata -Verbose
    $RegExFiles = ConvertTo-RegExPath -Files $UniqueFiles -Path $Folder -Verbose
    $Files += $NoMetadata
    $Files += $RegExFiles
}
New-AcAampConfiguration -AccessibleFiles $Files -Path "C:\Temp\Configs\$(Split-Path $Path[0] -Leaf).aamp" -Verbose