'Create the configuration
Dim Configuration
Set Configuration = CreateObject("AM.Configuration.5")

'Create the configuration helper
Dim ConfigurationHelper
Set ConfigurationHelper = CreateObject("AM.ConfigurationHelper.1")

'Load the live configuration
Dim ConfigurationXml
ConfigurationXml = ConfigurationHelper.LoadLiveConfiguration
Configuration.ParseXML ConfigurationXml

Dim AccessibleFolder
Set AccessibleFolder = Configuration.CreateInstanceFromClassName("AM.Folder")
AccessibleFolder.Path = "%ALLUSERSPROFILE%"
Configuration.GroupRules.Item("Everyone").AccessibleFolders.Add AccessibleFolder.Xml

Dim ProhibitedFolder
Set ProhibitedFolder = Configuration.CreateInstanceFromClassName("AM.Folder")
ProhibitedFolder.Path = "%SystemDrive%\Utilities"
Configuration.GroupRules.Item("Everyone").ProhibitedFolders.Add ProhibitedFolder.Xml

'Save the live configuration.
ConfigurationHelper.SaveLiveConfiguration Configuration.Xml
Set ConfigurationHelper = Nothing
Set Configuration = Nothing