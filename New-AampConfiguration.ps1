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


<#
# create xml file we'll later save into the new aamp as Auditing.xml - to setup local event logging
'<Configuration ClassName="Common.Auditing.Configuration.0000" SendToApplicationLog="False" SendToProductLog="True" LocalFileLogName="%SYSTEMDRIVE%\AppSenseLogs\Auditing\ApplicationManagerEvents_%COMPUTERNAME%.xml">
  <EventsToRaise ClassName="Common.Auditing.EventIdentifierDictionary.0000">
    <EventIdentifier ClassName="Common.Auditing.EventIdentifier.0000" EventID="9000" />
    <EventIdentifier ClassName="Common.Auditing.EventIdentifier.0000" EventID="9002" />
    <EventIdentifier ClassName="Common.Auditing.EventIdentifier.0000" EventID="9003" />
    <EventIdentifier ClassName="Common.Auditing.EventIdentifier.0000" EventID="9099" />
    <EventIdentifier ClassName="Common.Auditing.EventIdentifier.0000" EventID="9095" />
  </EventsToRaise>
</Configuration>' > ($auditFile = [System.IO.Path]::GetTempFileName())

$conf = new-object -comobject 'AM.Configuration.5'
$confHelper = new-object -comobject 'AM.ConfigurationHelper.1'

# load the default configuration
$confXml = $confHelper.DefaultConfiguration

#$confXml = $confHelper.LoadLocalConfiguration('C:\temp\test.aamp')
$conf.ParseXML($confXml)

$conf.GroupRules['Everyone'].TrustedVendors
$filePath = 'C:\TrustedFolder\SlackSetup.exe'

$tv = $conf.ManufactureInstanceFromClassName('AM.DigitalCertificate')
$tv.RawCertificateData = $confHelper.ReadCertificateFromFile($filePath,0)

$dt = [datetime]::MinValue

######### date retrieval logic NOT REALLY WORKING
$confHelper.ReadCertificateDateFromFile($filePath,0, [ref] $dt)
$tv.ExpiryDate = $dt.ToString()
######### THIS PROBABLY ISN'T RIGHT EITHER

$tv.Description = (Get-AuthenticodeSignature -FilePath $filePath).SignerCertificate.DnsNameList.Unicode
$tv.IssuedTo = (Get-AuthenticodeSignature -FilePath $filePath).SignerCertificate.DnsNameList.Unicode

$conf.GroupRules['Everyone'].TrustedVendors.Add($tv.XML())
$confHelper.SaveLocalConfigurationWithAuditingFile($env:userprofile + '\Desktop\Config.aamp',$conf.XML(),$auditFile)
#>