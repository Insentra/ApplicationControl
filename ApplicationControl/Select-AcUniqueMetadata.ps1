# Requires -Version 2
Function Select-AcUniqueMetadata {
    <#
        .SYNOPSIS
            Filters the output from Get-AcFileMetaData for files with unique metadata.
            
        .DESCRIPTION
            Filters the output from Get-AcFileMetaData for files with unique metadata, filtering on Company, Product and Description.
        
        .NOTES
            Name: Select-AcUniqueMetadata
            Author: Aaron Parker
            Twitter: @stealthpuppy
  
        .LINK
            https://stealthpuppy.com
  
        .OUTPUTS
            System.Array
  
        .PARAMETER Files
            An array of files with metadata returned from Get-AcFileMetadata
  
        .EXAMPLE
            Get-AcFileMetadata -Path "C:\Users\Aaron\AppData\Local\Microsoft\Teams" | Select-AcUniqueMetadata
  
            Description:
            Filters the list of files and metadata trawled from "C:\Users\Aaron\AppData\Local\Microsoft\Teams" by passing it to Select-AcUniqueMetadata
#>
    [CmdletBinding(SupportsShouldProcess = $False)]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True, `
                HelpMessage = 'Provide an array of files with metadata.')]
        [ValidateNotNullOrEmpty()]
        [array]$Files
    )
    Begin {
        # Initiate an array to return on the pipeline
        $Output = @()
    }
    Process {
        # Filter the array via Company first (the most likely unique property) and then Product and Description
        ForEach ($Company in ($Files | Sort-Object -Property Company -Descending | Group-Object -Property Company)) {
            ForEach ($Group in ($Company.Group | Group-Object Product, Description)) {
                $Output += $Group.Group | Select-Object -Unique
            }
        }
    }
    End {
        # Return the filtered array to the pipeline
        $Output
    }
}