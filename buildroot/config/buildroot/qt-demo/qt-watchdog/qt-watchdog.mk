QT_WATCHDOG_SITE_METHOD = local
QT_WATCHDOG_SITE = $(PLATFORM_PATH)/../../package/auto/qt-demo/watchdog

ifeq ($(BR2_PACKAGE_QT5_EXTERNAL),y)
QT_WATCHDOG_DEPENDENCIES = qt5_external
else
QT_WATCHDOG_DEPENDENCIES = qt5base
endif

define QT_WATCHDOG_BUILD_CMDS
	$(HOST_DIR)/bin/qmake -o $(@D)/Makefile $(@D)/watchdog.pro
	$(MAKE) CC="$(TARGET_CC)" -C $(@D)
endef

define QT_WATCHDOG_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/qt_test_watchdog $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
