---
external help file: ApplicationControl-help.xml
Module Name: ApplicationControl
online version:
schema: 2.0.0
---

# ConvertTo-EnvironmentPath

## SYNOPSIS
Replaces strings in a file path with environment variables.
Internal ApplicationControl function

## SYNTAX

```
ConvertTo-EnvironmentPath [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Converts file paths into environment variables. Will convert full qualified paths to their corresponding environment variable.

Supports the following variables:
* %LOCALAPPDATA%
* %APPDATA%
* %TEMP%
* %ProgramData%
* %ProgramFiles%
* %ProgramFiles(x86)%
* %SystemRoot%
* %PUBLIC%

## EXAMPLES

### Example 1
```powershell
PS C:\> ConvertTo-EnvironmentPath -Path C:\Users\Aaron\AppData\Local\Microsoft\Teams
%LOCALAPPDATA%\Microsoft\Teams
```

Converts the standard folder 'C:\Users\Aaron\AppData\Local' in path C:\Users\Aaron\AppData\Local\Microsoft\Teams to '%LOCALAPPDATA%' resulting in %LOCALAPPDATA%\Microsoft\Teams

## PARAMETERS

### -Path
A fully qualified path for converting to an environment variable.


```yaml
Type: String
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
System.String

## OUTPUTS
System.String

## NOTES

## RELATED LINKS
