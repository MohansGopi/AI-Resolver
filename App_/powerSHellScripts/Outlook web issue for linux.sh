#!/bin/bash

echo "🔧 Fixing Outlook Web (OWA)..."

OUTLOOK_DOMAIN="outlook.live.com"
USER_PROFILE="$HOME"
REAL_USER=$(logname)

# 🔹 Clear Chrome cache for Outlook
clear_chrome() {
    echo "🧹 Clearing Chrome data for $OUTLOOK_DOMAIN..."
    sqlite3 "$USER_PROFILE/.config/google-chrome/Default/Cookies" \
        "DELETE FROM cookies WHERE host_key LIKE '%$OUTLOOK_DOMAIN%';" 2>/dev/null
    rm -rf "$USER_PROFILE/.cache/google-chrome/Default/Cache"/* 2>/dev/null
}

# 🔹 Get Firefox profile path (Native, Snap, Flatpak)
get_firefox_profile() {
    local profile_dir="/home/$REAL_USER/.mozilla/firefox"
    local profiles_ini="$profile_dir/profiles.ini"

    if [ ! -f "$profiles_ini" ]; then
        echo "⚠️ Firefox profiles.ini not found. Creating default profile..."

        # Prepare minimal env for user
        sudo -u "$REAL_USER" env \
            HOME="/home/$REAL_USER" \
            DISPLAY=":0" \
            XAUTHORITY="/home/$REAL_USER/.Xauthority" \
            XDG_RUNTIME_DIR="/run/user/$(id -u $REAL_USER)" \
            firefox --headless -CreateProfile "default" >/dev/null 2>&1
    fi

    if [ -f "$profiles_ini" ]; then
        local profile=$(grep -A1 "\[Profile0\]" "$profiles_ini" | grep "Path=" | cut -d= -f2)
        if [ -n "$profile" ]; then
            local full_path="$profile_dir/$profile"
            if [ -d "$full_path" ]; then
                echo "$full_path"
                return
            fi
        fi
    fi

    echo ""
}




# 🔹 Close Firefox automatically
close_firefox() {
    echo "📴 Attempting to close Firefox..."
    FIREFOX_PIDS=$(pgrep -u "$REAL_USER" firefox)

    if [ -n "$FIREFOX_PIDS" ]; then
        echo "❌ Firefox is running. Force closing..."
        sudo -u "$REAL_USER" pkill -9 firefox

        while pgrep -u "$REAL_USER" firefox > /dev/null; do
            echo "⏳ Waiting for Firefox to close..."
            sleep 2
        done
        echo "✅ Firefox has been closed."
    else
        echo "✅ Firefox is already closed."
    fi
}


# 🔹 Clear Firefox cache for Outlook
clear_firefox() {
    close_firefox

    echo "🧹 Attempting to clear Firefox data for $OUTLOOK_DOMAIN..."
    profile=$(get_firefox_profile)
    echo "Detected Firefox profile: $profile"
    if [ -n "$profile" ] && [ -d "$profile" ]; then
        echo "Detected Firefox profile: $profile"
        sqlite3 "$profile/cookies.sqlite" \
            "DELETE FROM moz_cookies WHERE host LIKE '%$OUTLOOK_DOMAIN%';" 2>/dev/null
        rm -rf "$profile/cache2"/* 2>/dev/null
    else
        echo "❌ Firefox profile not found — skipping Firefox cleanup."
    fi
}

# 🔹 Clear Edge cache for Outlook
clear_edge() {
    echo "🧹 Clearing Edge data for $OUTLOOK_DOMAIN..."
    sqlite3 "$USER_PROFILE/.config/microsoft-edge/Default/Cookies" \
        "DELETE FROM cookies WHERE host_key LIKE '%$OUTLOOK_DOMAIN%';" 2>/dev/null
    rm -rf "$USER_PROFILE/.cache/microsoft-edge/Default/Cache"/* 2>/dev/null
}

# 🔁 Flush DNS
flush_dns() {
    echo "🔁 Attempting to flush DNS cache..."
    if command -v systemd-resolve &>/dev/null; then
        sudo systemd-resolve --flush-caches
    elif command -v resolvectl &>/dev/null; then
        sudo resolvectl flush-caches
    elif command -v ipconfig &>/dev/null; then
        ipconfig /flushdns
    else
        echo "⚠️ No supported DNS flush method found."
    fi
}

# 🚀 Run All Cleanup Steps
clear_chrome
clear_firefox
clear_edge
flush_dns

echo "✅ Outlook Web cache cleanup completed."
