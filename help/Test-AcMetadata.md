---
external help file: ApplicationControl-help.xml
Module Name: ApplicationControl
online version: https://github.com/Insentra/ApplicationControl
schema: 2.0.0
---

# Test-AcMetadata

## SYNOPSIS
Returns True|False if all specified properties does or doesn't have metadata

## SYNTAX

```
Test-AcMetadata [-obj] <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns True|False if all specified properties does or doesn't have metadata. Return $True is the item has metadata we can act on; Return $False if the item does not have metadata. Enabling filtering an array returned from Get-AcFileMetadata for files with or without metadata.

## EXAMPLES

### EXAMPLE 1
```
$NoMetadata = $Files | Where-Object { (Test-AcMetadata $_) -eq $False }
```

Description:
Filters the items in $Files that do not have any metadata.

### EXAMPLE 2
```
$Metadata = $Files | Where-Object { Test-AcMetadata $_ }
```

Description:
Filters the items in $Files that do have metadata that we can use for white listing.

## PARAMETERS

### -obj
The array for which to test the metadata values.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Boolean

## NOTES
Author: Aaron Parker
Twitter: @stealthpuppy

## RELATED LINKS

[https://github.com/Insentra/ApplicationControl](https://github.com/Insentra/ApplicationControl)