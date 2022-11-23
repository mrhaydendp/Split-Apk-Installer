# Appinstaller Function: Detect if Selected File is an Apk or Split Apk & Adjust Installation Method
function appinstaller {
    if ("$args" -like '*.apk'){
        adb install -r -g "$args" | Out-Host
    } elseif ("$args" -like '*.apkm'){
        Copy-Item "$args" -Destination "$args.zip"
        Expand-Archive "$args.zip" -DestinationPath .\Split
        adb install-multiple (Get-ChildItem .\Split\*apk)
        Remove-Item -r .\Split, "$args.zip"
    }
}

# File Dialog
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
$FileBrowser.Title = "Select Split APK(s) to Install"
$FileBrowser.Filter = "Split APK File (*.apkm)|*.apkm|Apk File (*.apk)|*.apk"
$FileBrowser.Multiselect = "True"
[void]$FileBrowser.ShowDialog()

# Run Appinstaller Function for Each File
foreach ($file in $FileBrowser.FileNames){
    appinstaller "$file"
}
