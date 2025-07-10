################################################################################
#
# busybox-init-base-files
#
################################################################################
BUSYBOX_INIT_BASE_FILES_SITE_METHOD = local
BUSYBOX_INIT_BASE_FILES_SITE = $(PLATFORM_PATH)/allwinner/system/busybox-init-base-files
BUSYBOX_INIT_BASE_FILES_LICENSE = GPLv2+, GPLv3+
BUSYBOX_INIT_BASE_FILES_LICENSE_FILES = Copyright COPYING

ifeq ($(LICHEE_BOARD), $(filter $(LICHEE_BOARD), p3-rawnand-ubi p3-spinand-ubi))
	OTA_FILES_PATH=$(@D)/ota-config/p3-nand-ubi
else
	OTA_FILES_PATH=$(@D)/ota-config/p3
endif

ifeq ($(LICHEE_CHIP), $(filter $(LICHEE_CHIP), sun8iw11p1))
	ASOUND_CONF_FILES=$(@D)/audio-config/asound.conf-$(LICHEE_CHIP)
else ifeq ($(LICHEE_CHIP), $(filter $(LICHEE_CHIP), sun8iw20p1))
	ASOUND_CONF_FILES=$(@D)/audio-config/asound.conf-$(LICHEE_CHIP)
else ifeq ($(LICHEE_CHIP), $(filter $(LICHEE_CHIP), sun55iw3p1))
	ASOUND_CONF_FILES=$(@D)/audio-config/asound.conf-$(LICHEE_CHIP)
else
	ASOUND_CONF_FILES=$(@D)/audio-config/asound.conf
endif

#config boot scripts for audio
ifeq ($(LICHEE_IC), $(filter $(LICHEE_IC), t113_s3p t113_s4 t113_s4p))
	ASOUND_BOOT_SCRIPTS=$(@D)/audio-config/S80bootplay-$(LICHEE_IC)
else
	ASOUND_BOOT_SCRIPTS=$(@D)/audio-config/S80bootplay
endif

define BUSYBOX_INIT_BASE_FILES_BUILD_CMDS
	cp -rf $(PLATFORM_PATH)/allwinner/system/busybox-init-base-files/etc/* $(@D)/etc/
	cp -rf $(PLATFORM_PATH)/allwinner/system/busybox-init-base-files/ota-config $(@D)/
	cp -rf $(PLATFORM_PATH)/allwinner/system/busybox-init-base-files/audio-config $(@D)/
endef

define BUSYBOX_INIT_BASE_FILES_INSTALL_TARGET_CMDS
	cp -rf $(@D)/etc/* $(TARGET_DIR)/etc/
	cp -rf $(OTA_FILES_PATH)/* $(TARGET_DIR)/etc/
	cp -rf $(ASOUND_CONF_FILES) $(TARGET_DIR)/etc/asound.conf
	cp -rf $(ASOUND_BOOT_SCRIPTS) $(TARGET_DIR)/etc/init.d/S80bootplay
endef

$(eval $(generic-package))
