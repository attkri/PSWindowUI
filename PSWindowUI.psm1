Get-ChildItem "$PSScriptRoot\Public\*.ps1" -Exclude '*.Tests.ps1' -PipelineVariable cmdlet |  ForEach-Object -Process {
    . $cmdlet.FullName
}

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {}
