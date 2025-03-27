Describe "Module PSWindowUI Tests" {
    Context 'Basis Modul Testing' {

        $testCases = Get-ChildItem "$PSScriptRoot\Public\*.ps1" -File -Force | ForEach-Object -Process { return @{ Path=$_.FullName } }

        It "Skript '<Path>' enthält keine Fehler." -TestCases $testCases  {
            $contents = Get-Content -Path $Path -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
            $errors.Count | Should -Be 0
        }

        It "Das Modul PSWindowUI kann ohne Probleme importiert werden." {
            Remove-Module -Name 'PSWindowUI' -Force -ErrorAction Ignore -WarningAction Ignore
            { Import-Module -Name "$PSScriptRoot\PSWindowUI.psd1" -Force } | Should -Not -Throw
        }

        It "Das Module PSWindowUI kann ohne Probleme  entladen werden." {
            Import-Module -Name "$PSScriptRoot\PSWindowUI.psd1" -Force
            { Remove-Module -Name 'PSWindowUI' -Force } | Should -Not -Throw
        }
    }
    Context 'Modul-Manifest Tests' {

        It 'Modul-Version ist Neu' {
            Test-ModuleManifest -Path "$PSScriptRoot\PSWindowUI.psd1" | Select-Object -ExpandProperty Version | Should -GE '1.0'
        }
        It 'Module Manifest ist erfolgreich validiert.' {
            { Test-ModuleManifest -Path "$PSScriptRoot\PSWindowUI.psd1" -ErrorAction Stop -WarningAction SilentlyContinue } | Should -Not -Throw
        }
        It 'Modul-Name ist PSWindowUI.' {
            Test-ModuleManifest -Path "$PSScriptRoot\PSWindowUI.psd1" | Select-Object -ExpandProperty Name | Should -Be 'PSWindowUI'
        }
        It 'Modul-Description ist vorhanden.' {
            Test-ModuleManifest -Path "$PSScriptRoot\PSWindowUI.psd1" | Select-Object -ExpandProperty Description | Should -Not -BeNullOrEmpty
        }
        It 'Module-Root steht auf PSWindowUI.psm1.' {
            Test-ModuleManifest -Path "$PSScriptRoot\PSWindowUI.psd1" | Select-Object -ExpandProperty RootModule | Should -Be 'PSWindowUI.psm1'
        }
        It 'Modul GUID ist cb790b27-dcec-458f-888d-47d9e7c6599d.' {
            Test-ModuleManifest -Path "$PSScriptRoot\PSWindowUI.psd1" | Select-Object -ExpandProperty Guid | Should -Be '915234ee-0e9a-4826-8a2c-5e11b1726fb9'
        }
    }
    Context 'Exported Functions' {
        BeforeAll {
            Import-Module -Name $PSScriptRoot
            $Script:Manifest = Test-ModuleManifest -Path "$PSScriptRoot\PSWindowUI.psd1"
        }
        AfterAll {
            Remove-Module -Name 'PSWindowUI' -Force -ErrorAction Ignore
        }
        It "Function Public\<FunctionName>.ps1 als ExportedFunction <FunctionName> im Manifest hinterlegt." -TestCases (
            Get-ChildItem -Path "$PSScriptRoot\public\*.ps1" -Exclude '*.Tests.ps1' | Select-Object -ExpandProperty Name | Foreach-Object -Process {
            @{ FunctionName = $_.Replace('.ps1', '') 
        }
        }) {
            $ManifestFunctions = Test-ModuleManifest -Path "$PSScriptRoot\PSWindowUI.psd1" | Select-Object -ExpandProperty ExportedFunctions | Select-Object -ExpandProperty Keys
            $FunctionName -in $ManifestFunctions | Should -Be $true
        }
        It "Ist die <FunctionName> im function:\-Laufwerk enthalten?" -TestCases (Get-Command -Module 'PSWindowUI' -CommandType Function | ForEach-Object -Process {
            @{ FunctionName = $_.Name }
        }) {
            param(
                $FunctionName
            )

            Get-Item -Path "function:\$FunctionName" | Select-Object -ExpandProperty Name | Should -BeExactly $FunctionName
        }
        It "Ist die Manifest-Funktion <FunctionName> als Public\<FunctionName>.ps1 enthalten?" -TestCases (
            Test-ModuleManifest -Path "$PSScriptRoot\PSWindowUI.psd1" | Select-Object -ExpandProperty ExportedFunctions | Select-Object -ExpandProperty Keys | ForEach-Object -Process { @{ FunctionName = $_ } }
            ) {
            param(
                $FunctionName
            )
            Test-Path -Path "$PSScriptRoot\Public\$FunctionName.ps1" | Should -BeTrue
        }
    }
}
