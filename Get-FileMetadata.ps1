Function Get-FileMetadata {
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
    [CmdletBinding(SupportsShouldProcess=$False)]
    Param (
        [Parameter(Mandatory=$False, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, `
        HelpMessage='Specify a target path, paths or a list of files to scan for metadata.')]
        # [ValidateScript({ If ((Get-Item -Path $_).PSProvider.Name -ne 'FileSystem') { $True } Else { Throw "$_ is not a file system path." } })]
        [Alias('FullName','PSPath')]
        [string[]]$Path = ".\"
    )

    Begin {
        # Measure time taken to gather data
        $StopWatch = [system.diagnostics.stopwatch]::StartNew()

        Write-Verbose "Beginning metadata trawling."
        $Files = @()
    }
    Process {
        # For each path in $Path, check that the path exists
        If (Test-Path -Path $Path -IsValid) {

            # Get the item to determine whether it's a file or folder
            If ((Get-Item -Path $Path).PSIsContainer) {

                # Target is a folder, so trawl the folder for .exe and .dll files in the target and sub-folders
                Write-Verbose "Getting metadata for files in folder: $Path"
                $items = Get-ChildItem -Path $Path -Recurse -Include '*.exe', '*.dll'
            } Else {

                # Target is a file, so just get metadata for the file
                Write-Verbose "Getting metadata for file: $Path"
                $items = Get-ChildItem -Path $Path
            }

            # Create an array from what was returned for specific data and sort on file path
            $Files += $items | Select-Object @{Name = "Path"; Expression = {$_.FullName}}, `
                @{Name = "Description"; Expression = {$_.VersionInfo.FileDescription}}, `
                @{Name = "Product"; Expression = {$_.VersionInfo.ProductName}}, `
                @{Name = "Company"; Expression = {$_.VersionInfo.CompanyName}}, `
                @{Name = "FileVersion"; Expression = {$_.VersionInfo.FileVersion}}, `
                @{Name = "ProductVersion"; Expression = {$_.VersionInfo.ProductVersion}} | `
                Sort-Object -Property Path

        } Else {
                Write-Error "Path does not exist: $Path"
        }
    }
    End {

        # Return the array of file paths and metadata
        $StopWatch.Stop()
        Write-Verbose "Metadata trawling complete. Script took $($StopWatch.Elapsed.TotalMilliseconds) ms to complete."
        Return $Files
    }
}