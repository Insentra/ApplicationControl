# Requires -Version 3
Function Export-AcDigitalSignature {
    <#
        .SYNOPSIS
            Exports a digital signature certificate from a signed file.
        
        .DESCRIPTION
            Exports a digital signature certificate from a signed file to a specified folder.

        .NOTES
            Name: Export-AcDigitalSignature
            Author: Aaron Parker
            Twitter: @stealthpuppy
        
        .LINK
            https://stealthpuppy.com

        .OUTPUTS
            [System.Array]

        .PARAMETER Path
            A file or list of files from which to export the digital certificate.

        .PARAMETER Destination
            A destination folder to export the certificate files to.

        .EXAMPLE
            Export-AcDigitalSignature -Path "C:\Users\aaron\AppData\Local\GitHubDesktop\GitHubDesktop.exe" -Destination C:\Temp

            Description:
            Exports the digital signature from "C:\Users\aaron\AppData\Local\GitHubDesktop\GitHubDesktop.exe" to a P7B certificate file in C:\Temp

        .EXAMPLE
            Get-DigitalSignatures -Path "C:\Users\aaron\AppData\Local\GitHubDesktop" -Unique | Export-AcDigitalSignature -Destination C:\Temp

            Description:
            Exports all of the unique digital certificates from "C:\Users\aaron\AppData\Local\GitHubDesktop" to C:\Temp.
#>
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, `
                HelpMessage = 'An array of signed files from which to extract the certificates.')]
        [Alias('FullName', 'PSPath')]
        [string[]]$Path,

        [Parameter(Mandatory = $False, HelpMessage = 'Export certificates to files in a specified folder.')]
        [ValidateScript( { If (Test-Path $_ -PathType 'Container') { $True } Else { Throw "Cannot find output path $_" } })]
        [string]$Destination
    )
    Begin {
        Write-Verbose "Importing module PKI."
        If (Get-Module -Name PKI -ErrorAction SilentlyContinue) {
            Try {
                Import-Module -Name PKI -ErrorAction SilentlyContinue
            }
            Catch {
                Throw "Unable to import module PKI."
            }
        }
        Else {
            Throw "Missing module PKI. Unable to export certificate."
        }
        $Output = @()
    }
    Process {
        # Output the a P7b certificate file for each unique certificate found from files in the folder
        Write-Verbose "Exporting certificate P7B files to $Export."
        ForEach ( $File in $Path ) {
            Write-Verbose "Getting certificate from $File."
            $cert = (Get-AuthenticodeSignature $File).SignerCertificate
            Write-Verbose "Exporting certificate: $Destination\$($cert.Thumbprint).p7b"
            Export-Certificate -Cert $cert -FilePath "$Destination\$($cert.Thumbprint).p7b" -Type P7B
            $Output += "$Destination\$($cert.Thumbprint).p7b"
        } 
    }
    End {
        $Output
    }
}