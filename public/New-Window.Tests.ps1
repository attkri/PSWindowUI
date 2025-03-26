

. $PSScriptRoot\New-Control.ps1
. $PSScriptRoot\New-Window.ps1


$Content = @'
ControlType; Name; Value
Headline;Test Headline 1;
TextBox;Textbox Label 11;Textbox Default Text 1
TextBox;Textbox Label 12
CheckBox;Checkbox Label 31
Headline;Test Headline 2;
TextBox;Textbox Label 21;Textbox Default Text 3
TextBox;Textbox Label 22;Textbox Default Text 4
CheckBox;Checkbox Label 31;True
'@ | ConvertFrom-Csv -Delimiter ';' | New-Control 

New-Window -Title 'Test Window' -Height 400 -Width 600 -Content $Content | select -exp Content






