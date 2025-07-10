JPEGDECODEDEMO_SITE_METHOD = local

ifeq ($(TINA_PACKAGE_PATH_PREFIX), "buildroot")
JPEGDECODEDEMO_SITE = ../../buildroot/package/allwinner/multimedia/tina_multimedia_demo/jpegdecodedemo
else
JPEGDECODEDEMO_SITE = ../../openwrt/package/allwinner/multimedia/tina_multimedia_demo/jpegdecodedemo
endif
JPEGDECODEDEMO_LICENSE = GPLv2+, GPLv3+
JPEGDECODEDEMO_LICENSE_FILES = Copyright COPYING
JPEGDECODEDEMO_DEPENDENCIES += libcedarx jpegdecode

JPEGDECODEDEMO_LDFLAGS+=-L$(TARGET_DIR)/usr/lib
JPEGDECODEDEMO_CFLAGS+=-I$(@D)/src \
					-I$(STAGING_DIR)/usr/include/libcedarx \
					-I$(STAGING_DIR)/usr/include/libcedarc
JPEGDECODEDEMO_EXTRA_LIBS+= -lvdecoder -lsbm -laftertreatment -lfbm -lMemAdapter -lcdc_base
define JPEGDECODEDEMO_BUILD_CMDS
	make  -C $(@D)/src\
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(JPEGDECODEDEMO_CFLAGS)" \
		LDFLAGS="$(JPEGDECODEDEMO_LDFLAGS) $(JPEGDECODEDEMO_EXTRA_LIBS)" \
		jpegdecodedemo

endef

define JPEGDECODEDEMO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/jpegdecodedemo $(TARGET_DIR)/usr/bin/jpegdecodedemo
endef

$(eval $(generic-package))
