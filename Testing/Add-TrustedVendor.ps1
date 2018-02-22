# Create the configuration; Create the configuration helper
Write-Verbose "Loading object 'AM.Configuration.5'."
Try { $Configuration = New-Object -ComObject 'AM.Configuration.5' -ErrorAction SilentlyContinue } Catch { Throw "Unable to load COM Object 'AM.Configuration.5'" }
Write-Verbose "Loading object 'AM.ConfigurationHelper.1'."
Try { $ConfigurationHelper = New-Object -ComObject 'AM.ConfigurationHelper.1' -ErrorAction SilentlyContinue } Catch { Throw "Unable to load COM Object 'AM.ConfigurationHelper.1'" }

# Create default configuration
$ConfigurationXml = $ConfigurationHelper.DefaultConfiguration
$Configuration.ParseXML($ConfigurationXml)

# Use the helper object to read the certificate and expiry date from the signed file
[ref]$dtMyDate = New-Object System.Object
$filePath = "$env:ProgramFiles\Internet Explorer\iexplore.exe"
$CertificateData = $ConfigurationHelper.ReadCertificateDateFromFile($filePath, 0, $dtMyDate)

# Get details from the certificate for Issuer and Subject
# Could look at simplifying reading the certificate by using X509Certificate2 instead of AM.ConfigurationHelper.1
$SubjectName = "(?xi)(?:CN=)(.*?),.*"
$CertObj = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$CertObj.Import($filePath)

# Add the certificate information to the configuration
$DigitalCertificate = $Configuration.CreateInstanceFromClassName("AM.DigitalCertificate")
$DigitalCertificate.RawCertificateData = $CertificateData
$DigitalCertificate.Description = $CertObj.Issuer -replace $SubjectName, '$1'
$DigitalCertificate.IssuedTo = $CertObj.Subject -replace $SubjectName, '$1'
$DigitalCertificate.ExpiryDate = "$($dtMyDate.Value.ToShortDateString()) $($dtMyDate.Value.ToShortTimeString())"
$DigitalCertificate = $Configuration.GroupRules.Item("Everyone").TrustedVendors.Add($DigitalCertificate.Xml())

# Save the live configuration
$Path = "C:\Temp\Configuration.aamp"
$ConfigurationHelper.SaveLocalConfiguration($Path, $Configuration.Xml())