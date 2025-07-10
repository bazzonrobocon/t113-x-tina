RPBUF_SITE_METHOD = local
RPBUF_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/system/rpbuf

RPBUF_LICENSE = GPLv2+, GPLv3+
RPBUF_LICENSE_FILES = Copyright COPYING

PKG_INSTALL_DIR = $(@D)/install

define RPBUF_BUILD_CMDS
	[ ! -e PKG_INSTALL_DIR ] && mkdir -p $(PKG_INSTALL_DIR)
	make -C $(@D)/librpbuf \
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(LIBUAPI_CFLAGS)" \
		LDFLAGS="$(LIBUAPI_LDFLAGS)" \
		INSTALL_PREFIX="$(PKG_INSTALL_DIR)" \
		all

	if test "$(BR2_PACKAGE_RPBUF_DEMO)" = "y" ; then \
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

	if test "$(BR2_PACKAGE_RPBUF_TEST)" = "y" ; then \
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

define RPBUF_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(PKG_INSTALL_DIR)/usr/lib/librpbuf.so $(TARGET_DIR)/usr/lib/

	if test "$(BR2_PACKAGE_RPBUF_DEMO)" = "y" ; then \
		$(INSTALL) -m 0777 $(PKG_INSTALL_DIR)/usr/bin/rpbuf_demo $(TARGET_DIR)/usr/bin/ ; \
	fi;

	if test "$(BR2_PACKAGE_RPBUF_TEST)" = "y" ; then \
		$(INSTALL) -m 0777 $(PKG_INSTALL_DIR)/usr/bin/rpbuf_test $(TARGET_DIR)/usr/bin/ ; \
	fi;

endef

$(eval $(generic-package))
