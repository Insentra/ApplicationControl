function Test-AcNoMetadata {
    <#
        .SYNOPSIS
            Returns True|False if all specified properties have no metadata
            Enabling filtering an array returned from Get-AcFileMetadata for files with no metadata
    #>
    [CmdletBinding(SupportsShouldProcess = $False)]
    [OutputType([System.Array])]
    param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $False)]
        [System.Object]$Object
    )

    process {
        foreach ($Property in 'Vendor', 'Company', 'Product', 'Description') {
            Write-Verbose -Message "Testing $($Object.Path)"
            if ($Object.$Property -notin @($Null, "", " ")) { Return $False }
        }
        return $True
    }
}
