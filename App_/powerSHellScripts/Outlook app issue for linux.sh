#!/bin/bash

fix_outlook() {
    outlook_path="/mnt/c/Program Files (x86)/Microsoft Office/root/Office16/OUTLOOK.EXE"

    echo "Checking if Outlook is installed..."

    if [ ! -f "$outlook_path" ]; then
        echo "Outlook is NOT installed at expected path: $outlook_path"
        return 1
    fi

    echo "Stopping Outlook process..."
    taskkill //IM outlook.exe //F > /dev/null 2>&1

    echo "Waiting for processes to stop..."
    sleep 2

    echo "Deleting Outlook profile from registry..."
    reg delete "HKCU\\Software\\Microsoft\\Office\\16.0\\Outlook\\Profiles\\Outlook" /f > /dev/null 2>&1

    sleep 2

    echo "Starting Outlook..."
    "$outlook_path" > /dev/null 2>&1 &

    sleep 2

    if pgrep -f "OUTLOOK.EXE" > /dev/null; then
        echo "✅ Microsoft Outlook repair completed successfully."
    else
        echo "❌ Error: Unable to start Outlook."
    fi
}

fix_outlook

