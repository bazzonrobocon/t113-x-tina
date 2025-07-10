################################################################################
#
# GPU lib
#
################################################################################
GPU_UM_PUB_SITE_METHOD = local
GPU_UM_PUB_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/display/libgpu
GPU_UM_PUB_LICENSE = GPLv2+, GPLv3+
GPU_UM_PUB_LICENSE_FILES = Copyright COPYING
GPU_UM_PUB_INSTALL_STAGING = YES

ifeq ($(LICHEE_IC), $(filter $(LICHEE_IC), a100 a133 t509))
	GPU_LIB_PATH=$(@D)/img-rgx/fbdev/ge8300/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/lib
	GPU_INS_PATH=$(@D)/img-rgx/include
else ifeq ($(LICHEE_IC), $(filter $(LICHEE_IC), h616 h700 t507 tv303-c1 tv303-c2 tv303-g1 tv303-g2))
	GPU_LIB_PATH=$(@D)/mali-bifrost/fbdev/mali-g31/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/lib
	GPU_INS_PATH=$(@D)/mali-bifrost/include
else ifeq ($(LICHEE_IC), $(filter $(LICHEE_IC), a40i a40i_h a40i_c t3 t3_c t3_pro))
	GPU_LIB_PATH=$(@D)/mali400/fbdev/$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)/lib
	GPU_INS_PATH=$(@D)/mali400/fbdev/include
endif

ifeq ($(BR2_ARCH_SUN55IW3),y)
	GPU_LIB_PATH=$(@D)/mali-g57/fbdev/aarch64-none-linux-gnu/lib64
	GPU_INS_PATH=$(@D)/mali-g57/include
endif

define GPU_UM_PUB_INSTALL_STAGING_CMDS
	cp -rfd $(GPU_LIB_PATH)/* $(STAGING_DIR)/usr/lib
	cp -rfd $(GPU_INS_PATH)/* $(STAGING_DIR)/usr/include/
endef

define GPU_UM_PUB_INSTALL_TARGET_CMDS
	cp -rfd $(GPU_LIB_PATH)/* $(TARGET_DIR)/usr/lib
endef

$(eval $(generic-package))
