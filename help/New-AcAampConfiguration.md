---
external help file: ApplicationControl-help.xml
Module Name: ApplicationControl
online version: https://github.com/Insentra/ApplicationControl
schema: 2.0.0
---

# New-AcAampConfiguration

## SYNOPSIS
Creates an Ivanti Application Control configuration from an array of inputs.

## SYNTAX

```
New-AcAampConfiguration [[-AccessibleFiles] <Array>] [[-TrustedVendors] <Array>] [-RegEx]
 [[-GroupRule] <String>] [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Works with Get-DigitalSignatures and Get-FileMetadata to create an Ivanti Application Control configuration.
Intended for making it easier to define an application and create a rule set automatically for copying into a detailed configuration.

Adds Accessible files and Accessible folders with metadata and Trusted Vendor certificates to the Everyone group rule.

## EXAMPLES

### EXAMPLE 1
```
New-AampConfiguration -AccessibleFiles $Files -Path "C:\Temp\Configuration.aamp"
```

Description:
Adds files and metadata in the array $Files to a new Application Control configuration at "C:\Temp\Configuration.aamp".

### EXAMPLE 2
```
New-AampConfiguration -AccessibleFiles $Files -RegEx
```

Description:
Adds files and metadata in the array $Files to a new Application Control configuration at the default path of "C:\Temp\Configuration.aamp".
With file paths treated as RegEx.

### EXAMPLE 3
```
New-AampConfiguration -TrustedVendors $SignedFiles -Path "C:\Temp\Configuration.aamp"
```

Description:
Adds Trusted Vendor certificates from the files in the array $SignedFiles to a new Application Control configuration at "C:\Temp\Configuration.aamp".

## PARAMETERS

### -AccessibleFiles
An array of files with metadata to add to the Allowed list.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -TrustedVendors
An array of signed files for extracting the certificate to add to the Trusted Vendors list.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RegEx
For AccessibleFiles, treat the paths as RegEx.

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

### -GroupRule
The Group rule to add the AccessibleFiles and TrustedVendors to.
Defaults to Everyone.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Everyone
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
A full file path to output the temporary Application Control configuration to.
Defaults to C:\Temp\Configuration.aamp

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: C:\Temp\Configuration.aamp
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [System.String]

## NOTES
Author: Aaron Parker
Twitter: @stealthpuppy

## RELATED LINKS

[https://github.com/Insentra/ApplicationControl](https://github.com/Insentra/ApplicationControl)

