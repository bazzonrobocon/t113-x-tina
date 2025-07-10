BACKPLAYDEMO_SITE_METHOD = local

ifeq ($(TINA_PACKAGE_PATH_PREFIX), "buildroot")
BACKPLAYDEMO_SITE = ../../buildroot/package/allwinner/multimedia/tina_multimedia_demo/backplaydemo
else
BACKPLAYDEMO_SITE = ../../openwrt/package/allwinner/multimedia/tina_multimedia_demo/backplaydemo
endif

TPLAYER_SITE = ../../platform/allwinner/multimedia/libtmedia/tplayer
BACKPLAYDEMO_LICENSE = GPLv2+, GPLv3+
BACKPLAYDEMO_LICENSE_FILES = Copyright COPYING
BACKPLAYDEMO_DEPENDENCIES += libcedarx tplayer

BACKPLAYDEMO_LDFLAGS+=-L$(TARGET_DIR)/usr/lib
BACKPLAYDEMO_CFLAGS+=-I$(@D)/src \
					-I$(STAGING_DIR)/usr/include/libcedarx \
					-I$(STAGING_DIR)/usr/include/libcedarc \
					-pthread
BACKPLAYDEMO_EXTRA_LIBS+= -lvdecoder -lsbm -laftertreatment -lfbm -lMemAdapter -lcdc_base \
						 -lxplayer -lcdx_parser -lcdx_playback -lcdx_stream -lcdx_common -lm -ldl

define BACKPLAYDEMO_BUILD_CMDS
	make  -C $(@D)/src\
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(BACKPLAYDEMO_CFLAGS)" \
		LDFLAGS="$(BACKPLAYDEMO_LDFLAGS) $(BACKPLAYDEMO_EXTRA_LIBS)" \
		backplaydemo
endef

define BACKPLAYDEMO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/backplaydemo $(TARGET_DIR)/usr/bin/backplaydemo
endef

$(eval $(generic-package))
