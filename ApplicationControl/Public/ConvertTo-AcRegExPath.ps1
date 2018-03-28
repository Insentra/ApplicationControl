Function ConvertTo-AcRegExPath {
    <#
        .SYNOPSIS
        Replaces strings in a file path with environment variables.
        Internal ApplicationControl function
    #>
    [CmdletBinding(SupportsShouldProcess = $False)]
    [OutputType([Array])]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $False, ValueFromPipelineByPropertyName = $False)]
        [array]$Files,

        [Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $False)]
        [string[]]$Path
    )
    Begin {
    }
    Process {
        ForEach ($Folder in $Path) {
            $Files | ForEach-Object { 
                If ($_.Path.Contains($Folder)) {
                    $_.Path = ConvertTo-AcEnvironmentPath -Path  "$($Folder)\.*\*$($_.Path.Substring($_.Path.Length - 4).ToLower())"
                }
            }
        }
    }
    End {
        $Files | ForEach-Object { $_.Path = $_.Path -replace [regex]::escape('\'), [regex]::escape('\') }
        $Files
    }
}