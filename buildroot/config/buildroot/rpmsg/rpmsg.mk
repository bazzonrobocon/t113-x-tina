RPMSG_SITE_METHOD = local
RPMSG_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/system/rpmsg

RPMSG_LICENSE = GPLv2+, GPLv3+
RPMSG_LICENSE_FILES = Copyright COPYING

PKG_INSTALL_DIR = $(@D)/install

define RPMSG_BUILD_CMDS
	[ ! -e PKG_INSTALL_DIR ] && mkdir -p $(PKG_INSTALL_DIR)
	make -C $(@D)/librpmsg \
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(LIBUAPI_CFLAGS)" \
		LDFLAGS="$(LIBUAPI_LDFLAGS)" \
		INSTALL_PREFIX="$(PKG_INSTALL_DIR)" \
		all

	if test "$(BR2_PACKAGE_RPMSG_DEMO)" = "y" ; then \
		make -C $(@D)/demo \
			ARCH="$(TARGET_ARCH)" \
			AR="$(TARGET_AR)" \
			CC="$(TARGET_CC)" \
			CXX="$(TARGET_CXX)" \
			CFLAGS="$(LIBUAPI_CFLAGS)" \
			LDFLAGS="$(LIBUAPI_LDFLAGS)" \
			INSTALL_PREFIX="$(PKG_INSTALL_DIR)" \
			all ; \
	fi;

	if test "$(BR2_PACKAGE_RPMSG_TEST)" = "y" ; then \
		make -C $(@D)/test \
			ARCH="$(TARGET_ARCH)" \
			AR="$(TARGET_AR)" \
			CC="$(TARGET_CC)" \
			CXX="$(TARGET_CXX)" \
			CFLAGS="$(LIBUAPI_CFLAGS)" \
			LDFLAGS="$(LIBUAPI_LDFLAGS)" \
			INSTALL_PREFIX="$(PKG_INSTALL_DIR)" \
			all ; \
	fi;

endef

define RPMSG_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(PKG_INSTALL_DIR)/usr/lib/librpmsg.so $(TARGET_DIR)/usr/lib/

	if test "$(BR2_PACKAGE_RPMSG_DEMO)" = "y" ; then \
		$(INSTALL) -m 0777 $(PKG_INSTALL_DIR)/usr/bin/rpmsg_demo $(TARGET_DIR)/usr/bin/ ; \
	fi;

	if test "$(BR2_PACKAGE_RPMSG_TEST)" = "y" ; then \
		$(INSTALL) -m 0777 $(PKG_INSTALL_DIR)/usr/bin/rpmsg_test $(TARGET_DIR)/usr/bin/ ; \
	fi;

endef

$(eval $(generic-package))
