################################################################################
#
# pqd package
#
################################################################################
PQD_SITE_METHOD = local
PQD_SITE = $(PLATFORM_PATH)/../../../platform/allwinner/display/pqd

PQD_LICENSE = GPLv2+, GPLv3+
PQD_LICENSE_FILES = Copyright COPYING

PQD_CFLAGS = $(TARGET_CFLAGS)
PQD_CFLAGS += -mfloat-abi=softfp -mfpu=vfpv3
PQD_CFLAGS += -I$(@D)/hardwares/de20x/ -I$(STAGING_DIR)/usr/include -I$(@D) -I$(@D)/utils
PQD_LDFLAGS = $(TARGET_LDFLAGS)
PQD_LDFLAGS += -L$(TARGET_DIR)/usr/lib/ -lpthread -lm

define PQD_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" CFLAGS="$(PQD_CFLAGS)" \
		LDFLAGS="$(PQD_LDFLAGS)" -C $(@D) all
endef

define PQD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/pqd $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
