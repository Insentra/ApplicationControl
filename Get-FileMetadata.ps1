<#
    .SYNOPSIS
        Get file metadata from files in a target folder.
    
    .DESCRIPTION


    .NOTES
        Name: Get-FileMetadata.ps1
        Author: Aaron Parker
        Twitter: @stealthpuppy
    
    .LINK
        http://stealthpuppy.com

    .OUTPUT
        [System.Array]

    .PARAMETER Path
        A target path in which to scan files for metadata.

    .EXAMPLE
        .\Get-FileMetadata.ps1 -Path "C:\Users\aaron\AppData\Local\GitHubDesktop"

        Description:
        Scans the folder specified in the Path variable and returns the metadata for each file.
#>
Function Get-FileMetadata {
    [CmdletBinding(SupportsShouldProcess = $False, ConfirmImpact = "Low", DefaultParameterSetName='Base')]
    Param (
        [Parameter(ParameterSetName='Base', Mandatory=$False, ValueFromPipeline=$True, HelpMessage='Specify a target path, paths or a list of file paths which to scan for metadata.')]
        [string[]]$Path = ".\"
    )

    Begin {
        Write-Verbose "Beginning metadata trawling."
        $Files = @()
    }
    Process {

        # If multiple items passed in via $Path, process each item
        ForEach ( $item in $Path ) {

            # Check that the path exists
            If (Test-Path $item) {

                # Get the item to determine whether it's a file or folder
                $target = Get-Item -Path $item
                If ($target.PSIsContainer) {

                    # Target is a folder, so trawl the folder for .exe and .dll files in the target and sub-folders
                    Write-Verbose "Getting metadata for folder: $target"
                    $Files += Get-ChildItem -Path $target -Recurse -Include '*.exe', '*.dll' | `
                    Select-Object @{Name = "Path"; Expression = {$_.FullName}}, `
                            @{Name = "Description"; Expression = {$_.VersionInfo.FileDescription}}, `
                            @{Name = "Product"; Expression = {$_.VersionInfo.ProductName}}, `
                            @{Name = "Company"; Expression = {$_.VersionInfo.CompanyName}}, `
                            @{Name = "FileVersion"; Expression = {$_.VersionInfo.FileVersion}}, `
                            @{Name = "ProductVersion"; Expression = {$_.VersionInfo.ProductVersion}} | `
                    Sort-Object -Property Path
                } Else {

                    # Target is a file, so just get metadata for the file
                    Write-Verbose "Getting metadata for file: $target"
                    $Files += Get-ChildItem -Path $target | `
                    Select-Object @{Name = "Path"; Expression = {$_.FullName}}, `
                        @{Name = "Description"; Expression = {$_.VersionInfo.FileDescription}}, `
                        @{Name = "Product"; Expression = {$_.VersionInfo.ProductName}}, `
                        @{Name = "Company"; Expression = {$_.VersionInfo.CompanyName}}, `
                        @{Name = "FileVersion"; Expression = {$_.VersionInfo.FileVersion}}, `
                        @{Name = "ProductVersion"; Expression = {$_.VersionInfo.ProductVersion}} | `
                    Sort-Object -Property Path
                }
            } Else {
                Write-Error "Path does not exist: $item"
            }
        }
    }
    End {

        # Return the array of file paths and metadata
        Return $Files
    }
}