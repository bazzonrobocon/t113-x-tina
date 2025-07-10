QT_RTC_SITE_METHOD = local
QT_RTC_SITE = $(PLATFORM_PATH)/../../package/auto/qt-demo/rtc

ifeq ($(BR2_PACKAGE_QT5_EXTERNAL),y)
QT_RTC_DEPENDENCIES = qt5_external
else
QT_RTC_DEPENDENCIES = qt5base
endif

define QT_RTC_BUILD_CMDS
	$(HOST_DIR)/bin/qmake -o $(@D)/Makefile $(@D)/rtc.pro
	$(MAKE) CC="$(TARGET_CC)" -C $(@D)
endef

define QT_RTC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/qt_test_rtc $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
