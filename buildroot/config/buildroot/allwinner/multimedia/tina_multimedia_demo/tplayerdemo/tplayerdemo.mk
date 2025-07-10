TPLAYERDEMO_SITE_METHOD = local

ifeq ($(TINA_PACKAGE_PATH_PREFIX), "buildroot")
TPLAYERDEMO_SITE = ../../buildroot/package/allwinner/multimedia/tina_multimedia_demo/tplayerdemo
else
TPLAYERDEMO_SITE = ../../openwrt/package/allwinner/multimedia/tina_multimedia_demo/tplayerdemo
endif
TPLAYER_SITE = ../../platform/allwinner/multimedia/libtmedia/tplayer
TPLAYERDEMO_LICENSE = GPLv2+, GPLv3+
TPLAYERDEMO_LICENSE_FILES = Copyright COPYING
TPLAYERDEMO_DEPENDENCIES += libcedarx tplayer

TPLAYERDEMO_LDFLAGS+=-L$(TARGET_DIR)/usr/lib
TPLAYERDEMO_CFLAGS+=-I$(@D)/src \
					-I$(STAGING_DIR)/usr/include/libcedarx \
					-I$(STAGING_DIR)/usr/include/libcedarc \
					-pthread
TPLAYERDEMO_EXTRA_LIBS+= -lvdecoder -lsbm -laftertreatment -lfbm -lMemAdapter -lcdc_base \
						 -lxplayer -lcdx_parser -lcdx_playback -lcdx_stream -lcdx_common -lm -ldl

define TPLAYERDEMO_BUILD_CMDS
	make  -C $(@D)/src\
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(TPLAYERDEMO_CFLAGS)" \
		LDFLAGS="$(TPLAYERDEMO_LDFLAGS) $(TPLAYERDEMO_EXTRA_LIBS)" \
		tplayerdemo

endef

define TPLAYERDEMO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/tplayerdemo $(TARGET_DIR)/usr/bin/tplayerdemo
endef

$(eval $(generic-package))
