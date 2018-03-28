Function Test-AcNoMetadata {
    <#
        .SYNOPSIS
            Returns True|False if all specified properties have no metadata
            Enabling filtering an array returned from Get-AcFileMetadata for files with no metadata
    #>
    [CmdletBinding(SupportsShouldProcess = $False)]
    [OutputType([Array])]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $False)]
        [object]$obj
    )
    ForEach ($Property in 'Vendor', 'Company', 'Product', 'Description') {
        Write-Verbose "Testing $($obj.Path)"
        If ($obj.$Property -notin @($Null, "", " ")) { Return $False }
    }
    Return $True
}