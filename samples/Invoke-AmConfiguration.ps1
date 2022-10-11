# Requires -RunAsAdministrator
<#
    .SYNOPSIS
        Sample commands for creating white listing for Ivanti Application Control.
#>

if (Get-Module ApplicationControl) { Remove-Module ApplicationControl }
Import-Module ApplicationControl -Force -Verbose

# App paths
Import-Module "C:\Users\aaron\Documents\WindowsPowerShell\ApplicationControl\ApplicationControl" -Force -Verbose

$Path = @("C:\Users\aaron\AppData\Local\Microsoft\Teams", "C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin")
$Path = @("C:\Users\aaron\AppData\Local\Slack")
$Path = @("C:\Users\aaron\AppData\Local\Microsoft\OneDrive")
$Path = @("C:\Users\aaron\AppData\Local\SourceTree", "C:\Users\aaron\AppData\Local\Atlassian")
$Path = @("C:\Users\aaron\AppData\Local\GitHubDesktop")
$Path = @("C:\Users\aaron\AppData\Local\yammerdesktop")
$Path = @("C:\Users\aaron\AppData\Local\HP", "C:\ProgramData\HP")
$Path = @("C:\Users\aaron\AppData\Local\Google")
$Path = @("C:\Users\aaron\AppData\Local\GoToMeeting", "C:\Users\aaron\AppData\Local\GoTo Opener")
$Path = @("C:\Users\aaron\AppData\Roaming\Mozilla")

# Create configuration
# RegEx to find version numbers in strings
$Version = "\bv?[0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)?\b"
$Files = @()
foreach ($Folder in $Path) {
    # Get all executables in the target folder/s and available metadata
    $AppFiles = Get-AcFileMetadata -Verbose -Path $Folder
    
    # Split into two arrays - file with and without metadata
    $NoMetadata = $AppFiles | Where-Object { (Test-AcMetadata $_) -eq $False }
    $Metadata = $AppFiles | Where-Object { Test-AcMetadata $_ }
    
    # Update path strings in no metadata replace specific strings, version numbers etc.
    $NoMetadata | ForEach-Object { $_.Path = $_.Path -replace "<server>", "*" }
    $NoMetadata | ForEach-Object { $_.Path = $_.Path -replace $Version, "*" }

    # Filter for files with unique metadata and turn the paths into a RegEx to account for multiple files
    $UniqueFiles = Select-AcUniqueMetadata -FileList $Metadata -Verbose
    $RegExFiles = ConvertTo-RegExPath -Files $UniqueFiles -Path $Folder -Verbose

    # Add the arrays together
    $Files += $NoMetadata
    $Files += $RegExFiles
}
# Create the Application Control configuration
New-AcAampConfiguration -AccessibleFiles $Files -Path "C:\Temp\Configs\$(Split-Path $Path[0] -Leaf).aamp" -Verbose
