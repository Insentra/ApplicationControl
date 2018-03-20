---
external help file: ApplicationControl-help.xml
Module Name: ApplicationControl
online version: https://github.com/Insentra/ApplicationControl
schema: 2.0.0
---

# Get-AcDigitalSignature

## SYNOPSIS
Get digital signatures from files in a target folder.

## SYNTAX

```
Get-AcDigitalSignature [[-Path] <String[]>] [[-Include] <String[]>] [-Unique] [<CommonParameters>]
```

## DESCRIPTION
Gets digital signatures from .exe and .dll files from a specified path and sub-folders.
Retreives the certificate thumbprint, certificate name, certificate expiry, certificate validity and file path and outputs the results.
Output includes files that are not signed.

## EXAMPLES

### EXAMPLE 1
```
Get-AcDigitalSignatures -Path "C:\Users\aaron\AppData\Local\GitHubDesktop"
```

Description:
Scans the folder specified in the Path variable and returns the digital signatures for each file.

### EXAMPLE 2
```
Get-DigitalSignatures -Path "C:\Users\aaron\AppData\Local\GitHubDesktop" -Unique
```

Description:
Scans the folder specified in the Path variable and returns the digital signatures for only the first file with a unique certificate.

## PARAMETERS

### -Path
A target path in which to scan files for digital signatures.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: FullName, PSPath

Required: False
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

### -Unique
By default the script will return all files and their certificate details.
Use -Unique to return the first listing for each unique certificate.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

