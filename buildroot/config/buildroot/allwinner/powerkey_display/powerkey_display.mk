################################################################################
#
# powerkey_display package
#
################################################################################
POWERKEY_DISPLAY_SITE_METHOD = local
POWERKEY_DISPLAY_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/power/powerkey/powerkey_display

POWERKEY_DISPLAY_LICENSE = GPLv2+, GPLv3+
POWERKEY_DISPLAY_LICENSE_FILES = Copyright COPYING

PKG_INSTALL_DIR = $(@D)/install

define POWERKEY_DISPLAY_BUILD_CMDS
	make \
	CC="$(TARGET_CC)" \
	CFLAGS="$(LIBUAPI_CFLAGS)" \
	LDFLAGS="$(LIBUAPI_LDFLAGS)" \
	INSTALL_PREFIX="$(PKG_INSTALL_DIR)" \
	-C $(@D) \
	all
endef

define POWERKEY_DISPLAY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(PKG_INSTALL_DIR)/powerkey_display $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
