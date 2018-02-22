
# Create the configuration; Create the configuration helper
Write-Verbose "Loading object 'AM.Configuration.5'."
Try { $Configuration = New-Object -ComObject 'AM.Configuration.5' -ErrorAction SilentlyContinue } Catch { Throw "Unable to load COM Object 'AM.Configuration.5'" }
Write-Verbose "Loading object 'AM.ConfigurationHelper.1'."
Try { $ConfigurationHelper = New-Object -ComObject 'AM.ConfigurationHelper.1' -ErrorAction SilentlyContinue } Catch { Throw "Unable to load COM Object 'AM.ConfigurationHelper.1'" }

# Create default configuration
$ConfigurationXml = $ConfigurationHelper.DefaultConfiguration
$Configuration.ParseXML($ConfigurationXml)

$filePath = "C:\Program Files\Internet Explorer\iexplore.exe"

# Use the helper object to read the certificate and expiry date from the signed file
[ref]$dtMyDate = New-Object System.Object
$CertificateData = $ConfigurationHelper.ReadCertificateDateFromFile($filePath, 0, $dtMyDate)
Write-Host $dtMyDate

# Add the certificate information to the configuration
$DigitalCertificate = $Configuration.CreateInstanceFromClassName("AM.DigitalCertificate")
$DigitalCertificate.RawCertificateData = $CertificateData
$DigitalCertificate.Description = "Microsoft Corporation - Internet Explorer Certificate"
$DigitalCertificate.ExpiryDate = $dtMyDate

$DigitalCertificate = $Configuration.GroupRules.Item("Everyone").TrustedVendors.Add($DigitalCertificate.Xml())

$Path = "C:\Temp\Configuration.aamp"

# Save the live configuration
$ConfigurationHelper.SaveLocalConfiguration($Path, $Configuration.Xml())
