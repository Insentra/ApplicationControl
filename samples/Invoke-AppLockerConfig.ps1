<#
    .SYNOPSIS
        Sample commands for creating white listing for Microsoft AppLocker.
        (To Do - add ApplicationControl functions to manage AppLocker cmdlet outputs)
#>

# Microsoft Teams
$Files = @()
$Path = "C:\Users\aaron\AppData\Local\Microsoft\Teams", "C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin", 'C:\Users\aaron\AppData\Local\slack'
ForEach ($Folder in $Path) {
    $Name = Split-Path -Path $Folder -Leaf
    Get-AppLockerFileInformation -Directory $Folder -Verbose -Recurse | `
        New-AppLockerPolicy -RuleType Publisher, Path -RuleNamePrefix $Name -User Everyone -Optimize -Xml -Verbose | `
        Out-File -FilePath "C:\Temp\$($Name).xml"
    $Files += "C:\Temp\$($Name).xml"
}
$File1 = [xml](Get-Content -Path $Files[0])
For ($i = 1; $i -le $Files.Count - 1; $i++) {
    $File2 = [xml](Get-Content -Path $Files[$i])
    ForEach ($Node in $File2.DocumentElement.ChildNodes) {
        $File1.DocumentElement.AppendChild($File1.ImportNode($Node, $true))
    }
}
$File1.Save($Files[0])
$Files[0]