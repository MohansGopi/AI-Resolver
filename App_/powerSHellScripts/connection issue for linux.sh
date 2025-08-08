#!/bin/bash
echo "🔄 Resetting Network..."

# Disable and re-enable all interfaces (except loopback)
for interface in $(nmcli device status | awk '/connected/ && $1 != "lo" {print $1}'); do
  echo "🔌 Disabling $interface..."
  nmcli device disconnect "$interface"
  sleep 2
  echo "⚡ Enabling $interface..."
  nmcli device connect "$interface"
done

# Flush DNS (if systemd-resolved is running)
if command -v resolvectl &> /dev/null; then
  echo "🧹 Flushing DNS..."
  resolvectl flush-caches
fi

# Renew DHCP lease
echo "🔄 Renewing DHCP lease..."
sudo dhclient -r
sudo dhclient

# ✅ Ensure Network & Wi-Fi is turned ON
echo "📡 Ensuring Wi-Fi and networking are enabled..."
nmcli networking on
nmcli radio wifi on


echo "✅ Network reset complete."
