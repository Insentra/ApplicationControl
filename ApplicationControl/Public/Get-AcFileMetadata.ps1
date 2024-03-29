function Get-AcFileMetadata {
    <#
        .SYNOPSIS
            Get file metadata from files in a target folder.

        .DESCRIPTION
            Retreives file metadata from files in a target path, or file paths, to display information on the target files.
            Useful for understanding application files and identifying metadata stored in them. Enables the administrator to view metadata for application control scenarios.

        .NOTES
            Author: Aaron Parker
            Twitter: @stealthpuppy

        .LINK
            https://github.com/Insentra/ApplicationControl

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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Justification="Metadata is a singular noun")]
    [OutputType([System.Array])]
    param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, `
                HelpMessage = 'Specify a target path, paths or a list of files to scan for metadata.')]
        [Alias('FullName', 'PSPath')]
        [System.String[]]$Path,

        [Parameter(Mandatory = $False, Position = 1, ValueFromPipeline = $False, `
                HelpMessage = 'Gets only the specified items.')]
        [Alias('Filter')]
        [System.String[]]$Include = @('*.exe', '*.dll', '*.ocx', '*.msi', '*.ps1', '*.vbs', '*.js', '*.cmd', '*.bat')
    )
    begin {
        # Measure time taken to gather data
        $StopWatch = [system.diagnostics.stopwatch]::StartNew()

        # RegEx to grab CN from certificates
        $FindCN = "(?:.*CN=)(.*?)(?:,\ O.*)"

        Write-Verbose -Message "Beginning metadata trawling."
        $Files = @()
    }
    process {
        # For each path in $Path, check that the path exists
        foreach ($Loc in $Path) {
            if (Test-Path -Path $Loc -IsValid) {
                # Get the item to determine whether it's a file or folder
                if ((Get-Item -Path $Loc).PSIsContainer) {
                    # Target is a folder, so trawl the folder for .exe and .dll files in the target and sub-folders
                    Write-Verbose -Message "Getting metadata for files in folder: $Loc"
                    $items = Get-ChildItem -Path $Loc -Recurse -Include $Include
                }
                else {
                    # Target is a file, so just get metadata for the file
                    Write-Verbose -Message "Getting metadata for file: $Loc"
                    $items = Get-Item -Path $Loc
                }

                # Create an array from what was returned for specific data and sort on file path
                $Files += $items | Select-Object @{Name = "Path"; Expression = { $_.FullName } }, `
                @{Name = "Owner"; Expression = { (Get-Acl -Path $_.FullName).Owner } }, `
                @{Name = "Vendor"; Expression = { $(((Get-AcDigitalSignature -Path $_ -ErrorAction SilentlyContinue).Subject -replace $FindCN, '$1') -replace '"', "") } }, `
                @{Name = "Company"; Expression = { $_.VersionInfo.CompanyName } }, `
                @{Name = "Description"; Expression = { $_.VersionInfo.FileDescription } }, `
                @{Name = "Product"; Expression = { $_.VersionInfo.ProductName } }, `
                @{Name = "ProductVersion"; Expression = { $_.VersionInfo.ProductVersion } }, `
                @{Name = "FileVersion"; Expression = { $_.VersionInfo.FileVersion } }
            }
            else {
                Write-Error "Path does not exist: $Loc"
            }
        }
    }
    end {

        # Return the array of file paths and metadata
        $StopWatch.Stop()
        Write-Verbose -Message "Metadata trawling complete. Script took $($StopWatch.Elapsed.TotalMilliseconds) ms to complete."
        return $Files | Sort-Object -Property Path
    }
}
