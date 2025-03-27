$ErrorActionPreference = 'Stop'

. $PSScriptRoot\New-Control.ps1
. $PSScriptRoot\New-Window.ps1

$Content = @'
ControlType; Name; Value
Headline;Headline ONE;
TextBox;Label-Text 11
TextBox;Label-Text 12;Default-Value 12
ComboBox;ComboBox Label 24;Wert A,Wert B,Wert C
Headline;Headline TWO;
CheckBox;Label-Text 21
CheckBox;Label-Text 22;True
'@ | ConvertFrom-Csv -Delimiter ';' | New-Control 
New-Window -Title 'Test Window' -Height 400 -Width 600 -Content $Content -Verbose
