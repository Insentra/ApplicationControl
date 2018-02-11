'Create the configuration
Dim Configuration
Set Configuration = CreateObject("AM.Configuration.5")

'Create the configuration helper
Dim ConfigurationHelper
Set ConfigurationHelper = CreateObject("AM.ConfigurationHelper.1")

'Load the live configuration
Dim ConfigurationXml
ConfigurationXml = ConfigurationHelper.DefaultConfiguration
Configuration.ParseXML ConfigurationXml

'Use the helper object to read the certificate and expiry date from the signed file
Dim CertificateData
Dim dtMyDate
CertificateData = ConfigurationHelper.ReadCertificateDateFromFile("C:\Program Files\Internet Explorer\iexplore.exe", 0, dtMyDate)
WScript.Echo dtMyDate

'Add the certificate information to the configuration
Dim DigitalCertificate
Set DigitalCertificate = Configuration.CreateInstanceFromClassName("AM.DigitalCertificate")
DigitalCertificate.RawCertificateData = CertificateData
DigitalCertificate.Description = "Microsoft Corporation - Internet Explorer Certificate"
DigitalCertificate.ExpiryDate = dtMyDate
Set DigitalCertificate = Configuration.GroupRules.Item("Everyone").TrustedVendors.Add(DigitalCertificate.Xml)

'Save the live configuration
ConfigurationHelper.SaveLocalConfiguration "C:\Temp\Configuration.aamp", Configuration.Xml
Set ConfigurationHelper = Nothing
Set Configuration = Nothing