[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification="Output is for testing only")]
[CmdletBinding()]
param()

# AppVeyor Testing
if (Test-Path 'env:GITHUB_WORKSPACE') {
    $projectRoot = $env:GITHUB_WORKSPACE
}
else {
    # Local Testing
    $projectRoot = "$(Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)\..\"
}

Describe "General project validation" {
    $scripts = Get-ChildItem "$projectRoot\ApplicationControl" -Recurse -Include *.ps1, *.psm1

    # TestCases are splatted to the script so we need hashtables
    $testCase = $scripts | ForEach-Object { @{file = $_ } }
    It "Script <file> should be valid PowerShell" -TestCases $testCase {
        param($file)

        $file.fullname | Should Exist

        $contents = Get-Content -Path $file.fullname -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }
    $scriptAnalyzerRules = Get-ScriptAnalyzerRule
    It "<file> should pass ScriptAnalyzer" -TestCases $testCase {
        param($file)
        $analysis = Invoke-ScriptAnalyzer -Path  $file.fullname -ExcludeRule @('PSAvoidGlobalVars', 'PSAvoidUsingConvertToSecureStringWithPlainText', 'PSAvoidUsingWMICmdlet') -Severity @('Warning', 'Error')

        foreach ($rule in $scriptAnalyzerRules) {
            if ($analysis.RuleName -contains $rule) {
                $analysis |
                Where-Object RuleName -EQ $rule -OutVariable failures |
                Out-Default
                $failures.Count | Should Be 0
            }
        }
    }
}

Describe "Function validation" {
    $scripts = Get-ChildItem "$projectRoot\ApplicationControl" -Recurse -Include *.ps1
    $testCase = $scripts | ForEach-Object { @{file = $_ } }
    It "Script <file> should only contain one function" -TestCases $testCase {
        param($file)
        $file.fullname | Should Exist
        $contents = Get-Content -Path $file.fullname -ErrorAction Stop
        $describes = [Management.Automation.Language.Parser]::ParseInput($contents, [ref]$null, [ref]$null)
        $test = $describes.FindAll( { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
        $test.Count | Should Be 1
    }
    It "<file> should match function name" -TestCases $testCase {
        param($file)
        $file.fullname | Should Exist
        $contents = Get-Content -Path $file.fullname -ErrorAction Stop
        $describes = [Management.Automation.Language.Parser]::ParseInput($contents, [ref]$null, [ref]$null)
        $test = $describes.FindAll( { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
        $test[0].name | Should Be $file.basename
    }
}
