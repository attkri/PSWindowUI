#requires -Version 7.4

using namespace 'System.Windows.Markup'
using namespace 'System.Windows.Controls'

Add-Type -AssemblyName PresentationFramework

function New-Window {
    [CmdletBinding()]
    param (
        [string]$Title = 'User Interface',
        
        [ValidateRange(100, 2000)]
        [int]$Height = 300,
        
        [ValidateRange(100, 2000)]
        [int]$Width = 500,

        [ValidateNotNull()]
        [Parameter(ValueFromPipeline)]
        [Grid[]]$Content
    )

    begin {
        $WindowXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        WindowStartupLocation="CenterScreen" ResizeMode="CanResizeWithGrip">
    <Grid>
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="*"/>
                <RowDefinition Height="AUTO"/>
            </Grid.RowDefinitions>

            <ScrollViewer VerticalScrollBarVisibility="Disabled" HorizontalScrollBarVisibility="Auto">
                <WrapPanel x:Name="ContentWrapPanel" Orientation="Vertical" />
            </ScrollViewer>

            <Grid Grid.Row="1" Margin="5">
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" >
                    <Button x:Name="CancelButton" Content="Cancel" Padding="20 5 20 5" Margin="10" IsCancel="True" />
                    <Button x:Name="SubmitButton" Content="Submit" Padding="20 5 20 5" Margin="10" IsDefault="True" />
                </StackPanel>
            </Grid>
        </Grid>
    </Grid>
</Window>
"@
        $Window = [XamlReader]::Parse($WindowXaml)
        $Window.Title = $Title
        $Window.Height = $Height
        $Window.Width = $Width
        
        $ContentWrapPanel = $Window.FindName('ContentWrapPanel')
        
        $CancelButton = $Window.FindName('CancelButton')

        $SubmitButton = $Window.FindName('SubmitButton')
        $SubmitButton.Add_Click({
                $Window.DialogResult = $true
                $Window.Close()
            })
    }
    
    process {
        foreach ($item in $Content) {
            $ContentWrapPanel.Children.Add($item) | Out-Null
        }
    }
    end {
        $DialogResult = $Window.ShowDialog()
$Id = 1
        $ResultControlContent = @()
        foreach ($item in $Content) {
            
            if ($null -ne $item.FindName('Headline')) {
                continue
            }
            
            $Label = $item.FindName('Label')
            $Name = $Label.Content

            $ValueControl = $item.FindName('ValueControl')
            switch ($ValueControl) {
                { $_ -is [TextBox] } { $Value = $ValueControl.Text }
                { $_ -is [CheckBox] } { $Value = $ValueControl.IsChecked }
                Default { $Value = $null }
            }

            $ResultControlContent += [PSCustomObject]@{ Id = $Id++ ; Name = $Name ; Value = $Value }
        }

        $Result = [PSCustomObject]@{
            DialogResult = $DialogResult
            Content      = $ResultControlContent
        }
        return $Result
    }
}
