TRECORDERDEMO_SITE_METHOD = local

ifeq ($(TINA_PACKAGE_PATH_PREFIX), "buildroot")
TRECORDERDEMO_SITE = ../../buildroot/package/allwinner/multimedia/tina_multimedia_demo/trecorderdemo
else
TRECORDERDEMO_SITE = ../../openwrt/package/allwinner/multimedia/tina_multimedia_demo/trecorderdemo
endif
TRECORDERDEMO_LICENSE = GPLv2+, GPLv3+
TRECORDERDEMO_LICENSE_FILES = Copyright COPYING
TRECORDERDEMO_DEPENDENCIES += libcedarx trecorder

TRECORDERDEMO_LDFLAGS+=-L$(TARGET_DIR)/usr/lib
TRECORDERDEMO_CFLAGS+=-I$(@D)/src \
					-I$(STAGING_DIR)/usr/include/libcedarx \
					-I$(STAGING_DIR)/usr/include/libcedarc
TRECORDERDEMO_EXTRA_LIBS+= -lvdecoder -lsbm -laftertreatment -lfbm -lMemAdapter -lcdc_base -lvenc_base
define TRECORDERDEMO_BUILD_CMDS
	make  -C $(@D)/src\
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(TRECORDERDEMO_CFLAGS)" \
		LDFLAGS="$(TRECORDERDEMO_LDFLAGS) $(TRECORDERDEMO_EXTRA_LIBS)" \
		trecorderdemo

endef

define TRECORDERDEMO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/trecorderdemo $(TARGET_DIR)/usr/bin/trecorderdemo
endef

$(eval $(generic-package))
