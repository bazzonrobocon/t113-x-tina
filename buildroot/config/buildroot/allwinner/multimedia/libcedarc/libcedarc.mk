################################################################################
#
# libcedare lib
#
################################################################################
LIBCEDARC_SITE_METHOD = local

LIBCEDARC_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/multimedia/libcedarc
LIBCEDARC_LICENSE = GPLv2+, GPLv3+
LIBCEDARC_LICENSE_FILES = Copyright COPYING
LIBCEDARC_INSTALL_TARGET = YES
LIBCEDARC_INSTALL_STAGING = YES
LIBCEDARC_AUTORECONF = YES
#LIBCEDARC_GETTEXTIZE = YES

ifeq ($(LICHEE_KERN_VER), linux-5.10)
LIBCEDARC_CFLAGS += -DCONF_KERNEL_VERSION_5_10
LIBCEDARC_CPPFLAGS += -DCONF_KERNEL_VERSION_5_10
else ifeq ($(LICHEE_KERN_VER), linux-5.4)
LIBCEDARC_CFLAGS += -DCONF_KERNEL_VERSION_5_4 -D__LINUX__ -DCONF_USE_IOMMU
LIBCEDARC_CPPFLAGS += -DCONF_KERNEL_VERSION_5_4
else ifeq ($(LICHEE_KERN_VER), linux-4.9)
LIBCEDARC_CFLAGS += -DCONF_KERNEL_VERSION_4_9
LIBCEDARC_CPPFLAGS += -DCONF_KERNEL_VERSION_4_9
else ifeq ($(LICHEE_KERN_VER), linux-5.15)
LIBCEDARC_CFLAGS += -DCONF_KERNEL_VERSION_5_15 -D__LINUX__ -DCONF_USE_IOMMU
LIBCEDARC_CPPFLAGS += -DCONF_KERNEL_VERSION_5_15
endif
LIBCEDARC_LDFLAGS += -L$(STAGING_DIR)/usr/lib

ifeq ($(LICHEE_IC), $(filter $(LICHEE_IC), t113 t113s2 t113_s3p t113_s4 t113_s4p t113_i t527 a527))
	LIBCEDARC_CFLAGS += -DTINA_LINUX_SUPPORT=1
endif
define LIBCEDARC_CONFIGURE_CMDS
	(cd $(@D); \
	$(TARGET_CONFIGURE_ARGS) \
	CONFIG_SITE=/dev/null \
	$(AUTOMAKE) --add-missing; \
	$(AUTORECONF); \
	./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
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
		$(TARGET_CONFIGURE_OPTS) \
		$(DISABLE_NLS) \
		$(SHARED_STATIC_LIBS_OPTS) \
		CFLAGS="$(LIBCEDARC_CFLAGS)" \
		CPPFLAGS="$(LIBCEDARC_CPPFLAGS)" \
		LDFLAGS="$(LIBCEDARC_LDFLAGS)" \
	)
endef

define LIBCEDARC_BUILD_CMDS
	cp -rf $(@D)/library/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/* $(STAGING_DIR)/usr/lib
	$(MAKE) -C $(@D)
	#$(MAKE) -C $(@D) \
	#	CFLAGS="$(CEDARC_BUILD_CFLAGS)"
	$(MAKE) -C $(@D) install
endef

define LIBCEDARC_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include/libcedarc
	cp -rf $(@D)/include/*.h $(STAGING_DIR)/usr/include/libcedarc
	#install release-libs that compile by sdk.
	$(INSTALL) -D -m 0755 $(@D)/base/.libs/libcdc_base.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/vdecoder/fbm/.libs/libfbm.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/vdecoder/sbm/.libs/libsbm.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/vdecoder/aftertreatment/.libs/libaftertreatment.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/vdecoder/.libs/libvdecoder.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/vencoder/base/.libs/libvenc_base.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/vencoder/.libs/libvencoder.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/openmax/vdec/.libs/libOmxVdec.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/openmax/venc/.libs/libOmxVenc.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/openmax/omxcore/.libs/libOmxCore.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/memory/.libs/libMemAdapter.so $(STAGING_DIR)/usr/lib/
endef

#fix me
define LIBCEDARC_INSTALL_TARGET_CMDS
	cp -rf $(@D)/library/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/*.so $(TARGET_DIR)/usr/lib
	cp -rf $(@D)/conf/cedarc.conf $(TARGET_DIR)/etc/
endef

$(eval $(autotools-package))
