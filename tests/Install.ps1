<#
    .SYNOPSIS
        AppVeyor tests setup script.
#>
[string[]]$PowerShellModules = @("Pester", "posh-git", "PSScriptAnalyzer")
[string[]]$PackageProviders = @('NuGet', 'PowerShellGet')

# Line break for readability in AppVeyor console
Write-Host -Object ''
Write-Host "PowerShell Version:" $PSVersionTable.PSVersion.tostring()

# Install the PowerShell Modules
ForEach ($Module in $PowerShellModules) {
    Write-Verbose "Installing module: $($Module)"
    Install-Module $Module -Scope CurrentUser -Force -Repository PSGallery
    Import-Module $Module -Force
}

# Install package providers for PowerShell Modules
ForEach ($Provider in $PackageProviders) {
    Write-Verbose "Installing provider: $($Provider)"
    Install-PackageProvider $Provider -Force -ForceBootstrap -Scope CurrentUser
}

# Import the ApplicationControl module
If (Test-Path 'env:APPVEYOR_BUILD_FOLDER') {
    $ProjectRoot = $env:APPVEYOR_BUILD_FOLDER
}
Else {
    # Local Testing 
    $ProjectRoot = "$(Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)\..\"
}
Import-Module "$projectRoot\ApplicationControl" -Verbose -Force