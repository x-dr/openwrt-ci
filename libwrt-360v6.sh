#!/usr/bin/env bash
set -euo pipefail

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
