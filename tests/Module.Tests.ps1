# AppVeyor Testing
if (Test-Path 'env:GITHUB_WORKSPACE') {
    $manifest = "$env:GITHUB_WORKSPACE\ApplicationControl\ApplicationControl.psd1"
    $module = "$env:GITHUB_WORKSPACE\ApplicationControl\ApplicationControl.psm1"
}
else {
    # Local Testing 
    $manifest = "$(Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)\..\ApplicationControl\ApplicationControl.psd1"
    $module = "$(Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)\..\ApplicationControl\ApplicationControl.psm1"
}

Describe 'Module Metadata Validation' {      
    It 'Script fileinfo should be OK' {
        { Test-ModuleManifest $manifest -ErrorAction Stop } | Should Not Throw
    }   
    It 'Import module should be OK' {
        { Import-Module $module -Force -ErrorAction Stop } | Should Not Throw
    }
}
