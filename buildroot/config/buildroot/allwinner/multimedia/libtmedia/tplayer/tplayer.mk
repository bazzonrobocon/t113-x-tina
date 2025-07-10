TPLAYER_SITE_METHOD = local
TPLAYER_SITE = ../../platform/allwinner/multimedia/libtmedia/tplayer

TPLAYER_LICENSE = GPLv2+, GPLv3+
TPLAYER_LICENSE_FILES = Copyright COPYING
TPLAYER_INSTALL_STAGING = YES
TPLAYER_DEPENDENCIES += libcedarx libuapi
TPLAYER_LDFLAGS+=-L$(TARGET_DIR)/usr/lib
TPLAYER_CFLAGS+=-I$(@D) \
					-I$(STAGING_DIR)/usr/include/libcedarx \
					-I$(STAGING_DIR)/usr/include/libcedarc

TPLAYER_INSTALL_DIR = $(@D)/install
#TPLAYER_CFLAGS += -DCONF_USE_IOMMU -DCONF_KERNEL_IOMMU
TPLAYER_CFLAGS += -DCONF_KERNEL_IOMMU
ifeq ($(LICHEE_IC), $(filter $(LICHEE_IC), t113 t113s2 t113_s3p t113_s4 t113_s4p t113_i t527 a527))
	TPLAYER_CFLAGS += -DTINA_LINUX_SUPPORT=1
endif

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_LINARO_ARMSF), y)
#	TPLAYER_LDFLAGS+=-L$(TPLAYER_SITE)/arm-linux-gnueabi/libAudioPostProc.a
	AUDIO_LIBS = $(TPLAYER_SITE)/arm-linux-gnueabi/
#	TPLAYER_EXTRA_LIBS+=

endif

ifeq ($(TINA_PACKAGE_PATH_PREFIX), "buildroot")
	ifeq ($(LICHEE_CROSS_COMPILER),aarch64-none-linux-gnu)
		AUDIO_LIBS = $(TPLAYER_SITE)/aarch64-none-linux-gnu/
	endif
endif

define TPLAYER_BUILD_CMDS
	cp -rf $(TPLAYER_SITE)/../tplayer/*.h $(@D)
	cp -rf $(TPLAYER_SITE)/../*.h $(@D)
	make -C $(@D) \
		ARCH="$(TARGET_ARCH)" \
		AR="$(TARGET_AR)" \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		CFLAGS="$(TPLAYER_CFLAGS)" \
		LDFLAGS="$(TPLAYER_LDFLAGS)" \
		TINA_PACKAGE_PATH_PREFIX=$(TINA_PACKAGE_PATH_PREFIX) \
		all

endef

define TPLAYER_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/libtplayer.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0644 $(AUDIO_LIBS)/libAudioPostProc.a $(STAGING_DIR)/usr/lib/libAudioPostProc.a
	$(INSTALL) -D -m 0644 $(AUDIO_LIBS)/libAudioGain.a $(STAGING_DIR)/usr/lib/libAudioGain.a
	$(INSTALL) -D -m 0644 $(@D)/*.h $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 0644 $(@D)/awsink/*.h $(STAGING_DIR)/usr/include/
endef

define TPLAYER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libtplayer.so $(TARGET_DIR)/usr/lib/libtplayer.so
	$(INSTALL) -D -m 0755 $(AUDIO_LIBS)/libAudioPostProc.a $(TARGET_DIR)/usr/lib/libAudioPostProc.a
	$(INSTALL) -D -m 0755 $(AUDIO_LIBS)/libAudioGain.a $(TARGET_DIR)/usr/lib/libAudioGain.a
endef

$(eval $(generic-package))
