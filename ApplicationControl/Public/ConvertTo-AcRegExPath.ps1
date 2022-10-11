function ConvertTo-AcRegExPath {
    <#
        .SYNOPSIS
        Replaces strings in a file path with environment variables.
        Internal ApplicationControl function
    #>
    [CmdletBinding(SupportsShouldProcess = $False)]
    [OutputType([System.Array])]
    param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $False)]
        [System.Array]$Files,

        [Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $False)]
        [System.String[]]$Path
    )
    begin {
    }
    process {
        foreach ($Folder in $Path) {
            $Files | ForEach-Object {
                if ($_.Path.Contains($Folder)) {
                    $_.Path = ConvertTo-AcEnvironmentPath -Path  "$($Folder)\.*\*$($_.Path.Substring($_.Path.Length - 4).ToLower())"
                }
            }
        }
    }
    end {
        $Files | ForEach-Object { $_.Path = $_.Path -replace [regex]::escape('\'), [regex]::escape('\') }
        $Files
    }
}
