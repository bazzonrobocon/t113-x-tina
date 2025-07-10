################################################################################
#
# apps
#
################################################################################
WIFI_FIRMWARE_SITE_METHOD = local
WIFI_FIRMWARE_SITE = $(LICHEE_CBBPKG_DIR)/allwinner/wireless/firmware
WIFI_FIRMWARE_LICENSE = GPLv2+, GPLv3+
WIFI_FIRMWARE_LICENSE_FILES = Copyright COPYING
FIRMWARE_DIR := $(TARGET_DIR)/lib/firmware

define WIFI_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 0755 $(FIRMWARE_DIR)/

	if test "$(BR2_PACKAGE_RTL8723DS_FIRMWARE)" = "y" ; then \
		cp -r $(WIFI_FIRMWARE_SITE)/rtl8723ds/* $(FIRMWARE_DIR) ; \
	fi;

	if test "$(BR2_PACKAGE_RTL8733BS_FIRMWARE)" = "y" ; then \
		cp -r $(WIFI_FIRMWARE_SITE)/rtl8733bs/* $(FIRMWARE_DIR) ; \
	fi;

	if test "$(BR2_PACKAGE_RTL8821CS_FIRMWARE)" = "y" ; then \
		cp -r $(WIFI_FIRMWARE_SITE)/rtl8821cs/* $(FIRMWARE_DIR) ; \
	fi;

	if test "$(BR2_PACKAGE_AIC8800_FIRMWARE)" = "y" ; then \
		cp -r $(WIFI_FIRMWARE_SITE)/aic8800/* $(FIRMWARE_DIR) ; \
	fi;

	if test "$(BR2_PACKAGE_SSV6158_FIRMWARE)" = "y" ; then \
		cp -r $(WIFI_FIRMWARE_SITE)/ssv6158/* $(FIRMWARE_DIR) ; \
	fi;

	if test "$(BR2_PACKAGE_XR819_FIRMWARE)" = "y" ; then \
		cp -r $(WIFI_FIRMWARE_SITE)/xr819/* $(FIRMWARE_DIR) ; \
	fi;

	if test "$(BR2_PACKAGE_XR819A_FIRMWARE)" = "y" ; then \
		cp -r $(WIFI_FIRMWARE_SITE)/xr819a/* $(FIRMWARE_DIR) ; \
	fi;

	if test "$(BR2_PACKAGE_XR829_USE_40M)" = "y" ; then \
		cp -r $(WIFI_FIRMWARE_SITE)/xr829/* $(FIRMWARE_DIR) ; \
		mv $(FIRMWARE_DIR)/fw_xr829_bt_40M.bin $(FIRMWARE_DIR)/fw_xr829_bt.bin ; \
		mv $(FIRMWARE_DIR)/sdd_xr829_40M.bin $(FIRMWARE_DIR)/sdd_xr829.bin ; \
	fi;

	if test "$(BR2_PACKAGE_XR829_USE_24M)" = "y" ; then \
		cp -r $(WIFI_FIRMWARE_SITE)/xr829/* $(FIRMWARE_DIR) ; \
	fi;

	if test "$(BR2_PACKAGE_XR819S_USE_40M)" = "y" ; then \
		cp -r $(WIFI_FIRMWARE_SITE)/xr819s/* $(FIRMWARE_DIR) ; \
		mv $(FIRMWARE_DIR)/fw_xr819s_bt_40M.bin $(FIRMWARE_DIR)/fw_xr819s_bt.bin ; \
		mv $(FIRMWARE_DIR)/sdd_xr819s_40M.bin $(FIRMWARE_DIR)/sdd_xr819s.bin ; \
	fi;

	if test "$(BR2_PACKAGE_XR819S_USE_24M)" = "y" ; then \
		cp -r $(WIFI_FIRMWARE_SITE)/xr819s/* $(FIRMWARE_DIR) ; \
		mv $(FIRMWARE_DIR)/fw_xr819s_bt_24M.bin $(FIRMWARE_DIR)/fw_xr819s_bt.bin ; \
		mv $(FIRMWARE_DIR)/sdd_xr819s_24M.bin $(FIRMWARE_DIR)/sdd_xr819s.bin ; \
	fi;

endef

$(eval $(generic-package))
