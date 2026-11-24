#!/usr/bin/env bash
set -euo pipefail

# Replace built-in luci-app-athena-led with NONGFAH version
rm -rf package/emortal/luci-app-athena-led \
       package/luci-app-athena-led \
       feeds/luci/applications/luci-app-athena-led \
       package/feeds/luci/luci-app-athena-led
git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
chmod +x package/luci-app-athena-led/root/etc/init.d/athena_led \
         package/luci-app-athena-led/root/usr/sbin/athena-led

# Extra packages: only enable for the IPQ60XX 6.12 WiFi profile
if [ "${CONFIG_FILE:-}" = "configs/ipq60xx-6.12-wifi.config" ]; then
  # NetSpeedTest (sparse clone from sbwml/openwrt_pkgs)
  rm -rf package/new/custom \
         package/new/luci-app-netspeedtest \
         package/new/speedtest-cli \
         package/feeds/*/luci-app-netspeedtest \
         package/feeds/*/speedtest-cli
  mkdir -p package/new
  git clone --depth=1 --filter=blob:none --sparse https://github.com/sbwml/openwrt_pkgs.git package/new/custom
  git -C package/new/custom sparse-checkout set luci-app-netspeedtest speedtest-cli
  mv package/new/custom/luci-app-netspeedtest package/new/custom/speedtest-cli package/new/
  rm -rf package/new/custom
fi
