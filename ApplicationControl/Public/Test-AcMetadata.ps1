Function Test-AcMetadata {
    <#
        .SYNOPSIS
            Returns True|False if all specified properties have metadata
            Enabling filtering an array returned from Get-AcFileMetadata for files with metadata
    #>
    [CmdletBinding(SupportsShouldProcess = $False)]
    [OutputType([Array])]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $False)]
        [object]$obj
    )
    ForEach ($Property in 'Vendor', 'Company', 'Product', 'Description') {
        Write-Verbose "Testing $($obj.Path)"
        If ($obj.$Property -ge 2) { Return $True }
    }
    Return $False
}