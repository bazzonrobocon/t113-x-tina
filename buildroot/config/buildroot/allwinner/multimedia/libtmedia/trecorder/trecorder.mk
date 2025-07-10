TRECORDER_SITE_METHOD = local
TRECORDER_SITE = ../../platform/allwinner/multimedia/libtmedia/trecorder

TRECORDER_LICENSE = GPLv2+, GPLv3+
TRECORDER_LICENSE_FILES = Copyright COPYING
TRECORDER_INSTALL_STAGING = YES

TRECORDER_LDFLAGS+=-L$(TARGET_DIR)/usr/lib
TRECORDER_CFLAGS+=-I$(@D) \
					-I$(STAGING_DIR)/usr/include/libcedarx \
					-I$(STAGING_DIR)/usr/include/libcedarc

TRECORDER_INSTALL_DIR = $(@D)/install

#TRECORDER_CFLAGS+=-D_DEFAULT_SOUNDCARD=$(DEFAULT_SOUNDCARD) -D_DEFAULT_DEVICE=$(DEFAULT_DEVICE)

define TRECORDER_BUILD_CMDS
	cp -rf $(TRECORDER_SITE)/../tplayer/*.h $(@D)
	cp -rf $(TRECORDER_SITE)/../*.h $(@D)
	make -C $(@D) \
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(TRECORDER_CFLAGS)" \
		LDFLAGS="$(TRECORDER_LDFLAGS)" \
		DEFAULT_SOUNDCARD=$(DEFAULT_SOUNDCARD) \
		DEFAULT_DEVICE=$(DEFAULT_DEVICE) \
		all

endef

define TRECORDER_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/libtrecorder.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0644 $(@D)/*.h $(STAGING_DIR)/usr/include/
endef

define TRECORDER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libtrecorder.so $(TARGET_DIR)/usr/lib/libtrecorder.so
	$(INSTALL) -D -m 0755 $(@D)/recorder.cfg $(TARGET_DIR)/etc/recorder.cfg
endef

$(eval $(generic-package))
