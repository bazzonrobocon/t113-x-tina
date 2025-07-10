QT_KEYPAD_SITE_METHOD = local
QT_KEYPAD_SITE = $(PLATFORM_PATH)/../../package/auto/qt-demo/keypad

ifeq ($(BR2_PACKAGE_QT5_EXTERNAL),y)
QT_KEYPAD_DEPENDENCIES = qt5_external
else
QT_KEYPAD_DEPENDENCIES = qt5base
endif

define QT_KEYPAD_BUILD_CMDS
	$(HOST_DIR)/bin/qmake -o $(@D)/Makefile $(@D)/keypad.pro
	$(MAKE) CC="$(TARGET_CC)" -C $(@D)
endef

define QT_KEYPAD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/qt_test_keypad $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
