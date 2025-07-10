JPEGDECODE_SITE_METHOD = local
JPEGDECODE_SITE = ../../platform/allwinner/multimedia/libtmedia/jpegdecode

JPEGDECODE_LICENSE = GPLv2+, GPLv3+
JPEGDECODE_LICENSE_FILES = Copyright COPYING
JPEGDECODE_INSTALL_STAGING = YES

JPEGDECODE_LDFLAGS+=-L$(TARGET_DIR)/usr/lib
JPEGDECODE_CFLAGS+=-I$(@D) \
					-I$(STAGING_DIR)/usr/include/libcedarx \
					-I$(STAGING_DIR)/usr/include/libcedarc \
					-I../../platform/allwinner/multimedia/libtmedia/tplayer/tlog.h

JPEGDECODE_INSTALL_DIR = $(@D)/install


define JPEGDECODE_BUILD_CMDS
	cp -rf $(JPEGDECODE_SITE)/../tplayer/*.h $(@D)
	cp -rf $(JPEGDECODE_SITE)/../*.h $(@D)
	make -C $(@D) \
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(JPEGDECODE_CFLAGS)" \
		LDFLAGS="$(JPEGDECODE_LDFLAGS)" \
		all

endef

define JPEGDECODE_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/libjpegdecode.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0644 $(@D)/jpegdecode.h $(STAGING_DIR)/usr/include/
endef

define JPEGDECODE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libjpegdecode.so $(TARGET_DIR)/usr/lib/libjpegdecode.so
endef

$(eval $(generic-package))
