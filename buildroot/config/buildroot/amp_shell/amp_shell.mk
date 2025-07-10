AMP_SHELL_SITE_METHOD = local
AMP_SHELL_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/system/amp_shell

AMP_SHELL_LICENSE = GPLv2+, GPLv3+
AMP_SHELL_LICENSE_FILES = Copyright COPYING

PKG_INSTALL_DIR = $(@D)/install

define AMP_SHELL_BUILD_CMDS
	[ ! -e PKG_INSTALL_DIR ] && mkdir -p $(PKG_INSTALL_DIR)
	make -C $(@D)/files \
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(LIBUAPI_CFLAGS)" \
		LDFLAGS="$(LIBUAPI_LDFLAGS)" \
		INSTALL_PREFIX="$(PKG_INSTALL_DIR)" \
		all

endef

define AMP_SHELL_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(PKG_INSTALL_DIR)/usr/bin/amp_shell $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
