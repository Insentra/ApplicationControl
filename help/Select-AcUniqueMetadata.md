---
external help file: ApplicationControl-help.xml
Module Name: ApplicationControl
online version: https://github.com/Insentra/ApplicationControl
schema: 2.0.0
---

# Select-AcUniqueMetadata

## SYNOPSIS
Filters the output from Get-AcFileMetaData for files with unique metadata.

## SYNTAX

```
Select-AcUniqueMetadata [-FileList] <Array> [<CommonParameters>]
```

## DESCRIPTION
Filters the output from Get-AcFileMetaData for files with unique metadata, filtering on Company, Product and Description.

## EXAMPLES

### EXAMPLE 1
```
Get-AcFileMetadata -Path "C:\Users\Aaron\AppData\Local\Microsoft\Teams" | Select-AcUniqueMetadata
```

Description:
Filters the list of files and metadata trawled from "C:\Users\Aaron\AppData\Local\Microsoft\Teams" by passing it to Select-AcUniqueMetadata

## PARAMETERS

### -FileList
An array of files with metadata returned from Get-AcFileMetadata

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Array

## NOTES
Author: Aaron Parker
Twitter: @stealthpuppy

## RELATED LINKS

[https://github.com/Insentra/ApplicationControl](https://github.com/Insentra/ApplicationControl)

