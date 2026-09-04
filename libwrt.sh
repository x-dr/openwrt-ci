rm -rf package/emortal/luci-app-athena-led
git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
chmod +x package/luci-app-athena-led/root/etc/init.d/athena_led package/luci-app-athena-led/root/usr/sbin/athena-led

# OpenClash: only enable for the IPQ60XX 6.12 WiFi profile
if [ "$CONFIG_FILE" = "configs/ipq60xx-6.12-wifi.config" ]; then
  git clone --depth=1 -b master --single-branch --filter=blob:none --sparse https://github.com/vernesong/OpenClash.git package/openclash
  git -C package/openclash sparse-checkout set luci-app-openclash
  mv package/openclash/luci-app-openclash package/luci-app-openclash
  rm -rf package/openclash
  grep -q '^CONFIG_PACKAGE_luci-app-openclash=y$' .config || echo 'CONFIG_PACKAGE_luci-app-openclash=y' >> .config
fi