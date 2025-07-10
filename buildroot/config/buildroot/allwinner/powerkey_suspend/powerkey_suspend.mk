################################################################################
#
# powerkey_suspend package
#
################################################################################
POWERKEY_SUSPEND_SITE_METHOD = local
POWERKEY_SUSPEND_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/power/powerkey/powerkey_suspend

POWERKEY_SUSPEND_LICENSE = GPLv2+, GPLv3+
POWERKEY_SUSPEND_LICENSE_FILES = Copyright COPYING

PKG_INSTALL_DIR = $(@D)/install

define POWERKEY_SUSPEND_BUILD_CMDS
	make \
	CC="$(TARGET_CC)" \
	CFLAGS="$(LIBUAPI_CFLAGS)" \
	LDFLAGS="$(LIBUAPI_LDFLAGS)" \
	INSTALL_PREFIX="$(PKG_INSTALL_DIR)" \
	-C $(@D) \
	all
endef

define POWERKEY_SUSPEND_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(PKG_INSTALL_DIR)/powerkey_suspend $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
