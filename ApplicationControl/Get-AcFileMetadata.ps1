# Requires -Version 2
Function Get-AcFileMetadata {
    <#
        .SYNOPSIS
            Get file metadata from files in a target folder.
        
        .DESCRIPTION
            Retreives file metadata from files in a target path, or file paths, to display information on the target files.
            Useful for understanding application files and identifying metadata stored in them. Enables the administrator to view metadata for application control scenarios.

        .NOTES
            Name: Get-FileMetadata.ps1
            Author: Aaron Parker
            Twitter: @stealthpuppy
        
        .LINK
            https://stealthpuppy.com

        .OUTPUTS
            [System.Array]

        .PARAMETER Path
            A target path in which to scan files for metadata.

        .PARAMETER Include
            Gets only the specified items.

        .EXAMPLE
            Get-FileMetadata -Path "C:\Users\aaron\AppData\Local\GitHubDesktop"

            Description:
            Scans the folder specified in the Path variable and returns the metadata for each file.
#>
    [CmdletBinding(SupportsShouldProcess = $False)]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, `
                HelpMessage = 'Specify a target path, paths or a list of files to scan for metadata.')]
        [Alias('FullName', 'PSPath')]
        [string[]]$Path,

        [Parameter(Mandatory = $False, Position = 1, ValueFromPipeline = $False, `
                HelpMessage = 'Gets only the specified items.')]
        [Alias('Filter')]
        [string[]]$Include = @('*.exe', '*.dll'),

        [Parameter(Mandatory = $False, ValueFromPipeline = $False, `
                HelpMessage = 'Extract Vendor metadata from certificate.')]
        [switch]$Signature
    )
    Begin {
        # Measure time taken to gather data
        $StopWatch = [system.diagnostics.stopwatch]::StartNew()

        # RegEx to grab CN from certificates
        $FindCN = "(?:.*CN=)(.*?)(?:,\ O.*)"

        Write-Verbose "Beginning metadata trawling."
        $Files = @()
    }
    Process {
        # For each path in $Path, check that the path exists
        ForEach ($Loc in $Path) {
            If (Test-Path -Path $Loc -IsValid) {

                # Get the item to determine whether it's a file or folder
                If ((Get-Item -Path $Loc).PSIsContainer) {

                    # Target is a folder, so trawl the folder for .exe and .dll files in the target and sub-folders
                    Write-Verbose "Getting metadata for files in folder: $Loc"
                    $items = Get-ChildItem -Path $Loc -Recurse -Include $Include
                }
                Else {

                    # Target is a file, so just get metadata for the file
                    Write-Verbose "Getting metadata for file: $Loc"
                    $items = Get-Item -Path $Loc

                    # Get signing certificate details from the target file.
                    # Need to fix logic here for when multiple files are passed to this function
                    If ($Signature) {
                        $Cert = Get-AcDigitalSignature -Path $Loc
                        $Vendor = ($Cert.Subject -replace $FindCN, '$1') -replace '"', ""
                    }
                    Else {
                        $Vendor = ""
                    }
                }

                # Create an array from what was returned for specific data and sort on file path
                $Files += $items | Select-Object @{Name = "Path"; Expression = {$_.FullName}}, `
                @{Name = "Description"; Expression = {$_.VersionInfo.FileDescription}}, `
                @{Name = "Product"; Expression = {$_.VersionInfo.ProductName}}, `
                @{Name = "Company"; Expression = {$_.VersionInfo.CompanyName}}, `
                @{Name = "Vendor"; Expression = {$Vendor}}, `
                @{Name = "FileVersion"; Expression = {$_.VersionInfo.FileVersion}}, `
                @{Name = "ProductVersion"; Expression = {$_.VersionInfo.ProductVersion}}
            }
            Else {
                Write-Error "Path does not exist: $Loc"
            }
        }
    }
    End {

        # Return the array of file paths and metadata
        $StopWatch.Stop()
        Write-Verbose "Metadata trawling complete. Script took $($StopWatch.Elapsed.TotalMilliseconds) ms to complete."
        Return $Files | Sort-Object -Property Path
    }
}