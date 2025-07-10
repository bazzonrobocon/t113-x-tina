QT_LAUNCHER_SITE_METHOD = local
QT_LAUNCHER_SITE = $(PLATFORM_PATH)/../../package/auto/qt-demo/launcher

ifeq ($(BR2_PACKAGE_QT5_EXTERNAL),y)
QT_LAUNCHER_DEPENDENCIES = qt5_external
else
QT_LAUNCHER_DEPENDENCIES = qt5base
endif

define QT_LAUNCHER_BUILD_CMDS
	$(HOST_DIR)/bin/qmake -o $(@D)/Makefile $(@D)/Launcher.pro
	$(MAKE) CC="$(TARGET_CC)" -C $(@D)
endef

define QT_LAUNCHER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/Launcher $(TARGET_DIR)/usr/bin
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/images
	cp -r $(@D)/images $(TARGET_DIR)
endef

$(eval $(generic-package))
