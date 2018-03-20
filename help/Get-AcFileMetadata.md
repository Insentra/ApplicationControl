---
external help file: ApplicationControl-help.xml
Module Name: ApplicationControl
online version: https://github.com/Insentra/ApplicationControl
schema: 2.0.0
---

# Get-AcFileMetadata

## SYNOPSIS
Get file metadata from files in a target folder.

## SYNTAX

```
Get-AcFileMetadata [-Path] <String[]> [[-Include] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Retreives file metadata from files in a target path, or file paths, to display information on the target files.
Useful for understanding application files and identifying metadata stored in them.
Enables the administrator to view metadata for application control scenarios.

## EXAMPLES

### EXAMPLE 1
```
Get-FileMetadata -Path "C:\Users\aaron\AppData\Local\GitHubDesktop"
```

Description:
Scans the folder specified in the Path variable and returns the metadata for each file.

## PARAMETERS

### -Path
A target path in which to scan files for metadata.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: FullName, PSPath

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Include
Gets only the specified items.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Filter

Required: False
Position: 2
Default value: @('*.exe', '*.dll')
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [System.Array]

## NOTES
Author: Aaron Parker
Twitter: @stealthpuppy

## RELATED LINKS

[https://github.com/Insentra/ApplicationControl](https://github.com/Insentra/ApplicationControl)

