Function Test-AcNoMetadata {
    <#
        .SYNOPSIS
            Returns True|False if all specified properties have no metadata
            Enabling filtering an array returned from Get-AcFileMetadata for files with no metadata
    #>
    [CmdletBinding(SupportsShouldProcess = $False)]
    [OutputType([System.Array])]
    param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $False)]
        [object]$obj
    )
    foreach ($Property in 'Vendor', 'Company', 'Product', 'Description') {
        Write-Verbose "Testing $($obj.Path)"
        if ($obj.$Property -notin @($Null, "", " ")) { Return $False }
    }
    Return $True
}