' Create the configuration
Dim Configuration
Set Configuration = CreateObject("AM.Configuration.5")

' Create the configuration helper
Dim ConfigurationHelper
Set ConfigurationHelper = CreateObject("AM.ConfigurationHelper.1")

' Create default configuration
Dim ConfigurationXml
ConfigurationXml = ConfigurationHelper.DefaultConfiguration
Configuration.ParseXML ConfigurationXml

'Add a file to the list of accessible files.
Dim AccessibleFile
Set AccessibleFile = Configuration.CreateInstanceFromClassName("AM.File")
AccessibleFile.Path = "C:\Users\aaron\Downloads\Setup-12.21.1.exe"
' AccessibleFile.Commandline = "C:\Users\aaparker\Downloads\Setup-12.21.1.exe"
Configuration.GroupRules.Item("Everyone").AccessibleFiles.Add AccessibleFile.Xml

'Save the live configuration.
ConfigurationHelper.SaveLocalConfiguration "C:\Temp\Configuration.aamp", Configuration.Xml
Set ConfigurationHelper = Nothing
Set Configuration = Nothing