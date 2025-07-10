LAUNCHER_MARTIN_SITE_METHOD = local
LAUNCHER_MARTIN_SITE = $(PLATFORM_PATH)/../../package/auto/qt-demo/launcher-martin

ifeq ($(BR2_PACKAGE_QT5_EXTERNAL),y)
LAUNCHER_MARTIN_DEPENDENCIES = qt5_external
else
LAUNCHER_MARTIN_DEPENDENCIES = qt5base
endif

define LAUNCHER_MARTIN_BUILD_CMDS

	$(HOST_DIR)/bin/qmake -o $(@D)/Makefile $(@D)/launcher.pro
	$(MAKE) CC="$(TARGET_CC)" -C $(@D)
endef

define LAUNCHER_MARTIN_INSTALL_TARGET_CMDS

	$(INSTALL) -D -m 0755 $(@D)/qtlauncher $(TARGET_DIR)/usr/bin
	cp -r $(@D)/resources $(TARGET_DIR)/etc/resources/
	cp -r $(@D)/applauncher $(TARGET_DIR)/usr/share/
	cp -r $(@D)/fonts $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
