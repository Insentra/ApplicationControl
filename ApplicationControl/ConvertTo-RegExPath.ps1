Function ConvertTo-RegExPath {
    <#
        .SYNOPSIS
        Replaces strings in a file path with environment variables.
        Internal ApplicationControl function
    #>
    [CmdletBinding(SupportsShouldProcess = $False)]
    [OutputType([String])]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        [array]$Files,

        [Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $False)]
        [string[]]$Path
    )

    For ($i = 0; $i -le ($Files.Count - 1); $i++) {
        $Type = Split-Path $Files[$i].Path -Leaf
        Switch ($Type.Substring($Type.Length - 4).ToLower()) {
            ".dll" { $Files[$i].Path = "$($Path)\\.*\\*.dll" }
            ".exe" { $Files[$i].Path = "$($Path)\\.*\\*.exe" }
            ".ocx" { $Files[$i].Path = "$($Path)\\.*\\*.ocx" }
        }
        $Files[$i].Path = ConvertTo-EnvironmentPath -Path $Files[$i].Path
    }
    $Files | ForEach-Object { $_.Path = $_.Path -replace [regex]::escape('\'), [regex]::escape('\') }
}