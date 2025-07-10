################################################################################
#
# CEDARSE lib and demo
#
################################################################################
LIBCEDARSE_SITE_METHOD = local
LIBCEDARSE_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/multimedia/libcedarse
LIBCEDARSE_LICENSE = GPLv2+, GPLv3+
LIBCEDARSE_LICENSE_FILES = Copyright COPYING
LIBCEDARSE_INSTALL_STAGING = YES

LIBCEDARSE_DEPENDENCIES += \
	rpbuf

define LIBCEDARSE_BUILD_CMDS
	[ ! -e PKG_INSTALL_DIR ] && mkdir -p $(PKG_INSTALL_DIR)
	make -C $(@D)/lib \
		INSTALL_PREFIX="$(PKG_INSTALL_DIR)" \
		all

	make -C $(@D)/config \
		INSTALL_PREFIX="$(PKG_INSTALL_DIR)" \
		all

	if test "$(BR2_PACKAGE_CEDARSE_PARM_ADJUST)" = "y" ; then \
	make -C $(@D)/adjust \
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(LIBUAPI_CFLAGS)" \
		LDFLAGS="$(LIBUAPI_LDFLAGS)" \
		INSTALL_PREFIX="$(PKG_INSTALL_DIR)" \
		all; \
	fi

	if test "$(BR2_PACKAGE_CEDARSE_DEMO)" = "y" ; then \
		make -C $(@D)/demo \
			ARCH="$(TARGET_ARCH)" \
			AR="$(TARGET_AR)" \
			CC="$(TARGET_CC)" \
			CXX="$(TARGET_CXX)" \
			CFLAGS="$(LIBUAPI_CFLAGS)" \
			LDFLAGS="$(LIBUAPI_LDFLAGS)" \
			INSTALL_PREFIX="$(PKG_INSTALL_DIR)" \
			all; \
	fi;
endef

define LIBCEDARSE_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0755 $(PKG_INSTALL_DIR)/usr/lib/libcedarse.so $(STAGING_DIR)/usr/lib/
endef

define LIBCEDARSE_INSTALL_TARGET_CMDS
	mkdir -p  $(TARGET_DIR)/etc/cedarSE
	$(INSTALL) -m 0777 $(PKG_INSTALL_DIR)/usr/config/cedarSE/* $(TARGET_DIR)/etc/cedarSE/
	$(INSTALL) -m 0755 $(PKG_INSTALL_DIR)/usr/lib/libcedarse.so $(TARGET_DIR)/usr/lib/

	if test "$(BR2_PACKAGE_CEDARSE_PARM_ADJUST)" = "y" ; then \
		$(INSTALL) -m 0755 $(PKG_INSTALL_DIR)/usr/bin/cedarSE_parm_adj $(TARGET_DIR)/usr/bin/ ; \
	fi;

if test "$(BR2_PACKAGE_CEDARSE_DEMO)" = "y" ; then \
		$(INSTALL) -m 0777 $(PKG_INSTALL_DIR)/usr/bin/cedarSE_demo $(TARGET_DIR)/usr/bin/ ; \
	fi;
endef

$(eval $(generic-package))
