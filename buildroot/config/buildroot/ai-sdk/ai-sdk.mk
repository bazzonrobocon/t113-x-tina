################################################################################
#
# ai-sdk lib and demo
#
################################################################################
AI_SDK_SITE_METHOD = local
AI_SDK_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/vision/ai-sdk
AI_SDK_LICENSE = GPLv2+, GPLv3+
AI_SDK_LICENSE_FILES = Copyright COPYING

##set default toolchain
CONFIG_TOOLCHAIN_LIBC="aarch64-none-linux-gnu"
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_PREFIX), "glibc-gcc10_2_0")
CONFIG_TOOLCHAIN_LIBC="glibc-gcc10_2_0"
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_PREFIX), "glibc-gcc11_3_0")
CONFIG_TOOLCHAIN_LIBC="glibc-gcc11_3_0"
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL_PREFIX), "aarch64-none-linux-gnu")
CONFIG_TOOLCHAIN_LIBC="aarch64-none-linux-gnu"
endif

PKG_INSTALL_DIR = $(@D)/install

##
#CC #out/t527/demo_linux_car/buildroot/buildroot/host/bin/aarch64-none-linux-gnu-gcc"

##prepare build
TINA_VIPLITE_DIR:= viplite-tina
TINA_UNIFY_DIR:= unify-tina
TINA_COMPILE_DIR:= examples tests $(TINA_VIPLITE_DIR) $(TINA_UNIFY_DIR)

define AI_SDK_BUILD_CMDS
	[ ! -e PKG_INSTALL_DIR ] && mkdir -p $(PKG_INSTALL_DIR)

	if test "$(BR2_PACKAGE_AI_SDK_VIPLITTE)" = "y" ; then \
		mkdir -p $(PKG_INSTALL_DIR)/$(TINA_VIPLITE_DIR); \
		make -C $(@D)/$(TINA_VIPLITE_DIR) \
			INSTALL_PREFIX="$(PKG_INSTALL_DIR)/$(TINA_VIPLITE_DIR)" \
			C_LIB_TYPE=$(CONFIG_TOOLCHAIN_LIBC) \
			all; \
		make -C $(@D)/examples \
			ARCH="$(TARGET_ARCH)" \
			AR="$(TARGET_AR)" \
			CC="$(TARGET_CC)" \
			CXX="$(TARGET_CXX)" \
			CFLAGS="$(LIBUAPI_CFLAGS)" \
			LDFLAGS="$(LIBUAPI_LDFLAGS)" \
			INSTALL_PREFIX="$(PKG_INSTALL_DIR)/$(TINA_VIPLITE_DIR)" \
			C_LIB_TYPE=$(CONFIG_TOOLCHAIN_LIBC) \
			all; \
	fi;

	if test "$(BR2_PACKAGE_AI_SDK_VIPLITTE_SAMPLE)" = "y" ; then \
		mkdir -p $(PKG_INSTALL_DIR)/$(TINA_VIPLITE_DIR)/etc/npu/sample_viplite; \
		cp -r $(@D)/tests/* $(PKG_INSTALL_DIR)/$(TINA_VIPLITE_DIR)/etc/npu/sample_viplite; \
	fi;

	if test "$(BR2_PACKAGE_AI_SDK_UNIFY)" = "y" ; then \
		mkdir -p $(PKG_INSTALL_DIR)/$(TINA_UNIFY_DIR); \
		make -C $(@D)/$(TINA_UNIFY_DIR) \
			INSTALL_PREFIX="$(PKG_INSTALL_DIR)/$(TINA_UNIFY_DIR)" \
			C_LIB_TYPE=$(CONFIG_TOOLCHAIN_LIBC) \
			all; \
	fi;

endef

define AI_SDK_INSTALL_TARGET_CMDS
	if test "$(BR2_PACKAGE_AI_SDK_VIPLITTE)" = "y" ; then \
		cp -r $(PKG_INSTALL_DIR)/$(TINA_VIPLITE_DIR)/usr/lib/* $(TARGET_DIR)/usr/lib/; \
		cp -r $(PKG_INSTALL_DIR)/$(TINA_VIPLITE_DIR)/usr/bin/* $(TARGET_DIR)/usr/bin/; \
		mkdir -p $(TARGET_DIR)/etc/npu/; \
		cp -r $(PKG_INSTALL_DIR)/$(TINA_VIPLITE_DIR)/etc/npu/* $(TARGET_DIR)/etc/npu/; \
	fi;

	if test "$(BR2_PACKAGE_AI_SDK_UNIFY)" = "y" ; then \
		cp -r $(PKG_INSTALL_DIR)/$(TINA_UNIFY_DIR)/usr/lib/* $(TARGET_DIR)/usr/lib/; \
	fi;

endef

$(eval $(generic-package))
