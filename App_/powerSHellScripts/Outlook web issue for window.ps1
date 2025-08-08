Write-Host "🔧 Fixing Outlook Web (OWA)..."

$OutlookDomain = "outlook.live.com"

# 🔹 Clear Chrome cache for Outlook
function Clear-Chrome {
    Write-Host "🧹 Clearing Chrome data for $OutlookDomain..."

    $chromeCookies = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies"
    $chromeCache = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"

    if (Test-Path $chromeCookies) {
        try {
            sqlite3 $chromeCookies "DELETE FROM cookies WHERE host_key LIKE '%$OutlookDomain%';" 2>$null
        } catch {
            Write-Host "⚠️ Chrome SQLite DB might be locked or inaccessible."
        }
    }

    if (Test-Path $chromeCache) {
        Remove-Item "$chromeCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 🔹 Clear Firefox cache for Outlook
function Clear-Firefox {
    Write-Host "📴 Attempting to close Firefox..."
    Stop-Process -Name "firefox" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2

    $profileRoot = "$env:APPDATA\Mozilla\Firefox\Profiles"
    if (-Not (Test-Path $profileRoot)) {
        Write-Host "❌ Firefox profile directory not found — skipping Firefox cleanup."
        return
    }

    $profile = Get-ChildItem $profileRoot | Where-Object { $_.Name -match "\.default" } | Select-Object -First 1
    if (-Not $profile) {
        Write-Host "⚠️ Firefox profile not found. Trying to create one..."

        try {
            Start-Process -FilePath "firefox.exe" -ArgumentList "-CreateProfile default" -NoNewWindow -Wait
        } catch {
            Write-Host "❌ Failed to create Firefox profile."
            return
        }

        $profile = Get-ChildItem $profileRoot | Where-Object { $_.Name -match "\.default" } | Select-Object -First 1
    }

    if ($profile) {
        $cookiesPath = Join-Path $profile.FullName "cookies.sqlite"
        $cachePath = Join-Path $profile.FullName "cache2"

        if (Test-Path $cookiesPath) {
            try {
                sqlite3 $cookiesPath "DELETE FROM moz_cookies WHERE host LIKE '%$OutlookDomain%';" 2>$null
            } catch {
                Write-Host "⚠️ Firefox cookies DB might be locked."
            }
        }

        if (Test-Path $cachePath) {
            Remove-Item "$cachePath\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    } else {
        Write-Host "❌ Firefox profile not found — skipping Firefox cleanup."
    }
}

# 🔹 Clear Edge cache for Outlook
function Clear-Edge {
    Write-Host "🧹 Clearing Edge data for $OutlookDomain..."

    $edgeCookies = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cookies"
    $edgeCache = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"

    if (Test-Path $edgeCookies) {
        try {
            sqlite3 $edgeCookies "DELETE FROM cookies WHERE host_key LIKE '%$OutlookDomain%';" 2>$null
        } catch {
            Write-Host "⚠️ Edge SQLite DB might be locked."
        }
    }

    if (Test-Path $edgeCache) {
        Remove-Item "$edgeCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 🔁 Flush DNS
function Flush-DNS {
    Write-Host "🔁 Attempting to flush DNS cache..."
    ipconfig /flushdns | Out-Null
}

# 🚀 Run all steps
Clear-Chrome
Clear-Firefox
Clear-Edge
Flush-DNS

Write-Host "✅ Outlook Web cache cleanup completed."
