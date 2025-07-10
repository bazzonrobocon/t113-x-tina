################################################################################
#
# wifimanager package
#
################################################################################
WIFIMANAGER_SITE_METHOD = local
WIFIMANAGER_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/wireless/wifimanager

WIFIMANAGER_LICENSE = GPLv2+, GPLv3+
WIFIMANAGER_LICENSE_FILES = Copyright COPYING
WIFIMANAGER_INSTALL_TARGET = YES
WIFIMANAGER_INSTALL_STAGING = YES

WIFIMANAGER_DEPENDENCIES = wireless_common libnl

WIFIMANAGER_CFLAGS = $(TARGET_CFLAGS)
WIFIMANAGER_CFLAGS += -O2 -fPIC -Wall
WIFIMANAGER_CFLAGS += -DOS_NET_LINUX_OS -DSUPPORT_STA_MODE -DSUPPORT_AP_MODE -DSUPPORT_EXPAND -DSUPPORT_LINKD -DDEFAULT_DEBUG_LV_INFO -DWMG_CONFIG_PATH=\\\"/etc/wifi\\\"
WIFIMANAGER_CFLAGS += -I$(STAGING_DIR)/usr/include -I$(@D) -I$(@D)/include
WIFIMANAGER_LDFLAGS = $(TARGET_LDFLAGS)
WIFIMANAGER_LIB_LDFLAGS += $(WIFIMANAGER_LDFLAGS) -L$(TARGET_DIR)/usr/lib/ -L$(TARGET_DIR)/lib/ -shared -lpthread -ldl -lrt -lnl-3 -lwirelesscom
WIFIMANAGER_DEMO_LDFLAGS += $(WIFIMANAGER_LDFLAGS) -L$(TARGET_DIR)/usr/lib/ -L$(TARGET_DIR)/lib/ -L$(@D)/core/ -lpthread -lwifimg-v2.0

define WIFIMANAGER_BUILD_CMDS
	[ ! -e PKG_INSTALL_DIR ] && mkdir -p $(PKG_INSTALL_DIR)
	if test "$(BR2_PACKAGE_WIFIMANAGER_LIB)" = "y" ; then \
	$(MAKE) -C $(@D)/core \
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(WIFIMANAGER_CFLAGS)" \
		LDFLAGS="$(WIFIMANAGER_LIB_LDFLAGS)" \
		CONFIG_PREFIX="$(PKG_INSTALL_DIR)" \
		PKG_BUILD_DIR="$(@D)" \
		CONFIG_WMG_PLATFORM_LINUX=y \
		CONFIG_WMG_SUPPORT_EXPAND=y \
		CONFIG_WMG_SUPPORT_STA_MODE=y \
		CONFIG_WMG_SUPPORT_AP_MODE=y \
		CONFIG_WMG_PROTOCOL_SOFTAP=y \
		CONFIG_SOFT_FLOAT=y \
		CONFIG_ARCH="$(ARCH)" \
		all; \
	fi
	if test "$(BR2_PACKAGE_WIFIMANAGER_DEMO)" = "y" ; then \
	$(MAKE) -C $(@D)/demo \
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(WIFIMANAGER_CFLAGS)" \
		LDFLAGS="$(WIFIMANAGER_DEMO_LDFLAGS)" \
		CONFIG_PREFIX="$(PKG_INSTALL_DIR)" \
		PKG_BUILD_DIR="$(@D)" \
		CONFIG_ARCH="$(ARCH)" \
		all; \
	fi
endef

define WIFIMANAGER_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include/wifimanager
	cp -rf $(@D)/core/include/*.h $(STAGING_DIR)/usr/include/wifimanager/
endef

define WIFIMANAGER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib
	mkdir -p $(TARGET_DIR)/etc/wifi
	mkdir -p $(TARGET_DIR)/etc/wifi/wpa_supplicant
	mkdir -p $(TARGET_DIR)/etc/wifi/hostapd
	$(INSTALL) -D -m 0644 $(@D)/core/libwifimg-v2.0.so $(TARGET_DIR)/usr/lib/libwifimg-v2.0.so
	$(INSTALL) -D -m 0755 $(@D)/demo/wifi_daemon $(TARGET_DIR)/usr/bin/wifi_daemon
        $(INSTALL) -D -m 0755 $(@D)/demo/wifi $(TARGET_DIR)/usr/bin/wifi
        $(INSTALL) -D -m 0755 $(@D)/files/hostapd.conf $(TARGET_DIR)/etc/wifi/hostapd
        $(INSTALL) -D -m 0755 $(@D)/files/wpa_supplicant.conf $(TARGET_DIR)/etc/wifi/wpa_supplicant
        $(INSTALL) -D -m 0755 $(@D)/files/wpa_supplicant_p2p.conf $(TARGET_DIR)/etc/wifi/wpa_supplicant
        $(INSTALL) -D -m 0755 $(@D)/files/wpa_supplicant_src.conf $(TARGET_DIR)/etc/wifi/wpa_supplicant
        $(INSTALL) -D -m 0755 $(@D)/files/wpa_supplicant_overlay.conf $(TARGET_DIR)/etc/wifi/wpa_supplicant
        $(INSTALL) -D -m 0755 $(@D)/files/wifimg.config $(TARGET_DIR)/etc/wifi/wifimg.config
endef

$(eval $(generic-package))
