# Appinstaller Function: Detect if Selected File is an Apk or Split Apk & Adjusts Installation Method
function appinstaller {
    if ($args[0] -like '*.apk'){
        adb install -g $args[0]
    } elseif ($args[0] -like '*.apkm'){
        Copy-Item $args -Destination $args".zip"
        Expand-Archive $args".zip" -DestinationPath .\Split
        $file = (Get-ChildItem .\Split\*.apk)
        adb install-multiple -g "$file" | Out-Host
        Remove-Item -r .\Split
        Remove-Item $args".zip"
    } else {
        Write-Host $args[0] "Is Unsupported"
    }
}

# Open File Dialog
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
$FileBrowser.Title = "Select Split APK(s) to Install"
$FileBrowser.Filter = "Split APK File (*.apkm)|*.apkm|Apk File (*.apk)|*.apk|All Files (*.*)|*.*"
$FileBrowser.Multiselect = "True"
[void]$FileBrowser.ShowDialog()

# Loops Appinstaller for Each File
foreach ($file in $FileBrowser.FileNames){
    appinstaller "$file"
}
