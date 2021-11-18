#!/bin/powershell
Add-Type -AssemblyName System.Windows.Forms

# Select Split Apk File (.apkm)
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
$FileBrowser.filter = "Apkm (*.apkm)| *.apkm"
[void]$FileBrowser.ShowDialog()

# For Each File Selected Unzip and Install Split Configs
foreach($array in $FileBrowser.FileName)
{
    Copy-Item $array -Destination $array".zip"
    Expand-Archive $array".zip" -DestinationPath .\Split
    $file = (Get-ChildItem .\Split\*.apk)
    adb install-multiple $file
    Remove-Item -r .\Split
    Remove-Item $array".zip"
}
