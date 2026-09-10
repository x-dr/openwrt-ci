rm -rf package/emortal/luci-app-athena-led
git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
chmod +x package/luci-app-athena-led/root/etc/init.d/athena_led package/luci-app-athena-led/root/usr/sbin/athena-led

# Extra packages: only enable for the IPQ60XX 6.12 WiFi profile
if [ "$CONFIG_FILE" = "configs/ipq60xx-6.12-wifi.config" ]; then
  # Nikki
  grep -q '^src-git nikki ' feeds.conf.default || echo 'src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main' >> feeds.conf.default
  ./scripts/feeds update nikki
  ./scripts/feeds install -a -p nikki
  grep -q '^CONFIG_PACKAGE_nikki=y$' .config || echo 'CONFIG_PACKAGE_nikki=y' >> .config
  grep -q '^CONFIG_PACKAGE_luci-app-nikki=y$' .config || echo 'CONFIG_PACKAGE_luci-app-nikki=y' >> .config
  grep -q '^CONFIG_PACKAGE_luci-i18n-nikki-zh-cn=y$' .config || echo 'CONFIG_PACKAGE_luci-i18n-nikki-zh-cn=y' >> .config

  # KMS (vlmcsd) + LuCI UI + Simplified Chinese translation
  grep -q '^CONFIG_PACKAGE_vlmcsd=y$' .config || echo 'CONFIG_PACKAGE_vlmcsd=y' >> .config
  grep -q '^CONFIG_PACKAGE_luci-app-vlmcsd=y$' .config || echo 'CONFIG_PACKAGE_luci-app-vlmcsd=y' >> .config
  grep -q '^CONFIG_PACKAGE_luci-i18n-vlmcsd-zh-cn=y$' .config || echo 'CONFIG_PACKAGE_luci-i18n-vlmcsd-zh-cn=y' >> .config
fi