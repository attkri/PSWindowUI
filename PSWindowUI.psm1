Get-ChildItem "$PSScriptRoot\public\*.ps1" -Exclude '*.Tests.ps1' -PipelineVariable CmdletFile | ForEach-Object -Process {
    . $CmdletFile.FullName
}

Export-ModuleMember -Function New-Control, New-Window

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {}
