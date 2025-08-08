# reset_network.ps1
Write-Host "🔄 Resetting Network..."

$adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.InterfaceDescription -notmatch 'Loopback' }

foreach ($adapter in $adapters) {
    Write-Host "🔌 Disabling $($adapter.Name)..."
    Disable-NetAdapter -Name $adapter.Name -Confirm:$false
    Start-Sleep -Seconds 2
    Write-Host "⚡ Enabling $($adapter.Name)..."
    Enable-NetAdapter -Name $adapter.Name -Confirm:$false
}

Write-Host "🧹 Flushing DNS..."
ipconfig /flushdns | Out-Null

Write-Host "🔄 Releasing IP address..."
ipconfig /release | Out-Null

Write-Host "🔄 Renewing IP address..."
ipconfig /renew | Out-Null

Write-Host "✅ Network reset complete."
