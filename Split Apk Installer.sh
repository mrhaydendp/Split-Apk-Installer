#!/usr/bin/env sh

# Change Application Installation Method Based on the File Type
appinstaller () {
    case "$1" in
    *.apk)
        adb install -g "$1";;
    *.apkm)
        unzip "$1" -d ./Split
        adb install-multiple -g ./Split/*.apk
        rm -rf ./Split;;
    esac
}

# Open File Dialog
split=$(zenity --file-selection \
--multiple --title="Select Split APK(s) to Install" \
--file-filter="*.apk*" | tr '|' '\n')

# Copy Selected Files to Current Directory & Run Through Appinstaller
if [ "$split" != "" ]; then
    echo "$split" | xargs -I file cp "file" ./
    for app in ./*.apk*
    do
        appinstaller "$app"
        rm "$app"
    done
fi
