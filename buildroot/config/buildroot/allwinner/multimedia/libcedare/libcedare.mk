################################################################################
#
# libcedare
#
################################################################################
LIBCEDARE_SITE_METHOD = local
LIBCEDARE_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/multimedia/libcedare
LIBCEDARE_LICENSE = GPLv2+, GPLv3+
LIBCEDARE_LICENSE_FILES = Copyright COPYING
LIBCEDARE_INSTALL_TARGET = YES
LIBCEDARE_INSTALL_STAGING = YES
LIBCEDARE_AUTORECONF = YES
#LIBCEDARE_GETTEXTIZE = YES

LIBCEDARE_DEPENDENCIES += \
	zlib \
	openssl \
	libcedarc \
	libcedarx \
	alsa-lib

PLATFORM_CONF = CONF_$(shell echo $(LICHEE_IC) | sed 's/[a-z]/\u&/g')

LIBCEDARE_CONF_OPTS += CFLAGS="-D__ENABLE_ZLIB__ -D$(PLATFORM_CONF)"
LIBCEDARE_CONF_OPTS += CPPFLAGS="-D__ENABLE_ZLIB__ -D$(PLATFORM_CONF)"

LIBCEDARE_CONF_OPTS += LDFLAGS="-L$(TARGET_DIR)/usr/lib"

ifeq ($(LICHEE_KERN_VER), linux-5.10)
LIBCEDARE_CONF_OPTS += CFLAGS="-DCONF_KERNEL_VERSION_5_10"
LIBCEDARE_CONF_OPTS += CPPFLAGS="-DCONF_KERNEL_VERSION_5_10"
else ifeq ($(LICHEE_KERN_VER), linux-5.4)
LIBCEDARE_CONF_OPTS += CFLAGS="-DCONF_KERNEL_VERSION_5_4 -DCONF_USE_IOMMU"
LIBCEDARE_CONF_OPTS += CPPFLAGS="-DCONF_KERNEL_VERSION_5_4"
else ifeq ($(LICHEE_KERN_VER), linux-4.9)
LIBCEDARE_CONF_OPTS += CFLAGS="-DCONF_KERNEL_VERSION_4_9"
LIBCEDARE_CONF_OPTS += CPPFLAGS="-DCONF_KERNEL_VERSION_4_9"
else ifeq ($(LICHEE_KERN_VER), linux-5.15)
LIBCEDARE_CONF_OPTS += CFLAGS="-DCONF_KERNEL_VERSION_5_15 -DCONF_USE_IOMMU"
LIBCEDARE_CONF_OPTS += CPPFLAGS="-DCONF_KERNEL_VERSION_5_15"
endif

ifeq ($(BR2_PACKAGE_AEENC_COMP_DEMO), y)
	CONFIG_DEMO += --enable-aenc_comp_demo=yes
else
	CONFIG_DEMO += --enable-aenc_comp_demo=no
endif

ifeq ($(BR2_PACKAGE_RECORDER_DEMO), y)
	CONFIG_DEMO += --enable-recorder_demo=yes
else
	CONFIG_DEMO += --enable-recorder_demo=no
endif

ifeq ($(BR2_PACKAGE_VENC_COMP_DEMO), y)
	CONFIG_DEMO += --enable-venc_comp_demo=yes
else
	CONFIG_DEMO += --enable-venc_comp_demo=no
endif


define LIBCEDARE_CONFIGURE_CMDS
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
		$(LIBCEDARE_CONF_OPTS) \
	)
endef

define LIBCEDARE_BUILD_CMDS
    echo "Ryan cedare LIBCEDARE_BUILD_CMDS"
#	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libaw* $(STAGING_DIR)/usr/lib
#	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libadecoder.so $(STAGING_DIR)/usr/lib
#	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libaencoder.so $(STAGING_DIR)/usr/lib
#	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libsubdecoder.so $(STAGING_DIR)/usr/lib
#	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/liblive555.so $(STAGING_DIR)/usr/lib
	$(MAKE) -C $(@D)
	$(MAKE) -C $(@D) install
endef

define LIBCEDARE_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include/libcedare
	cp -rf $(@D)/base/include/*.h $(STAGING_DIR)/usr/include/libcedare
	cp -rf $(@D)/components/include/*.h $(STAGING_DIR)/usr/include/libcedare
	cp -rf $(@D)/muxer/include/*.h $(STAGING_DIR)/usr/include/libcedare
	cp -rf $(@D)/muxer/aac/*.h $(STAGING_DIR)/usr/include/libcedare
	cp -rf $(@D)/muxer/base/*.h $(STAGING_DIR)/usr/include/libcedare
	cp -rf $(@D)/muxer/mp4/*.h $(STAGING_DIR)/usr/include/libcedare
	cp -rf $(@D)/muxer/ts/*.h $(STAGING_DIR)/usr/include/libcedare
	cp -rf $(@D)/recorder/*.h $(STAGING_DIR)/usr/include/libcedare
	#install libs to staging_dir
	$(INSTALL) -D -m 0755 $(@D)/muxer/base/.libs/libcde_muxer.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/recorder/.libs/libcedare.so $(STAGING_DIR)/usr/lib/
endef
#fix me
define LIBCEDARE_INSTALL_TARGET_CMDS
    echo "Ryan cedare LIBCEDARE_INSTALL_TARGET_CMDS"
#	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libaw* $(TARGET_DIR)/usr/lib
#	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libadecoder.so $(TARGET_DIR)/usr/lib
#	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libaencoder.so $(TARGET_DIR)/usr/lib
#	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/libsubdecoder.so $(TARGET_DIR)/usr/lib
#	cp -rf $(@D)/external/lib32/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/liblive555.so $(TARGET_DIR)/usr/lib
endef

define LIBCEDARE_INSTALL_CONFIG_CMDS
    echo "Ryan cedare LIBCEDARE_INSTALL_CONFIG_CMDS"
endef

$(eval $(autotools-package))
