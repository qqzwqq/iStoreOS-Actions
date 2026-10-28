#!/bin/bash
# ============= iStoreOS 25.12 / APK 额外插件配置 ==============
# 本项目 H69K 固件默认集成：
# - Docker / Dockerman（build24.sh 官方集成列表）
# - AdGuardHome + LuCI（build24.sh 官方软件源）
# - OpenClash + MT5700（St1 自动下载 APK）
# - luci-app-fan-h69k（St1 以 FILES 覆盖层集成，避免安装不匹配的 kmod）
# 下面保留其他可选插件示例；请确认它们有 25.12 兼容 APK 后再启用。

# 分区扩容 by sirpdboy 
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-partexp"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-partexp-zh-cn"
# 酷猫主题 by sirpdboy 
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-theme-kucat"
# 进阶设置 by sirpdboy 
# 当luci-app-advancedplus插件开启时 需排除冲突项 luci-app-argon-config和luci-i18n-argon-config-zh-cn 减号代表排除
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-advancedplus -luci-app-argon-config"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-advancedplus-zh-cn -luci-i18n-argon-config-zh-cn"
# 网络测速 by sirpdboy 
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-netspeedtest"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-netspeedtest-zh-cn"
# MosDNS
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-mosdns"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-mosdns-zh-cn"
# 应用过滤 openappfilter.com
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-appfilter"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-appfilter-zh-cn"
# 设置向导 by sirpdboy
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-netwizard"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-netwizard-zh-cn"

# ============= 若去除组件 则打开注释 ============================
# 若去掉istore商店 则打开注释
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES -luci-app-store"
# 若去掉首页和网络向导 则打开注释
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES -luci-i18n-quickstart-zh-cn"
