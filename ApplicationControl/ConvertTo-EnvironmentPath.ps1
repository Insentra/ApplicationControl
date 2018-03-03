Function ConvertTo-EnvironmentPath {
    <#
        .SYNOPSIS
        Replaces strings in a file path with environment variables.
        Internal ApplicationControl function
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
        { $_ -match $RegExTemp } { $Path = $Path -replace $RegExTemp, "%TEMP%\" }
        { $_ -match $RegExProgramData } { $Path = $Path -replace $RegExProgramData, "%ProgramData%\" }
        { $_ -match $RegExProgramFiles } { $Path = $Path -replace $RegExProgramFiles, "%ProgramFiles%\" }
        { $_ -match $RegExProgramFilesx86 } { $Path = $Path -replace $RegExProgramFilesx86, "%ProgramFiles(x86)%\" }
        { $_ -match $RegExSystemRoot } { $Path = $Path -replace $RegExSystemRoot, "%SystemRoot%\" }
        { $_ -match $RegExPublic } { $Path = $Path -replace $RegExPublic, "%PUBLIC%\" }
    }
    $Path
}