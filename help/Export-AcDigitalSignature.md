---
external help file: ApplicationControl-help.xml
Module Name: ApplicationControl
online version: https://github.com/Insentra/ApplicationControl
schema: 2.0.0
---

# Export-AcDigitalSignature

## SYNOPSIS
Exports a digital signature certificate from a signed file.

## SYNTAX

```
Export-AcDigitalSignature [-Path] <String[]> [-Destination <String>] [<CommonParameters>]
```

## DESCRIPTION
Exports a digital signature certificate from a signed file to a specified folder.

## EXAMPLES

### EXAMPLE 1
```
Export-AcDigitalSignature -Path "C:\Users\aaron\AppData\Local\GitHubDesktop\GitHubDesktop.exe" -Destination C:\Temp
```

Description:
Exports the digital signature from "C:\Users\aaron\AppData\Local\GitHubDesktop\GitHubDesktop.exe" to a P7B certificate file in C:\Temp

### EXAMPLE 2
```
Get-DigitalSignatures -Path "C:\Users\aaron\AppData\Local\GitHubDesktop" -Unique | Export-AcDigitalSignature -Destination C:\Temp
```

Description:
Exports all of the unique digital certificates from "C:\Users\aaron\AppData\Local\GitHubDesktop" to C:\Temp.

## PARAMETERS

### -Path
A file or list of files from which to export the digital certificate.

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

### -Destination
A destination folder to export the certificate files to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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