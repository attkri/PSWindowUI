#
# Module manifest for module 'PSWindowUI'
# Generated by: Attila Krick
# Generated on: 26.03.2025
#

@{
    ModuleVersion        = '1.0.0'
    RootModule           = 'PSWindowUI.psm1'
    GUID                 = '915234ee-0e9a-4826-8a2c-5e11b1726fb9'
    
    Author               = 'Attila Krick'
    CompanyName          = 'ATTILAKRICK.COM'
    Copyright            = '2025 Attila Krick'
    Description          = 'A PowerShell module with cmdlets for creating user interfaces using WPF for data querying.'
    
    PowerShellVersion    = '7.4'
    CompatiblePSEditions = 'Desktop', 'Core'
    RequiredAssemblies   = 'PresentationFramework', 'PresentationCore', 'WindowsBase', 'System.Xaml'

    FileList             = @(
        'public/New-Control.ps1',
        'public/New-Window.ps1',
        'LICENSE',
        'PSWindowUI.psd1',
        'PSWindowUI.psm1',
        'README.md'
    )

    FunctionsToExport    = 'New-Window', 'New-Control'

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    #CmdletsToExport      = @()

    # Variables to export from this module
    #VariablesToExport    = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    #AliasesToExport      = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

    PrivateData          = @{

        PSData = @{
            ProjectUri               = 'https://github.com/attkri/PSWindowUI'
            Tags                     = 'Attila', 'WPF', 'Window', 'GUI', 'Control', 'UserInterface', 'UI', 'XAML', 'PresentationFramework'
            LicenseUri               = 'https://raw.githubusercontent.com/attkri/PSWindowUI/refs/heads/main/LICENSE'
            RequireLicenseAcceptance = $false
            # IconUri = '' # A URL to an icon representing this module.

            ReleaseNotes             = ''
        }
    }
}
