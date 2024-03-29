function Select-AcUniqueMetadata {
    <#
        .SYNOPSIS
            Filters the output from Get-AcFileMetaData for files with unique metadata.

        .DESCRIPTION
            Filters the output from Get-AcFileMetaData for files with unique metadata, filtering on Company, Product and Description.

        .NOTES
            Author: Aaron Parker
            Twitter: @stealthpuppy

        .LINK
            https://github.com/Insentra/ApplicationControl

        .OUTPUTS
            System.Array

        .PARAMETER FileList
            An array of files with metadata returned from Get-AcFileMetadata

        .EXAMPLE
            Get-AcFileMetadata -Path "C:\Users\Aaron\AppData\Local\Microsoft\Teams" | Select-AcUniqueMetadata

            Description:
            Filters the list of files and metadata trawled from "C:\Users\Aaron\AppData\Local\Microsoft\Teams" by passing it to Select-AcUniqueMetadata
    #>
    [CmdletBinding(SupportsShouldProcess = $False)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Justification="Metadata is a singular noun")]
    [OutputType([System.Array])]
    param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $False, `
                HelpMessage = 'Provide an array of files with metadata.')]
        [ValidateNotNullOrEmpty()]
        [System.Array]$FileList
    )
    begin {
        # Initiate an array to return on the pipeline
        $Output = @()
    }
    process {
        # Filter the array via Company first (the most likely unique property) and then Product and Description
        $Company = $FileList | Sort-Object -Property Company -Descending | Group-Object -Property Company
        $Group = $Company.Group | Sort-Object -Property Product -Descending | Group-Object Product, Description
        for ($i = 0; $i -le ($Group.Count - 1); $i++) {
            $Output += $Group[$i].Group | Select-Object -First 1
        }
    }
    end {
        # Return the filtered array to the pipeline
        $Output
    }
}
