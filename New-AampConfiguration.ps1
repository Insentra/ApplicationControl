$Configuration = New-Object -ComObject AM.Configuration.5
$ConfigurationHelper = New-Object -ComObject AM.ConfigurationHelper.1

$ConfigurationXml = $Null
$ConfigurationXml = $ConfigurationHelper.DefaultConfiguration
$Configuration.ParseXML($ConfigurationXml)

$Path = "C:\TrustedFolder\SlackSetup.exe"

$AccessibleFile = $Configuration.CreateInstanceFromClassName("AM.File")
$AccessibleFile.Path = $Path
$AccessibleFile.Commandline = $Path

$ConfigurationHelper.ReadNumCertificatesFromFile($Path)
$ConfigurationHelper.ReadCertificateFromFile($Path, 0)

$Configuration.GroupRules.Item("Everyone").AccessibleFiles.Add($AccessibleFile.Xml)

$ConfigurationHelper.SaveLocalConfiguration("C:\Temp\Configuration.aamp", $ConfigurationXml)