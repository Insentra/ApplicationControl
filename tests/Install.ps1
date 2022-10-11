<#
    .SYNOPSIS
        AppVeyor tests setup script.
#>
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification="Output is for testing only")]
[CmdletBinding()]
param()

# Line break for readability in AppVeyor console
Write-Host -Object ''
Write-Host "PowerShell Version:" $PSVersionTable.PSVersion.ToString()

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Pester -Force
Install-Module -Name PSScriptAnalyzer -Force
Install-Module -Name posh-git -Force

# Import the ApplicationControl module
if (Test-Path 'env:GITHUB_WORKSPACE') {
    $ProjectRoot = $env:GITHUB_WORKSPACE
}
else {
    # Local Testing
    $ProjectRoot = "$(Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)\..\"
}
Import-Module "$projectRoot\ApplicationControl" -Verbose -Force
