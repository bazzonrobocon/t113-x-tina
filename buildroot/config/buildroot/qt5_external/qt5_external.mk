################################################################################
#
# libqt5  lib
#
################################################################################
QT5_EXTERNAL_SITE_METHOD = local
QT5_EXTERNAL_SITE = $(PLATFORM_PATH)/../../package/qt/qt-everywhere-src-5.12.5
QT5_EXTERNAL_LICENSE = GPLv2+, GPLv3+
QT5_EXTERNAL_LICENSE_FILES = Copyright COPYING
QT5_EXTERNAL_INSTALL_TARGET = YES
QT5_EXTERNAL_INSTALL_STAGING = YES
QT5_EXTERNAL_DEPENDENCIES = gpu_um_pub alsa-lib

QT5_CPLUS_INCLUDE_PATH = $(@D)/qtbase/src/3rdparty/angle/include

ifeq ($(BR2_ARCH_SUN55IW3),y)
LIBDIR_MALI = -lmali
else
LIBDIR_MALI =
endif

define QT5_EXTERNAL_CONFIGURE_CMDS
	(cd $(@D); \
	$(TARGET_MAKE_ENV) \
	PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
	MAKEFLAGS="-j$(PARALLEL_JOBS) $(MAKEFLAGS)" \
	$(TARGET_CONFIGURE_ARGS) \
	./configure \
		-I $(QT5_CPLUS_INCLUDE_PATH) \
		-opensource \
		-confirm-license \
		-prefix /usr \
		-hostprefix $(HOST_DIR) \
		-sysroot $(STAGING_DIR) \
		-headerdir /usr/include/qt5 \
		-plugindir /usr/lib/qt/plugins \
		-xplatform linux-aarch64-none-gnu-g++ \
		-R /usr/lib \
		-no-strip \
		-c++std c++11 \
		-shared \
		-nomake examples \
		-accessibility \
		-device-option CROSS_COMPILE="$(TARGET_CROSS)" \
		-device-option CROSS_COMPILE="$(TARGET_CROSS)" \
		-device-option COMPILER_CFLAGS="$(TARGET_CFLAGS)" \
		-device-option QMAKE_LIBDIR_MALI="$(LIBDIR_MALI)" \
		-no-sql-db2 -no-sql-ibase -no-sql-mysql -no-sql-oci \
		-no-sql-odbc -no-sql-psql -no-sql-sqlite2  -no-sql-tds \
 		-no-sql-sqlite -plugin-sql-sqlite \
 		-no-sql-sqlite -plugin-sql-sqlite \
		-no-qml-debug \
		-no-sse2 \
		-no-sse3 \
		-no-ssse3 \
		-no-sse4.1 \
		-no-sse4.2 \
		-no-avx \
		-no-avx2 \
		-no-mips_dsp \
		-no-mips_dspr2 \
		-qt-zlib \
		-no-journald \
		-qt-libpng \
		-qt-libjpeg \
		-qt-freetype \
		-qt-harfbuzz \
		-no-openssl \
		-no-xcb-xlib \
		-no-glib \
		-no-pulseaudio \
		-alsa \
		-gui \
		-widgets \
		-v \
		-optimized-qmake \
		-no-cups \
		-no-iconv \
		-evdev \
		-no-icu \
		-no-fontconfig \
		-no-strip \
		-pch \
		-dbus \
		-no-use-gold-linker \
		-no-directfb \
		-eglfs \
		-qpa no-eglfs \
		-linuxfb \
		-no-kms \
		-opengl es2 \
		-no-system-proxies \
		-no-slog2 \
		-no-pps \
		-no-imf \
		-no-lgmon \
		-no-tslib \
	)
endef

define QT5_EXTERNAL_BUILD_CMDS
	$(MAKE) -C $(@D)
	$(MAKE) -C $(@D) install
endef

define QT5_EXTERNAL_INSTALL_STAGING_CMDS
	mkdir -p $(TARGET_DIR)/usr/local/Qt_5.12.5
	mkdir -p $(HOST_DIR)/mkspecs
endef

#fix me
define QT5_EXTERNAL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m0755 $(@D)/qtbase/bin/* $(HOST_DIR)/bin/
	cp -rf $(@D)/qtbase/mkspecs/* $(HOST_DIR)/mkspecs/
	cp -rf $(@D)/qtbase/lib $(TARGET_DIR)/usr/local/Qt_5.12.5/
	cp -rf $(@D)/qtbase/plugins $(TARGET_DIR)/usr/local/Qt_5.12.5/
	cp -rf $(@D)/fonts $(TARGET_DIR)/usr/local/Qt_5.12.5/
	cp -rf $(@D)/qtenv.sh $(TARGET_DIR)/etc/
	rm -rf $(TARGET_DIR)/usr/local/Qt_5.12.5/lib/cmake
	rm -rf $(TARGET_DIR)/usr/local/Qt_5.12.5/pkgconfig
	rm -rf $(TARGET_DIR)/usr/local/Qt_5.12.5/lib/*.a
	rm -rf $(TARGET_DIR)/usr/local/Qt_5.12.5/lib/*.prl
	rm -rf $(TARGET_DIR)/usr/local/Qt_5.12.5/lib/*.la
endef

$(eval $(autotools-package))
