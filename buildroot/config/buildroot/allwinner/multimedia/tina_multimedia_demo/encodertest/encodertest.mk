ENCODERTEST_SITE_METHOD = local

ifeq ($(TINA_PACKAGE_PATH_PREFIX), "buildroot")
ENCODERTEST_SITE = ../../buildroot/package/allwinner/multimedia/tina_multimedia_demo/encodertest
else
ENCODERTEST_SITE = ../../openwrt/package/allwinner/multimedia/tina_multimedia_demo/encodertest
endif
ENCODERTEST_LICENSE = GPLv2+, GPLv3+
ENCODERTEST_LICENSE_FILES = Copyright COPYING
#ENCODERTEST_DEPENDENCIES += libcedarx

ENCODERTEST_LDFLAGS+=-L$(TARGET_DIR)/usr/lib
ENCODERTEST_CFLAGS+=-I$(@D)/src \
					-I$(STAGING_DIR)/usr/include/libcedarx \
					-I$(STAGING_DIR)/usr/include/libcedarc
ENCODERTEST_EXTRA_LIBS+= -lcdc_base -lvenc_base
define ENCODERTEST_BUILD_CMDS
	make  -C $(@D)/src\
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(ENCODERTEST_CFLAGS)" \
		LDFLAGS="$(ENCODERTEST_LDFLAGS) $(ENCODERTEST_EXTRA_LIBS)" \
		all

endef

define ENCODERTEST_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/encodertest $(TARGET_DIR)/usr/bin/encodertest
endef

$(eval $(generic-package))
