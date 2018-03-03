# Requires -Version 3
Function Export-P7bFile {
    <#
        .SYNOPSIS
        Exports certificates to P7B files.
        Internal ApplicationControl function
    #>
    Param (
        [string]$File,
        [string]$Path
    )
    If (Get-Module -Name PKI -ErrorAction SilentlyContinue) {
        $cert = (Get-AuthenticodeSignature $File).SignerCertificate
        Write-Verbose "Exporting certificate: $Path\$($cert.Thumbprint).p7b"
        Export-Certificate -Cert $cert -FilePath "$Path\$($cert.Thumbprint).p7b" -Type P7B    
    }
    Else {
        Write-Verbose "Missing module PKI. Unable to export certificate."
        $Null
    }
}