#requires -Version 7.4

using namespace 'System.Windows.Markup'
using namespace 'System.Windows.Controls'

Add-Type -AssemblyName PresentationFramework

enum ControlType {
    Headline
    TextBox
    CheckBox
}

function New-Control {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ControlType]$ControlType,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Value
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
    <Label x:Name="Label" Content="Placeholder Label Text:" Margin="0 0 10 0" HorizontalContentAlignment="Right" />
    <TextBox x:Name="ValueControl" Grid.Column="1"/>
</Grid> 
"@
                $BaseControl = [XamlReader]::Parse($Xaml)
        
                $Label = $BaseControl.FindName('Label')
                $Label.Content = $Name

                $ValueControl = $BaseControl.FindName('ValueControl')
                $ValueControl.Text = $Value
            }
            
            { $_ -eq [ControlType]::CheckBox } {
                $Xaml = @"
<Grid xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Margin="5">
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="200"/>
        <ColumnDefinition Width="200"/>
    </Grid.ColumnDefinitions>
    <Label x:Name="Label" Margin="0 0 10 0"  HorizontalContentAlignment="Right" />
    <CheckBox x:Name="ValueControl" Grid.Column="1" VerticalAlignment="Center"  />
</Grid>
"@
                $BaseControl = [XamlReader]::Parse($Xaml)
        
                $Label = $BaseControl.FindName('Label')
                $Label.Content = $Name

                $ValueControl = $BaseControl.FindName('ValueControl')
                $ValueControl.IsChecked = $Value
            }
            
            default {
                throw "ControlType $ControlType is not supported."
            }
        }

        return $BaseControl
    }
}
