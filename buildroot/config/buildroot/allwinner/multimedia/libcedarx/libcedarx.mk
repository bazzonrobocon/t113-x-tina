################################################################################
#
# libcedarx
#
################################################################################
LIBCEDARX_SITE_METHOD = local
LIBCEDARX_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/multimedia/libcedarx
LIBCEDARX_LICENSE = GPLv2+, GPLv3+
LIBCEDARX_LICENSE_FILES = Copyright COPYING
LIBCEDARX_INSTALL_TARGET = YES
LIBCEDARX_INSTALL_STAGING = YES
LIBCEDARX_AUTORECONF = YES
#LIBCEDARX_GETTEXTIZE = YES

LIBCEDARX_DEPENDENCIES += \
	zlib \
	openssl \
	libcedarc \
	alsa-lib

ifeq ($(LICHEE_IC), $(filter $(LICHEE_IC), tv303-c1 tv303-c2 tv303-g1 tv303-g2))
	LIBCEDARX_DEPENDENCIES += libdisplay
	PLATFORM_CONF = CONF_TV303
	LIBCEDARX_TARGET_IC = tv303
else ifeq ($(LICHEE_IC), $(filter $(LICHEE_IC), t113 t113s2 t113_s3p t113_s4 t113_s4p t113_i a40i a40i_h a40i_c t3 t3_c t3_pro))
	PLATFORM_CONF = CONF_T113
	LIBCEDARX_TARGET_IC = t113
	LIBCEDARX_CFLAGS += -DTINA_LINUX_SUPPORT=1
else ifeq ($(LICHEE_IC), $(filter $(LICHEE_IC), t527 a527))
	PLATFORM_CONF = CONF_T527
	LIBCEDARX_TARGET_IC = $(LICHEE_IC)
	LIBCEDARX_CFLAGS += -DTINA_LINUX_SUPPORT=1
else
	PLATFORM_CONF = CONF_$(shell echo $(LICHEE_IC) | sed 's/[a-z]/\u&/g')
	LIBCEDARX_TARGET_IC = $(LICHEE_IC)
endif

LIBCEDARX_CFLAGS += -D__ENABLE_ZLIB__ -D$(PLATFORM_CONF)
LIBCEDARX_CPPFLAGS +=-D__ENABLE_ZLIB__ -D$(PLATFORM_CONF)

ifeq ($(LICHEE_IC), $(filter $(LICHEE_IC), t113 t113s2 t113_s3p t113_i a40i a40i_h a40i_c t3 t3_c t3_pro))
LIBCEDARX_LDFLAGS += -L$(TARGET_DIR)/usr/lib -L$(@D)/libcore/base/.libs/ -L$(@D)/demo/libion/.libs/
else
LIBCEDARX_LDFLAGS += -L$(TARGET_DIR)/usr/lib
endif
ifeq ($(LICHEE_KERN_VER), linux-5.10)
LIBCEDARX_CFLAGS += -DCONF_KERNEL_VERSION_5_10
LIBCEDARX_CPPFLAGS += -DCONF_KERNEL_VERSION_5_10
else ifeq ($(LICHEE_KERN_VER), linux-5.4)
LIBCEDARX_CFLAGS += -DCONF_KERNEL_VERSION_5_4 -DCONF_USE_IOMMU
LIBCEDARX_CPPFLAGS += -DCONF_KERNEL_VERSION_5_4
else ifeq ($(LICHEE_KERN_VER), linux-4.9)
LIBCEDARX_CFLAGS += -DCONF_KERNEL_VERSION_4_9
LIBCEDARX_CPPFLAGS += -DCONF_KERNEL_VERSION_4_9
else ifeq ($(LICHEE_KERN_VER), linux-5.15)
LIBCEDARX_CFLAGS += -DCONF_KERNEL_VERSION_5_15 -DCONF_USE_IOMMU
LIBCEDARX_CPPFLAGS += -DCONF_KERNEL_VERSION_5_15
endif

ifeq ($(CONFIG_XPLAYER_DEMO), y)
	CONFIG_DEMO += --enable-xplayer-demo=yes
else
	CONFIG_DEMO += --enable-xplayer-demo=no
endif
define LIBCEDARX_CONFIGURE_CMDS
	(cd $(@D); \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	CONFIG_SITE=/dev/null \
	$(AUTOMAKE) --add-missing; \
	$(AUTORECONF); \
	./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		$(CONFIG_DEMO) \
		--build=$(GNU_HOST_NAME) \
		--prefix=$(TARGET_DIR)/usr \
		--exec-prefix=$(TARGET_DIR)/usr \
		--sysconfdir=$(TARGET_DIR)/etc \
		--program-prefix="" \
		--disable-gtk-doc \
		--disable-gtk-doc-html \
		--disable-doc \
		--disable-docs \
		--disable-documentation \
		--with-xmlto=no \
		--with-fop=no \
		--disable-dependency-tracking \
		--enable-ipv6 \
		--enable-ssl \
		$(TARGET_CONFIGURE_OPTS) \
		$(DISABLE_NLS) \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(LIBCEDARX_CONF_OPTS) \
		CFLAGS="$(LIBCEDARX_CFLAGS)" \
		CPPFLAGS="$(LIBCEDARX_CPPFLAGS)" \
		LDFLAGS="$(LIBCEDARX_LDFLAGS)" \
	)
endef

define LIBCEDARX_BUILD_CMDS
	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libaw* $(STAGING_DIR)/usr/lib
	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libadecoder.so $(STAGING_DIR)/usr/lib
	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libaencoder.so $(STAGING_DIR)/usr/lib
	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libsubdecoder.so $(STAGING_DIR)/usr/lib
	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/liblive555.so $(STAGING_DIR)/usr/lib
	$(MAKE) -C $(@D)
	$(MAKE) -C $(@D) install
endef

define LIBCEDARX_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/cdx_config.h $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/external/include/adecoder/*.h $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/external/include/aencoder/*.h $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/external/include/sdecoder/*.h $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/external/include/alsa/  $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/xplayer/include/*.h $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/libcore/base/include/*.h $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/libcore/base/include/*.i $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/libcore/muxer/include/*.h $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/libcore/parser/include/*.h $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/libcore/stream/include/*.h $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/libcore/common/iniparser/*.h $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/libcore/common/plugin/*.h $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/libcore/playback/include/*.h $(STAGING_DIR)/usr/include/libcedarx
	cp -rf $(@D)/awrecorder/*.h $(STAGING_DIR)/usr/include/libcedarx

	# install libs to staging_dir
	$(INSTALL) -D -m 0755 $(@D)/libcore/base/.libs/libcdx_base.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/libcore/common/.libs/libcdx_common.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/libcore/parser/base/.libs/libcdx_parser.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/libcore/playback/.libs/libcdx_playback.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/libcore/muxer/base/.libs/libcdx_muxer.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/libcore/stream/base/.libs/libcdx_stream.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/xmetadataretriever/.libs/libxmetadataretriever.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/xplayer/.libs/libxplayer.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/awrecorder/.libs/libawrecorder.so $(STAGING_DIR)/usr/lib/
endef
#fix me
define LIBCEDARX_INSTALL_TARGET_CMDS
	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libaw* $(TARGET_DIR)/usr/lib
	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libadecoder.so $(TARGET_DIR)/usr/lib
	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libaencoder.so $(TARGET_DIR)/usr/lib
	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libsubdecoder.so $(TARGET_DIR)/usr/lib
	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/liblive555.so $(TARGET_DIR)/usr/lib
	cp -rf $(@D)/conf/${LIBCEDARX_TARGET_IC}_cedarx.conf $(TARGET_DIR)/etc/cedarx.conf
endef

define LIBCEDARX_INSTALL_CONFIG_CMDS
	cp -rf $(@D)/conf/${LIBCEDARX_TARGET_IC}_cedarx.conf $(TARGET_DIR)/etc/cedarx.conf
endef

$(eval $(autotools-package))
