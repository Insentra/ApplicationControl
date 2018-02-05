<#
    .SYNOPSIS
        Get digital signatures from files in a target folder.
    
    .DESCRIPTION
        Gets digital signatures from .exe and .dll files from a specified path and sub-folders.
        Retreives the certificate thumbprint, certificate name, certificate expiry, certificate validity and file path and outputs the results.
        Output includes files that are not signed.

    .NOTES
        Name: Get-DigitalSignatures.ps1
        Author: Aaron Parker
        Twitter: @stealthpuppy
    
    .LINK
        http://stealthpuppy.com

    .OUTPUT
        [System.Array]

    .PARAMETER Path
        A target path in which to scan files for digital signatures.

    .PARAMETER OutPath
        A target path to export certificates in P7B file format to. Each file will be named for the certificte thumbprint.

    .PARAMETER Unique
        By default the script will return all files and their certificate details. Use -Unique to return the first listing for each unique certificate.

    .PARAMETER Gridivew
        The script will return an object that can be used on the pipeline; however, use -Gridview output directly to an interactive table in a separate window.

    .EXAMPLE
        .\Get-DigitalSignatures.ps1 -Path "C:\Users\aaron\AppData\Local\GitHubDesktop"

        Description:
        Scans the folder specified in the Path variable and returns the digital signatures for each file.

    .EXAMPLE
        .\Get-DigitalSignatures.ps1 -Path "C:\Users\aaron\AppData\Local\GitHubDesktop" -OutPath C:\Temp

        Description:
        Scans the folder specified in the Path variable and returns the digital signatures for each file.
        A .P7B certificate file will be exported for each unique certificate and stored in the C:\Temp folder

    .EXAMPLE
        .\Get-DigitalSignatures.ps1 -Path "C:\Users\aaron\AppData\Local\GitHubDesktop" -Unique

        Description:
        Scans the folder specified in the Path variable and returns the digital signatures for only the first file with a unique certificate.
#>
Function Get-DigitalSignatures {
    [CmdletBinding(SupportsShouldProcess = $False, ConfirmImpact = "Low", DefaultParameterSetName='Base')]
    Param (
        [Parameter(ParameterSetName='Base', Mandatory=$False, ValueFromPipeline=$True, HelpMessage='Specify a target path in which to scan files for digital signatures.')]
        [ValidateScript({ If (Test-Path $_ -PathType 'Container') { $True } Else { Throw "Cannot find path $_" } })]
        [string[]]$Path = ".\",

        [Parameter(ParameterSetName='Base', Mandatory=$False, HelpMessage='Output certificates to files in a specific folder.')]
        [ValidateScript({ If (Test-Path $_ -PathType 'Container') { $True } Else { Throw "Cannot find path $_" } })]
        [string]$OutPath,

        [Parameter(ParameterSetName='Base', Mandatory=$False, HelpMessage='Specify the records to return - all records, or unique thumbprints.')]
        [switch]$Unique = $False,

        [Parameter(ParameterSetName='Base', Mandatory=$False, HelpMessage='Enable output to a Grid View.')]
        [switch]$Gridview = $False
    )

    Function Export-P7bFile {
        Param (
            [string]$File,
            [string]$OutPath
        )
        $cert = (Get-AuthenticodeSignature $File).SignerCertificate
        Write-Verbose "Exporting certificate: $OutPath\$($cert.Thumbprint).p7b"
        Export-Certificate -Cert $cert -FilePath "$OutPath\$($cert.Thumbprint).p7b" -Type P7B
    }

    $Signatures = @()
    # If multiple items passed in via $Path, process each item
    ForEach ( $item in $Path ) {
        # Get Exe and Dll files from the target path (inc. subfolders), find signatures and return certain properties in a grid view
        Write-Verbose "Getting digital signatures for: $item"
        $Signatures += Get-ChildItem -Path $item -Recurse -Include '*.exe', '*.dll' | `
                    Get-AuthenticodeSignature | `
                    Select-Object @{Name = "Thumbprint"; Expression = {$_.SignerCertificate.Thumbprint}}, `
                            @{Name = "Subject"; Expression = {$_.SignerCertificate.Subject}}, `
                            @{Name = "Expiry"; Expression = {$_.SignerCertificate.NotAfter}}, `
                            Status, `
                            Path | `
                    Sort-Object -Property Thumbprint
    }
    
    # If $OutPath specified we only want to return one file per certificate
    If ($OutPath) { $Unique = $True }

    # If -Unique is specified, filter the signatures list and return the first item of each unique certificate
    If ($Unique) { 
        Write-Verbose "Filtering for unique signatures."
        $Signatures = $Signatures | Where-Object {$_.Status -eq "Valid" -or $_.Status -eq "UnknownError" } | `
            Group-Object -Property Thumbprint | `
            ForEach-Object { $_.Group | Select-Object -First 1 }
        Write-Verbose "$($Signatures.Count) unique signature/s found."
    }

    # Output the a P7b certificate file for each unique certificate found from files in the folder
    If ($OutPath) {
        Write-Verbose "Exporting signatures to $Outpath."
        ForEach ( $file in $Signatures.Path ) {
            Export-P7bFile -File $file -OutPath $OutPath | Out-Null
        } 
    }

    # If Gridview switch specified, output to a Grid View
    If ($Gridview) { $Signatures | Out-GridView -Title "Digital Signatures: $Path" }

    # Return output
    Return $Signatures
}