<#
        .SYNOPSIS
            Add Trusted Vendor certificates to a temporary Ivanti Application Control configuration.
        
        .DESCRIPTION
            

        .NOTES
            Name: Add-TrustedVendor.ps1
            Author: Aaron Parker
            Twitter: @stealthpuppy
        
        .LINK
            https://stealthpuppy.com

        .OUTPUTS


        .PARAMETER Path
            A target path in which to scan files for metadata.

        .EXAMPLE
            .\Add-TrustedVendor.ps1

            Description:
            .
#>
[CmdletBinding(SupportsShouldProcess = $False)]
Param (
        [Parameter(Mandatory = $False, Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, `
                HelpMessage = 'Specify a target file or files that have been signed.')]
        [array]$SignedFile,

        [Parameter(Mandatory = $False, Position = 1, ValueFromPipeline = $False, `
                HelpMessage = 'Enter a target configuration filename .')]
        [string]$ConfigFile = "C:\Temp\Configuration.aamp"
)
Begin {
        # Create the configuration; Create the configuration helper
        Try {
                Write-Verbose "Loading object 'AM.Configuration.5'."
                $Configuration = New-Object -ComObject 'AM.Configuration.5' -ErrorAction SilentlyContinue
        }
        Catch {
                Throw "Unable to load COM Object 'AM.Configuration.5'"
        }
        Try {
                Write-Verbose "Loading object 'AM.ConfigurationHelper.1'."
                $ConfigurationHelper = New-Object -ComObject 'AM.ConfigurationHelper.1' -ErrorAction SilentlyContinue
        }
        Catch {
                Throw "Unable to load COM Object 'AM.ConfigurationHelper.1'"
        }

        # RegEx to grab CN
        $FindCN = "(?xi)(?:CN=)(.*?),.*"

        # Create default configuration
        Write-Verbose "Creating Application Control default configuration"
        $ConfigurationXml = $ConfigurationHelper.DefaultConfiguration
        $Configuration.ParseXML($ConfigurationXml)        
}
Process {
        ForEach ( $File in $SignedFile ) {

                # Use the helper object to read the certificate and expiry date from the signed file
                [ref]$dtMyDate = New-Object System.Object
                Write-Verbose "AM: Reading certificate from $($File.Path)"
                $CertificateData = $ConfigurationHelper.ReadCertificateDateFromFile($File.Path, 0, $dtMyDate)

                # Get details from the certificate for Issuer and Subject
                # Could look at simplifying reading the certificate by using X509Certificate2 instead of AM.ConfigurationHelper.1
                $CertObj = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
                Write-Verbose "X509: Reading certificate from $($File.Path)"
                $CertObj.Import($File.Path)

                # Build Trusted Vendor certificate
                Write-Verbose "Certificate: $($CertObj.Subject)"
                Write-Verbose "Issuer: $($CertObj.Issuer)"
                Write-Verbose "Expiry: $($dtMyDate.Value.ToShortDateString()) $($dtMyDate.Value.ToShortTimeString())"
                $DigitalCertificate = $Configuration.CreateInstanceFromClassName("AM.DigitalCertificate")
                $DigitalCertificate.RawCertificateData = $CertificateData
                $DigitalCertificate.Description = $CertObj.Issuer -replace $FindCN, '$1'
                $DigitalCertificate.IssuedTo = $CertObj.Subject -replace $FindCN, '$1'
                $DigitalCertificate.ExpiryDate = "$($dtMyDate.Value.ToShortDateString()) $($dtMyDate.Value.ToShortTimeString())"

                # Add the certificate information to the configuration
                Write-Verbose "Adding certificate to group rule."
                $DigitalCertificate = $Configuration.GroupRules.Item("Everyone").TrustedVendors.Add($DigitalCertificate.Xml())
        }
}
End {
        # Save the live configuration
        Write-Verbose "Saving configuration: $ConfigFile"
        $ConfigurationHelper.SaveLocalConfiguration($ConfigFile, $Configuration.Xml())
}