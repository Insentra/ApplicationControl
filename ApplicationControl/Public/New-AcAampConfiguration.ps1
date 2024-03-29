function New-AcAampConfiguration {
    <#
        .SYNOPSIS
          Creates an Ivanti Application Control configuration from an array of inputs.

        .DESCRIPTION
          Works with Get-DigitalSignatures and Get-FileMetadata to create an Ivanti Application Control configuration.
          Intended for making it easier to define an application and create a rule set automatically for copying into a detailed configuration.

          Adds Accessible files and Accessible folders with metadata and Trusted Vendor certificates to the Everyone group rule.

        .NOTES
          Author: Aaron Parker
          Twitter: @stealthpuppy

        .LINK
          https://github.com/Insentra/ApplicationControl

        .OUTPUTS
          [System.String]

        .PARAMETER AccessibleFiles
            An array of files with metadata to add to the Allowed list.

        .PARAMETER TrustedVendors
            An array of signed files for extracting the certificate to add to the Trusted Vendors list.

        .PARAMETER GroupRule
            The Group rule to add the AccessibleFiles and TrustedVendors to. Defaults to Everyone.

        .PARAMETER Path
            A full file path to output the temporary Application Control configuration to. Defaults to C:\Temp\Configuration.aamp

        .PARAMETER IgnoreCRL
            Enable or disable ignore CRL flags for Trusted Vendor certificates. Typically CRL checking is an issue behind a proxy server.

        .EXAMPLE
          New-AampConfiguration -AccessibleFiles $Files -Path "C:\Temp\Configuration.aamp"

          Description:
          Adds files and metadata in the array $Files to a new Application Control configuration at "C:\Temp\Configuration.aamp".

        .EXAMPLE
          New-AampConfiguration -AccessibleFiles $Files -RegEx

          Description:
          Adds files and metadata in the array $Files to a new Application Control configuration at the default path of "C:\Temp\Configuration.aamp". With file paths treated as RegEx.

        .EXAMPLE
          New-AampConfiguration -TrustedVendors $SignedFiles -Path "C:\Temp\Configuration.aamp"

          Description:
          Adds Trusted Vendor certificates from the files in the array $SignedFiles to a new Application Control configuration at "C:\Temp\Configuration.aamp".
    #>
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $False, Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $False, `
                HelpMessage = 'Specify the array of accessible files with metadata to add.')]
        [System.Array]$AccessibleFiles,

        [Parameter(Mandatory = $False, Position = 1, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $False, `
                HelpMessage = 'Specify a target file or files that have been signed.')]
        [System.Array]$TrustedVendors,

        [Parameter(Mandatory = $False, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $False, `
                HelpMessage = 'Specify the rule name to add the items to.')]
        [System.String]$GroupRule = "Everyone",

        [Parameter(Mandatory = $False, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $False, `
                HelpMessage = 'Specify a path to the configuration to output.')]
        [System.String]$Path = "C:\Temp\Configuration.aamp",

        [Parameter(Mandatory = $False, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $False, `
                HelpMessage = 'Enable or disable ignore CRL flags for Trusted Vendor certificates.')]
        [System.Boolean]$IgnoreCRL = $True
    )
    begin {
        # Create the configuration; Create the configuration helper
        try {
            Write-Verbose -Message "Loading object 'AM.Configuration.5'."
            $Configuration = New-Object -ComObject 'AM.Configuration.5' -ErrorAction SilentlyContinue
        }
        catch {
            throw "Unable to load COM Object 'AM.Configuration.5'"
        }
        try {
            Write-Verbose -Message "Loading object 'AM.ConfigurationHelper.1'."
            $ConfigurationHelper = New-Object -ComObject 'AM.ConfigurationHelper.1' -ErrorAction SilentlyContinue
        }
        catch {
            throw "Unable to load COM Object 'AM.ConfigurationHelper.1'"
        }

        # Create configuration objects
        if ($PSBoundParameters.ContainsKey('AccessibleFiles')) {
            Write-Verbose -Message "Creating AM.File instance"
            $AccessibleFile = $Configuration.CreateInstanceFromClassName("AM.File")
        }
        if ($PSBoundParameters.ContainsKey('TrustedVendors')) {
            Write-Verbose -Message "Creating AM.DigitalCertificate instance"
            $DigitalCertificate = $Configuration.CreateInstanceFromClassName("AM.DigitalCertificate")
        }

        # Create default configuration
        Write-Verbose -Message "Creating Application Control default configuration"
        $ConfigurationXml = $ConfigurationHelper.DefaultConfiguration
        $Configuration.ParseXML($ConfigurationXml)

        # Remove the default folders from the configuration to make viewing the config simpler
        Write-Verbose -Message "Removing default folders from the configuration in rule $GroupRule."
        foreach ($folder in $Configuration.GroupRules.Item($GroupRule).AccessibleFolders) {
            $Configuration.GroupRules.Item($GroupRule).AccessibleFolders.Remove($folder.Path) | Out-Null
        }

        # RegEx to grab CN from certificates
        $FindCN = "(?:.*CN=)(.*?)(?:,\ O.*)"
    }
    process {
        if ($PSBoundParameters.ContainsKey('AccessibleFiles')) {
            foreach ($file in $AccessibleFiles) {
                # Add a file to the list of accessible files.
                # Requires running from an elevated PowerShell instance because the AM objects fail adding all values without admin rights
                Write-Verbose -Message "[Adding Accessible File] $($file.Path)"
                if ($file.Path -match "\\.\*\\") {
                    # String matches a RegEx path that includes "\\.*\\ denoting any folder"
                    $AccessibleFile.Path = $file.Path
                    $AccessibleFile.UseRegularExpression = $True
                    # Make CommandLine unique because this is the file entry key value
                    $AccessibleFile.CommandLine = "$($file.Path) $(([guid]::NewGuid()).ToString())"
                }
                else {
                    $AccessibleFile.Path = $(ConvertTo-AcEnvironmentPath -Path $file.Path)
                    $AccessibleFile.CommandLine = $(ConvertTo-AcEnvironmentPath -Path $file.Path)
                }
                $AccessibleFile.TrustedOwnershipChecking = $False
                # Filter on metadata greater than a single character. Some files have metadata fields with a single space
                if ($file.Company -gt 1) {
                    $AccessibleFile.Metadata.CompanyName = $file.Company
                    $AccessibleFile.Metadata.CompanyNameEnabled = $True
                    $AccessibleFile.Description = $file.Company
                }
                else {
                    $AccessibleFile.Metadata.CompanyNameEnabled = $False
                }
                if ($file.Vendor -gt 1) {
                    $AccessibleFile.Metadata.VendorName = $file.Vendor
                    $AccessibleFile.Metadata.VendorNameEnabled = $True
                    $AccessibleFile.Description = $file.Vendor
                }
                else {
                    $AccessibleFile.Metadata.VendorNameEnabled = $False
                }
                if ($file.Product -gt 1) {
                    $AccessibleFile.Metadata.ProductName = $file.Product
                    $AccessibleFile.Metadata.ProductNameEnabled = $True
                    $AccessibleFile.Description = $file.Product
                }
                else {
                    $AccessibleFile.Metadata.ProductNameEnabled = $False
                }
                if ($file.Description -gt 1) {
                    $AccessibleFile.Metadata.FileDescription = $file.Description
                    $AccessibleFile.Metadata.FileDescriptionEnabled = $True
                    $AccessibleFile.Description = $file.Description
                }
                else {
                    $AccessibleFile.Metadata.FileDescriptionEnabled = $False
                }
                if (!($AccessibleFile.Description)) {
                    $AccessibleFile.Description = "[No metadata found]"
                }

                # Add file to the rule and remove values from all properties ready for next file
                $Configuration.GroupRules.Item($GroupRule).AccessibleFiles.Add($AccessibleFile.Xml()) | Out-Null
                $AccessibleFile.Path = ""
                $AccessibleFile.CommandLine = ""
                $AccessibleFile.Description = ""
                $AccessibleFile.Metadata.CompanyName = ""
                $AccessibleFile.Metadata.VendorName = ""
                $AccessibleFile.Metadata.ProductName = ""
                $AccessibleFile.Metadata.FileDescription = ""
            }
        }

        if ($PSBoundParameters.ContainsKey('TrustedVendors')) {
            foreach ($File in $TrustedVendors) {
                # Adding Trusted Vendors
                Write-Verbose -Message "[Adding Trusted Vendor]"
                # Use the helper object to read the certificate and expiry date from the signed file
                [ref]$dtMyDate = New-Object System.Object
                Write-Verbose -Message "Reading certificate from $($File.Path)"
                $CertificateData = $ConfigurationHelper.ReadCertificateDateFromFile($File.Path, 0, $dtMyDate)

                # Get details from the certificate for Issuer and Subject
                # Could look at simplifying reading the certificate by using X509Certificate2 instead of AM.ConfigurationHelper.1
                $CertObj = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
                $CertObj.Import($File.Path)

                # Build Trusted Vendor certificate; Add the certificate information to the configuration
                Write-Verbose -Message "Certificate: $($CertObj.Subject); $($dtMyDate.Value.ToShortDateString()) $($dtMyDate.Value.ToShortTimeString())"
                $DigitalCertificate.RawCertificateData = $CertificateData
                Write-Verbose -Message "Issuer: $($CertObj.Issuer)"
                $DigitalCertificate.Description = "Issuer: $($CertObj.Issuer -replace $FindCN, '$1'). Thumbprint: $($CertObj.Thumbprint)"
                $DigitalCertificate.IssuedTo = ($CertObj.Subject -replace $FindCN, '$1') -replace '"', ""
                $DigitalCertificate.ExpiryDate = "$($dtMyDate.Value.ToShortDateString()) $($dtMyDate.Value.ToShortTimeString())"
                if ($IgnoreCRL) {
                    # Enable 'Ignore end Certificate revocation errors' - remove if no issue with CRL checking.
                    # Typically CRL checking is an issue behind a proxy server
                    $DigitalCertificate.ErrorIgnoreFlags = 1792
                }
                $Configuration.GroupRules.Item($GroupRule).TrustedVendors.Add($DigitalCertificate.Xml()) | Out-Null
            }
        }
    }
    end {
        # Save the configuration and output the path to it
        if (!(Test-Path -Path (Split-Path -Path $Path -Parent))) {
            if ($pscmdlet.ShouldProcess((Split-Path -Path $Path -Parent), "Create folder")) {
                New-Item -Path (Split-Path -Path $Path -Parent) -ItemType Directory | Out-Null
            }
        }
        Write-Verbose -Message "Saving configuration to: $Path"
        $ConfigurationHelper.SaveLocalConfiguration($Path, $Configuration.Xml())
        $Path
    }
}
