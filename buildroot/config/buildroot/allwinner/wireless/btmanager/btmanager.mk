BTMANAGER_VERSION = 4.0
BTMANAGER_SITE_METHOD = local
BTMANAGER_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/wireless/btmanager

BTMANAGER_LICENSE = GPLv2+, GPLv3+
BTMANAGER_LICENSE_FILES = Copyright COPYING
BTMANAGER_INSTALL_TARGET = YES
BTMANAGER_INSTALL_STAGING = YES

BTMANAGER_DEPENDENCIES += \
	wireless_common \
	alsa-lib \
	bluez5_utils \
	dbus \
	libglib2 \
	json-c \
	bluez-alsa


BTMANAGER_CFLAGS = $(TARGET_CFLAGS)
BTMANAGER_LDFLAGS = $(TARGET_LDFLAGS)
BTMANAGER_LDFLAGS += -lpthread -lz -lrt -lm -ldl

CONFIG_LIBC="buildroot"

define BTMANAGER_BUILD_CMDS
	[ ! -e PKG_INSTALL_DIR ] && mkdir -p $(PKG_INSTALL_DIR)
	$(MAKE) -C $(@D)/src \
		PKG_BUILD_DIR="$(@D)" \
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(BTMANAGER_CFLAGS)" \
		BT_EXT_CFLAG="$(BT_EXT_CFLAG)" \
		LDFLAGS="$(BTMANAGER_LDFLAGS)" \
		STAGING_DIR="$(STAGING_DIR)" \
		CONFIG_LIBC="$(CONFIG_LIBC)" \
		CPU="$(ARCH)" \
		CONFIG_PREFIX="$(PKG_INSTALL_DIR)" \
		all

	if test "$(BR2_PACKAGE_BTMG_DEMO)" = "y" ; then \
		$(MAKE) -C $(@D)/demo/ \
			ARCH="$(TARGET_ARCH)" \
			AR="$(TARGET_AR)" \
			CC="$(TARGET_CC)" \
			CXX="$(TARGET_CXX)" \
			CFLAGS="$(BTMANAGER_CFLAGS)" \
			LDFLAGS="$(BTMANAGER_LDFLAGS)" \
			STAGING_DIR="$(STAGING_DIR)" \
			CONFIG_PREFIX="$(PKG_INSTALL_DIR)" \
			all ; \
	fi;

endef

define BTMANAGER_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include
	mkdir -p $(STAGING_DIR)/usr/lib
	cp -rf $(PKG_INSTALL_DIR)/usr/include/*.h  $(STAGING_DIR)/usr/include
	cp -rf $(PKG_INSTALL_DIR)/usr/lib/* $(STAGING_DIR)/usr/lib
endef

define BTMANAGER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib
	$(INSTALL) -D -m 0644 $(PKG_INSTALL_DIR)/usr/lib/* $(TARGET_DIR)/lib
	mkdir -p $(TARGET_DIR)/etc/bluetooth
	$(INSTALL) -D -m 0755 $(@D)/config/bluetooth.json $(TARGET_DIR)/etc/bluetooth/bluetooth.json
	$(INSTALL) -D -m 0755 $(@D)/config/bt_init.sh $(TARGET_DIR)/etc/bluetooth/bt_init.sh

	if test "$(BR2_PACKAGE_XR819S_FIRMWARE)" = "y" ; then \
		sed -i 's/xradio/xr819s/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
		sed -i 's/# xr819s_stop/xr819s_stop/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
	fi;

	if test "$(BR2_PACKAGE_RTL8723DS_FIRMWARE)" = "y" ; then \
		sed -i 's/bt_hciattach="hciattach"/bt_hciattach="rtk_hciattach"/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
		sed -i 's/# reset_bluetooth_power/reset_bluetooth_power/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
		sed -i 's/ttyS1 xradio/-s 115200 \/dev\/ttyS1 rtk_h5/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
	fi;

	if test "$(BR2_PACKAGE_RTL8733BS_FIRMWARE)" = "y" ; then \
		sed -i 's/bt_hciattach="hciattach"/bt_hciattach="rtk_hciattach"/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
		sed -i 's/# reset_bluetooth_power/reset_bluetooth_power/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
		sed -i 's/ttyS1 xradio/-s 115200 \/dev\/ttyS1 rtk_h5/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
	fi;

	if test "$(BR2_PACKAGE_RTL8821CS_FIRMWARE)" = "y" ; then \
		sed -i 's/bt_hciattach="hciattach"/bt_hciattach="rtk_hciattach"/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
		sed -i 's/# reset_bluetooth_power/reset_bluetooth_power/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
		sed -i 's/ttyS1 xradio/-s 115200 \/dev\/ttyS1 rtk_h5/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
	fi;

	if test "$(BR2_PACKAGE_AIC8800_FIRMWARE)" = "y" ; then \
		sed -i '/# reset_bluetooth_power/i\	echo 1 \> \/proc\/bluetooth\/sleep\/btwrite' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
		sed -i 's/# reset_bluetooth_power/reset_bluetooth_power/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
		sed -i 's/xradio/aic/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh ; \
	fi;

	# sed -i 's/ttyS1/ttyS2/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh
	sed -i 's/ttyS/ttyAS/g' $(TARGET_DIR)/etc/bluetooth/bt_init.sh

	if test "$(BR2_PACKAGE_BTMG_DEMO)" = "y" ; then \
		mkdir -p $(TARGET_DIR)/usr/bin ; \
		$(INSTALL) -D -m 755 $(PKG_INSTALL_DIR)/usr/bin/bt_test $(TARGET_DIR)/usr/bin/ ; \
	fi;

endef

$(eval $(generic-package))
