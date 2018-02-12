Write-Verbose "Loading object 'AM.Configuration.5'."
Try { $Configuration = New-Object -ComObject 'AM.Configuration.5' -ErrorAction SilentlyContinue } Catch { Throw "Unable to load COM Object 'AM.Configuration.5'" }
Write-Verbose "Loading object 'AM.ConfigurationHelper.1'."
Try { $ConfigurationHelper = New-Object -ComObject 'AM.ConfigurationHelper.1' -ErrorAction SilentlyContinue } Catch { Throw "Unable to load COM Object 'AM.ConfigurationHelper.1'" }

# Create default configuration
$ConfigurationXml = $ConfigurationHelper.DefaultConfiguration
$Configuration.ParseXML($ConfigurationXml)

# Add accessible folder
$Folder = "%LOCALAPPDATA%\Microsoft\Teams"
$File = "C:\Users\aaron\AppData\Local\Microsoft\Teams\Update.exe"

$AccessibleFolder = $Configuration.CreateInstanceFromClassName("AM.Folder")
$AccessibleFolder.Path = $Folder
$Configuration.GroupRules.Item("Everyone").AccessibleFolders.Add($AccessibleFolder.Xml())

# Save the live configuration
$Path = "C:\Temp\Configuration.aamp"
$ConfigurationHelper.SaveLocalConfiguration($Path, $Configuration.Xml())