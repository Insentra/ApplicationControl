# Module manifest for module 'ApplicationControl'
@{
    # Script module or binary module file associated with this manifest.
    RootModule            = 'ApplicationControl.psm1'
    
    # Version number of this module.
    ModuleVersion         = '1.0.0.29'
    
    # ID used to uniquely identify this module
    GUID                  = '7d896252-14ea-45a1-87e0-99d6aada4348'
    
    # Author of this module
    Author                = 'Aaron Parker'
    
    # Company or vendor of this module
    CompanyName           = 'stealthpuppy'
    
    # Copyright statement for this module
    Copyright             = '(c) 2018 stealthpuppy. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description           = 'This is a community project that is used to retreive application file metadata for creating application control / white listing rules.'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion     = '4.0'
    
    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''
    
    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''
    
    # Minimum version of Microsoft .NET Framework required by this module
    # DotNetFrameworkVersion = ''
    
    # Minimum version of the common language runtime (CLR) required by this module
    # CLRVersion = ''
    
    # Processor architecture (None, X86, Amd64) required by this module
    ProcessorArchitecture = 'None'
    
    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()
    
    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies    = @()
    
    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    ScriptsToProcess      = @()
    
    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess        = @()
    
    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess      = @()
    
    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()
    
    # Functions to export from this module
    FunctionsToExport     = @('Get-AcFileMetadata', 'Get-AcDigitalSignature', 'New-AcAampConfiguration')
    
    # Cmdlets to export from this module
    CmdletsToExport       = @()
    
    # Variables to export from this module
    VariablesToExport     = @()
    
    # Aliases to export from this module
    AliasesToExport       = @()
    
    # DSC resources to export from this module
    # DscResourcesToExport = @()
    
    # List of all modules packaged with this module
    # ModuleList = @()
    
    # List of all files packaged with this module
    FileList              = @()
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData           = @{
    
        PSData = @{
    
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = 'Digital Signatures', 'Certificates', 'Metadata', 'Ivanti', 'Ivanti Application Control', 'AppLocker'
    
            # A URL to the license for this module.
            LicenseUri = 'https://github.com/aaronparker/ApplicationControl/blob/master/LICENSE'
    
            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/aaronparker/ApplicationControl/'
    
            # A URL to an icon representing this module.
            IconUri    = 'https://stealthpuppy.com/wp-content/uploads/2015/03/noun_17977_cc.png'
    
            # Repository location
            RepositorySourceLocation = "https://github.com/aaronparker/ApplicationControl/"
            
            # ReleaseNotes of this module
            # ReleaseNotes = ''
    
            # External dependent modules of this module
            # ExternalModuleDependencies = ''
    
        } # End of PSData hashtable
        
    } # End of PrivateData hashtable
    
    # HelpInfo URI of this module
    # HelpInfoURI = ''
    
    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}