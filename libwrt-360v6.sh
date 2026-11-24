#!/usr/bin/env bash
set -euo pipefail

# Clean up any leftover NetSpeedTest packages
rm -rf package/new/custom \
       package/new/luci-app-netspeedtest \
       package/new/speedtest-cli \
       package/feeds/*/luci-app-netspeedtest \
       package/feeds/*/speedtest-cli

# Add official Nikki feed (see 360V6-HomeProxy-Nikki-Analysis.md §8.2)
NIKKI_FEED='src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main'
grep -q '^src-git nikki ' feeds.conf.default || echo "$NIKKI_FEED" >> feeds.conf.default

# Move .config aside while updating/installing the Nikki feed so `scripts/feeds update`
# does not run `refresh_config()` (`make defconfig`) before Nikki packages are installed,
# which would otherwise strip CONFIG_PACKAGE_*nikki* and mihomo-meta from .config.
config_backup=""
restore_config() {
  if [ -n "$config_backup" ] && [ -f "$config_backup" ]; then
    cp "$config_backup" .config
    rm -f "$config_backup"
  fi
}
trap restore_config EXIT

if [ -f .config ]; then
  config_backup="$(mktemp)"
  cp .config "$config_backup"
  rm -f .config
fi

./scripts/feeds update nikki
./scripts/feeds install -a -f -p nikki
rm -f tmp/.packageinfo

restore_config
config_backup=""
