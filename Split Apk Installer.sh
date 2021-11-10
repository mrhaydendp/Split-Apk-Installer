# Select .apkm Files & Copy to Current Directory
split=$(zenity --file-selection --multiple --title="Select a Split Apk File" --file-filter="*.apkm")
echo "$split" | tr '|' '\n' | xargs -I file cp "file" ./

# For Every .apkm File in Current Directory: Unzip to Split Folder, Install With "adb install-multiple", Remove Split Folder & .apkm File
for apkm in ./*.apkm
do
    unzip "$apkm" -d ./Split
    adb install-multiple ./Split/*.apk
    rm -rf ./Split
    rm "$apkm"
done