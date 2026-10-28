#!/usr/bin/env bash
set -Eeuo pipefail

IB_DIR="${1:-imagebuilder}"
PACKAGES_DIR="$IB_DIR/packages"
FILES_DIR="$IB_DIR/files"
WORK_DIR="${RUNNER_TEMP:-/tmp}/h69k-third-party"
FAN_COMMIT="8910dc75db7169157565eb6556ba4b33d6489377"

mkdir -p "$PACKAGES_DIR" "$FILES_DIR" "$WORK_DIR"

echo "===== 下载 OpenClash APK（取官方最新 Release）====="
OPENCLASH_JSON="$(curl -fsSL --retry 3 --retry-delay 2 https://api.github.com/repos/vernesong/OpenClash/releases/latest)"
OPENCLASH_URL="$(printf '%s' "$OPENCLASH_JSON" | jq -er '[.assets[] | select(.name | test("^luci-app-openclash-[0-9].*\\.apk$"))][0].browser_download_url')"
OPENCLASH_NAME="$(basename "$OPENCLASH_URL")"
curl -fL --retry 3 --retry-delay 2 "$OPENCLASH_URL" -o "$PACKAGES_DIR/$OPENCLASH_NAME"
test -s "$PACKAGES_DIR/$OPENCLASH_NAME"
echo "已下载：$OPENCLASH_NAME"

echo "===== 下载 MT5700 APK（aarch64_generic，取官方最新 Release）====="
MT_JSON="$(curl -fsSL --retry 3 --retry-delay 2 https://api.github.com/repos/qqzwqq/luci-app-mt5700/releases/latest)"
MT_APP_URL="$(printf '%s' "$MT_JSON" | jq -er '[.assets[] | select(.name | test("^aarch64_generic-luci-app-mt5700-.*\\.apk$"))][0].browser_download_url')"
MT_LANG_URL="$(printf '%s' "$MT_JSON" | jq -er '[.assets[] | select(.name | test("^aarch64_generic-luci-i18n-mt5700-zh-cn-.*\\.apk$"))][0].browser_download_url')"
for url in "$MT_APP_URL" "$MT_LANG_URL"; do
  name="$(basename "$url")"
  curl -fL --retry 3 --retry-delay 2 "$url" -o "$PACKAGES_DIR/$name"
  test -s "$PACKAGES_DIR/$name"
  echo "已下载：$name"
done

echo "===== 加入 HINLINK H69K 专用风扇管理界面 ====="
FAN_ARCHIVE="$WORK_DIR/fan-source.tar.gz"
curl -fL --retry 3 --retry-delay 2 \
  "https://github.com/ouyangzq/H29KorH69K-OPENWRT/archive/$FAN_COMMIT.tar.gz" \
  -o "$FAN_ARCHIVE"
tar -xzf "$FAN_ARCHIVE" -C "$WORK_DIR"
FAN_SRC="$WORK_DIR/H29KorH69K-OPENWRT-$FAN_COMMIT/luci-app-fan-h69k/files"
if [ ! -d "$FAN_SRC" ]; then
  echo "::error::没有找到 H69K 风扇插件源文件目录：$FAN_SRC"
  exit 1
fi
cp -a "$FAN_SRC/." "$FILES_DIR/"
[ -f "$FILES_DIR/etc/init.d/hinlinkfaninit" ] || {
  echo "::error::H69K 风扇服务脚本缺失"
  exit 1
}
chmod +x "$FILES_DIR/etc/init.d/hinlinkfaninit"
chmod +x "$FILES_DIR/usr/sbin/hinlinkfan-daemon"
find "$FILES_DIR/etc/uci-defaults" -maxdepth 1 -type f \\( -name '*hinlinkfan*' -o -name 'luci-app-fan-h69k' \\) -exec chmod +x {} \; 2>/dev/null || true
echo "已复制 H69K 风扇应用文件到 ImageBuilder FILES 覆盖层。"
echo "注意：风扇控制依赖 H69K 内核本身提供 pwm-fan/hwmon 节点；本脚本不会安装其他设备的 kmod，以避免内核 ABI 不匹配。"

echo "===== 第三方 APK 清单 ====="
find "$PACKAGES_DIR" -maxdepth 1 -type f \( -name '*openclash*.apk' -o -name '*mt5700*.apk' \) -printf '%f (%s bytes)\n' | sort
