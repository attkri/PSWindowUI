using namespace 'System.Windows.Markup'
using namespace 'System.Windows.Controls'

Add-Type -AssemblyName PresentationFramework

<#
.SYNOPSIS
Creates a new WPF window with a specified title, height, width, and content.

.DESCRIPTION
This function creates a new WPF window with a specified title, height, width, and content. The content is provided as an array of controls created using the New-Control function.
The window includes a cancel and submit button, and returns the dialog result and content when the window is closed.
The content is displayed in a scrollable area, and the window can be resized.

.PARAMETER Title
The title of the window. Default is 'User Interface'.

.PARAMETER Height
The height of the window in pixels. Must be between 100 and 2000. Default is 700.

.PARAMETER Width
The width of the window in pixels. Must be between 100 and 2000. Default is 450.

.PARAMETER Content
An array of controls to be displayed in the window. The controls are created using the New-Control function.

.EXAMPLE
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

The first part of the script creates a multi-line string $Content that represents a table of control definitions. Each row in the table specifies a control type (e.g., Headline, TextBox, ComboBox, CheckBox), its label or name, and optionally its value or additional properties. The table is formatted as CSV (Comma-Separated Values) but uses a semicolon (;) as the delimiter. This string is then piped into the ConvertFrom-Csv cmdlet, which converts it into a structured object array where each row becomes an object with properties corresponding to the column headers (ControlType, Name, Value).

The resulting object array is passed to the New-Control cmdlet. While the implementation of New-Control is not shown, it likely processes the object array to create GUI controls based on the specified properties (e.g., creating text boxes, combo boxes, checkboxes, and headlines).

The second part of the script uses the New-Window cmdlet to create a new window. The -Title parameter sets the window's title to "Test Window", and the -Height and -Width parameters define the window's dimensions (400 pixels tall and 600 pixels wide). The -Content parameter is used to pass the $Content object, which contains the controls defined earlier. The -Verbose flag is included to provide detailed output during execution, which can be useful for debugging or understanding the process.

In summary, this script defines a GUI window with various controls and properties in a declarative manner using CSV data. It leverages custom cmdlets to convert the data into GUI elements and render them in a window. This approach is modular and makes it easy to modify the GUI by simply updating the CSV content.
#>
function New-Window {
    [CmdletBinding()]
    param (
        [string]$Title = 'User Interface',
        
        [ValidateRange(100, 2000)]
        [int]$Height = 700,
        
        [ValidateRange(100, 2000)]
        [int]$Width = 450,

        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateCount(1, 100)]
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
        "Window Size: $($Window.ActualHeight) x $($Window.ActualWidth)" | Write-Verbose

        $Id = 1
        $ResultControlContent = @()
        foreach ($item in $Content) {
            
            if ($null -ne $item.FindName('Headline')) {
                continue
            }
            
            $LabelControl = $item.FindName('LabelControl')
            $Name = $LabelControl.Content

            $ValueControl = $item.FindName('ValueControl')
            switch ($ValueControl) {
                { $_ -is [TextBox] } { $Value = $ValueControl.Text }
                { $_ -is [CheckBox] } { $Value = $ValueControl.IsChecked }
                { $_ -is [ComboBox] } { $Value = $ValueControl.SelectedValue }
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
