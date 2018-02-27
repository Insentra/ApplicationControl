Function New-AcAampConfiguration {
    <#
        .SYNOPSIS
          Creates an Ivanti Application Control configuration from an array of inputs.
            
        .DESCRIPTION
          Works with Get-DigitalSignatures and Get-FileMetadata to create an Ivanti Application Control configuration.
          Intended for making it easier to define an application and create a rule set automatically for copying into a detailed configuration.
  
          Adds Accessible files and Accessible folders with metadata and Trusted Vendor certificates to the Everyone group rule.
  
        .NOTES
          Name: New-AampConfiguration.ps1
          Author: Aaron Parker
          Twitter: @stealthpuppy
  
        .LINK
          http://stealthpuppy.com
  
        .OUTPUTS
          [System.String]
  
        .PARAMETER AccessibleFiles
  
        .EXAMPLE
          .\New-AampConfiguration.ps1 -AccessibleFiles $Files -Path "C:\Temp\Configuration.aamp"
  
          Description:
          Adds files and metadata in the array $Files to a new Application Control configuration at "C:\Temp\Configuration.aamp".

        .EXAMPLE
          .\New-AampConfiguration.ps1 -SignedFiles $SignedFiles -Path "C:\Temp\Configuration.aamp"
  
          Description:
          Adds Trusted Vendor certificates from the files in the array $SignedFiles to a new Application Control configuration at "C:\Temp\Configuration.aamp".
#>
    # Requires -Version 3
    [CmdletBinding(SupportsShouldProcess = $False)]
    Param (
        [Parameter(Mandatory = $False, Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $False, `
                HelpMessage = 'Specify the array of accessible files with metadata to add.')]
        [array]$AccessibleFiles,

        [Parameter(Mandatory = $False, Position = 1, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $False, `
                HelpMessage = 'Specify the array of accessible folders with metadata to add.')]
        [array]$AccessibleFolders,

        [Parameter(Mandatory = $False, Position = 2, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $False, `
                HelpMessage = 'Specify a target file or files that have been signed.')]
        [array]$SignedFiles,

        [Parameter(Mandatory = $False, Position = 3, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $False, `
                HelpMessage = 'Specify the rule name to add the items to.')]
        [string]$GroupRule = "Everyone",

        [Parameter(Mandatory = $False, Position = 4, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $False, `
                HelpMessage = 'Specify a path to the configuration to output.')]
        [string]$Path = "C:\Temp\Configuration.aamp"
    )
    Begin {
        Function ConvertTo-EnvironmentPath {
            <#
            .SYNOPSIS
            Replaces strings in a file path with environment variables.
        #>
            Param (
                [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $False)]
                [string]$Path
            )
            $RegExLocalAppData = "^[a-zA-Z]:\\Users\\.*\\AppData\\Local\\"
            $RegExAppData = "^[a-zA-Z]:\\Users\\.*\\AppData\\Roaming\\"
            $RegExTemp = "^[a-zA-Z]:\\Users\\.*\\AppData\\Local\\Temp\\"
            $RegExProgramData = "^[a-zA-Z]:\\ProgramData\\"
            $RegExProgramFiles = "^[a-zA-Z]:\\Program Files\\"
            $RegExProgramFilesx86 = "^[a-zA-Z]:\\Program Files (x86)\\"
            $RegExSystemRoot = "^[a-zA-Z]:\\Windows\\"
            $RegExPublic = "^[a-zA-Z]:\\Users\\Public\\"
    
            Switch -Regex ($Path) {
                { $_ -match $RegExLocalAppData } { $Path = $Path -replace $RegExLocalAppData, "%LOCALAPPDATA%\" }
                { $_ -match $RegExAppData } { $Path = $Path -replace $RegExAppData, "%APPDATA%\" }
                { $_ -match $RegExTemp } { $Path = $Path -replace $RegExRoamingAppData, "%TEMP%\" }
                { $_ -match $RegExProgramData } { $Path = $Path -replace $RegExProgramData, "%ProgramData%\" }
                { $_ -match $RegExProgramFiles } { $Path = $Path -replace $RegExProgramFiles, "%ProgramFiles%\" }
                { $_ -match $RegExProgramFilesx86 } { $Path = $Path -replace $RegExProgramFilesx86, "%ProgramFiles(x86)%\" }
                { $_ -match $RegExSystemRoot } { $Path = $Path -replace $RegExSystemRoot, "%SystemRoot%\" }
                { $_ -match $RegExPublic } { $Path = $Path -replace $RegExPublic, "%PUBLIC%\" }
            }
            $Path
        }
  
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

        # Create configuration objects
        $AccessibleFile = $Configuration.CreateInstanceFromClassName("AM.File")
        $AccessibleFolder = $Configuration.CreateInstanceFromClassName("AM.Folder")
        $DigitalCertificate = $Configuration.CreateInstanceFromClassName("AM.DigitalCertificate")

        # RegEx to grab CN from certificates
        $FindCN = "(?xi)(?:CN=)(.*?),.*"

        # Create default configuration
        Write-Verbose "Creating Application Control default configuration"
        $ConfigurationXml = $ConfigurationHelper.DefaultConfiguration
        $Configuration.ParseXML($ConfigurationXml)

        # Remove the default folders from the configuration to make viewing the config simpler
        Write-Verbose "Removing default folders from the configuration in rule $GroupRule."
        ForEach ($folder in $Configuration.GroupRules.Item($GroupRule).AccessibleFolders) {
            $Configuration.GroupRules.Item($GroupRule).AccessibleFolders.Remove($folder.Path) | Out-Null
        }
    }
    Process {
        If ($PSBoundParameters.ContainsKey('AccessibleFiles')) {
            ForEach ($file in $AccessibleFiles) {
                # Add a file to the list of accessible files.
                Write-Verbose "[Adding Accessible File] $(ConvertTo-EnvironmentPath -Path $file.Path)"
                $AccessibleFile.Path = $(ConvertTo-EnvironmentPath -Path $file.Path)
                $AccessibleFile.CommandLine = $(ConvertTo-EnvironmentPath -Path $file.Path)
                If ($file.Company) {
                    $AccessibleFile.Metadata.CompanyName = $file.Company
                    $AccessibleFile.Metadata.CompanyNameEnabled = $True
                }
                Else {
                    $AccessibleFile.Metadata.CompanyNameEnabled = $False
                }
                If ($file.Product) {
                    $AccessibleFile.Metadata.ProductName = $file.Product
                    $AccessibleFile.Metadata.ProductNameEnabled = $True
                }
                Else {
                    $AccessibleFile.Metadata.ProductNameEnabled = $False
                }
                If ($file.Description) {
                    $AccessibleFile.Description = $file.Description
                    $AccessibleFile.Metadata.FileDescription = $file.Description
                    $AccessibleFile.Metadata.FileDescriptionEnabled = $True
                }
                Else {
                    $AccessibleFile.Description = "[No metadata found]"
                    $AccessibleFile.Metadata.FileDescriptionEnabled = $False
                }  
                $Configuration.GroupRules.Item($GroupRule).AccessibleFiles.Add($AccessibleFile.Xml()) | Out-Null
            }
        }

        If ($PSBoundParameters.ContainsKey('AccessibleFolders')) {
            ForEach ($file in $AccessibleFolders) {
                # Add a file to the list of accessible files.
                $FolderPath = Split-Path -Path $file.Path -Parent
                Write-Verbose "[Adding Accessible Folder] $(ConvertTo-EnvironmentPath -Path $FolderPath)"
                $AccessibleFolder.ItemKey = $(ConvertTo-EnvironmentPath -Path $FolderPath)
                $AccessibleFolder.Path = $(ConvertTo-EnvironmentPath -Path $FolderPath)
                $AccessibleFolder.Recursive = $True
                If ($file.Company) {
                    $AccessibleFolder.Metadata.CompanyName = $file.Company
                    $AccessibleFolder.Metadata.CompanyNameEnabled = $True
                }
                Else {
                    $AccessibleFolder.Metadata.CompanyNameEnabled = $False
                }
                If ($file.Product) {
                    $AccessibleFolder.Metadata.ProductName = $file.Product
                    $AccessibleFolder.Metadata.ProductNameEnabled = $True
                }
                Else {
                    $AccessibleFolder.Metadata.ProductNameEnabled = $False
                }
                If ($file.Description) {
                    $AccessibleFolder.Description = $file.Description
                    $AccessibleFolder.Metadata.FileDescription = $file.Description
                    $AccessibleFolder.Metadata.FileDescriptionEnabled = $True
                }
                Else {
                    $AccessibleFolder.Description = "[No metadata found]"
                    $AccessibleFolder.Metadata.FileDescriptionEnabled = $False
                }  
                $Configuration.GroupRules.Item($GroupRule).AccessibleFolders.Add($AccessibleFolder.Xml()) | Out-Null
            }
        }

        If ($PSBoundParameters.ContainsKey('SignedFiles')) {
            ForEach ($File in $SignedFiles) {
                # Adding Trusted Vendors
                Write-Verbose "[Adding Trusted Vendor]"
                # Use the helper object to read the certificate and expiry date from the signed file
                [ref]$dtMyDate = New-Object System.Object
                Write-Verbose "Reading certificate from $($File.Path)"
                $CertificateData = $ConfigurationHelper.ReadCertificateDateFromFile($File.Path, 0, $dtMyDate)

                # Get details from the certificate for Issuer and Subject
                # Could look at simplifying reading the certificate by using X509Certificate2 instead of AM.ConfigurationHelper.1
                $CertObj = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
                $CertObj.Import($File.Path)

                # Build Trusted Vendor certificate; Add the certificate information to the configuration
                Write-Verbose "Certificate: $($CertObj.Subject); $($dtMyDate.Value.ToShortDateString()) $($dtMyDate.Value.ToShortTimeString())"
                Write-Verbose "Issuer: $($CertObj.Issuer)"
                $DigitalCertificate.RawCertificateData = $CertificateData
                $DigitalCertificate.Description = "Issuer: $($CertObj.Issuer -replace $FindCN, '$1'). Thumbprint: $($CertObj.Thumbprint)"
                $DigitalCertificate.IssuedTo = $CertObj.Subject -replace $FindCN, '$1'
                $DigitalCertificate.ExpiryDate = "$($dtMyDate.Value.ToShortDateString()) $($dtMyDate.Value.ToShortTimeString())"
                $DigitalCertificate.ErrorIgnoreFlags = 256     # Enable 'Ignore end Certificate revocation errors'
                $Configuration.GroupRules.Item($GroupRule).TrustedVendors.Add($DigitalCertificate.Xml()) | Out-Null
            }
        }
    }
    End {
        # Save the configuration and output the path to it
        If (!(Test-Path -Path (Split-Path -Path $Path -Parent))) {
            Write-Verbose "Creating folder $(Split-Path -Path $Path -Parent)"
            New-Item -Path (Split-Path -Path $Path -Parent) -ItemType Directory | Out-Null
        }
        Write-Verbose "Saving configuration to: $Path"
        $ConfigurationHelper.SaveLocalConfiguration($Path, $Configuration.Xml())
        $Path
    }
}