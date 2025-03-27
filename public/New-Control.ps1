using namespace 'System.Windows.Markup'
using namespace 'System.Windows.Controls'

Add-Type -AssemblyName PresentationFramework

enum ControlType {
    CheckBox
    ComboBox
    Headline
    TextBox
}

<#
.SYNOPSIS
Creates a new UI control based on the specified control type.

.DESCRIPTION
The `New-Control` function generates a WPF UI control dynamically based on the provided `ControlType`. 
It supports creating Headline, TextBox, CheckBox, and ComboBox controls. The function uses XAML to define 
the control layout and allows customization of properties such as name, value, and value delimiter.

.PARAMETER ControlType
Specifies the type of control to create. Supported types are:
- Headline
- TextBox
- CheckBox
- ComboBox

.PARAMETER Name
Specifies the name or label of the control. This is used as the text for labels or headlines.

.PARAMETER Value
Specifies the value of the control. For ComboBox, this can be a delimited string of items.

.PARAMETER ValueDelimiter
Specifies the delimiter used to split the `Value` parameter into individual items for ComboBox controls.
The default delimiter is a comma (`,`).

.INPUTS
Accepts input from the pipeline by property name for `ControlType`, `Name`, and `Value`.

.OUTPUTS
Returns a WPF control object.

.EXAMPLES
# Example 1: Create a headline control
$Control = New-Control -ControlType Headline -Name "My Headline"

# Example 2: Create a TextBox control with a value
$Control = New-Control -ControlType TextBox -Name "Enter Text" -Value "Default Text"

# Example 3: Create a CheckBox control
$Control = New-Control -ControlType CheckBox -Name "Enable Feature" -Value $true

# Example 4: Create a ComboBox control with multiple items
$Control = New-Control -ControlType ComboBox -Name "Select Option" -Value "Option1,Option2,Option3"
#>
function New-Control {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ControlType]$ControlType,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [object]$Value,

        [string]$ValueDelimiter = ','
    )

    process {
        switch ($ControlType) {
            { $_ -eq [ControlType]::Headline } {
                $Xaml = @"
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Margin="5">
    <TextBlock x:Name="Headline" FontSize="12" FontWeight="Bold" Margin="5" />
</Grid> 
"@ 
                $BaseControl = [XamlReader]::Parse($Xaml)
        
                $Label = $BaseControl.FindName('Headline')
                $Label.Text = $Name
            }
            
            { $_ -eq [ControlType]::TextBox } {
                $Xaml = @"
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Margin="5">
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="200"/>
        <ColumnDefinition Width="200"/>
    </Grid.ColumnDefinitions>
    <Label x:Name="LabelControl" Content="Placeholder Label Text:" Margin="0 0 10 0" HorizontalContentAlignment="Right" />
    <TextBox x:Name="ValueControl" Grid.Column="1"/>
</Grid> 
"@
                $BaseControl = [XamlReader]::Parse($Xaml)
        
                $LabelControl = $BaseControl.FindName('LabelControl')
                $LabelControl.Content = $Name

                $ValueControl = $BaseControl.FindName('ValueControl')
                $ValueControl.Text = [string]$Value
            }
            
            { $_ -eq [ControlType]::CheckBox } {
                $Xaml = @"
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Margin="5">
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="200"/>
        <ColumnDefinition Width="200"/>
    </Grid.ColumnDefinitions>
    <Label x:Name="LabelControl" Margin="0 0 10 0"  HorizontalContentAlignment="Right" />
    <CheckBox x:Name="ValueControl" Grid.Column="1" VerticalAlignment="Center"  />
</Grid>
"@
                $BaseControl = [XamlReader]::Parse($Xaml)
        
                $LabelControl = $BaseControl.FindName('LabelControl')
                $LabelControl.Content = $Name

                $ValueControl = $BaseControl.FindName('ValueControl')
                $ValueControl.IsChecked = [bool]$Value
            }

            { $_ -eq [ControlType]::ComboBox } {
                $Xaml = @"
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Margin="5">
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="200"/>
        <ColumnDefinition Width="200"/>
    </Grid.ColumnDefinitions>
    <Label x:Name="LabelControl" Margin="0 0 10 0" HorizontalContentAlignment="Right" />
    <ComboBox x:Name="ValueControl" Grid.Column="1" />
</Grid>
"@
                $BaseControl = [XamlReader]::Parse($Xaml)
        
                $LabelControl = $BaseControl.FindName('LabelControl')
                $LabelControl.Content = $Name

                $ValueControl = $BaseControl.FindName('ValueControl')
                $ValueControl.DisplayMemberPath = 'Name'
                $ValueControl.SelectedValuePath = 'Value'

                $Items = $Value -split $ValueDelimiter
                foreach ($Item in $Items) {
                    $ValueControl.Items.Add([PSCustomObject]@{Name=$Item; Value=$Item}) | Out-Null
                }
            }
            
            default {
                throw "ControlType $ControlType is not supported."
            }
        }

        return $BaseControl
    }
}
