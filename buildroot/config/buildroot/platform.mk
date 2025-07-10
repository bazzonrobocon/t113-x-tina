PLATFORM_PATH := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
include ${PLATFORM_PATH}/allwinner/utils/mtop/mtop.mk
include ${PLATFORM_PATH}/allwinner/utils/cpu_monitor/cpu_monitor.mk
include ${PLATFORM_PATH}/allwinner/wireless/wifimanager/wifimanager.mk

include ${PLATFORM_PATH}/qt5_external/qt5_external.mk
include ${PLATFORM_PATH}/qt-demo/qt-launcher/qt-launcher.mk
include ${PLATFORM_PATH}/qt-demo/launcher-martin/launcher-martin.mk
include ${PLATFORM_PATH}/qt-demo/qt-keypad/qt-keypad.mk
include ${PLATFORM_PATH}/qt-demo/qt-rtc/qt-rtc.mk
include ${PLATFORM_PATH}/qt-demo/qt-watchdog/qt-watchdog.mk


include ${PLATFORM_PATH}/allwinner/usb/mtp/mtp.mk
include ${PLATFORM_PATH}/allwinner/usb/adbd/adbd.mk
include ${PLATFORM_PATH}/allwinner/pqd/pqd.mk
include ${PLATFORM_PATH}/allwinner/powerkey_display/powerkey_display.mk
include ${PLATFORM_PATH}/allwinner/powerkey_suspend/powerkey_suspend.mk

include ${PLATFORM_PATH}/allwinner/system/busybox-init-base-files/busybox-init-base-files.mk
include ${PLATFORM_PATH}/allwinner/system/ota/ota-burnboot/ota-burnboot.mk
#multimedia
include ${PLATFORM_PATH}/allwinner/multimedia/libcedarc/libcedarc.mk
include ${PLATFORM_PATH}/allwinner/multimedia/libcedarx/libcedarx.mk
include ${PLATFORM_PATH}/allwinner/multimedia/libcedare/libcedare.mk
include ${PLATFORM_PATH}/allwinner/multimedia/libcedarse/libcedarse.mk
include ${PLATFORM_PATH}/allwinner/multimedia/libtmedia/jpegdecode/jpegdecode.mk
include ${PLATFORM_PATH}/allwinner/multimedia/libtmedia/tplayer/tplayer.mk
include ${PLATFORM_PATH}/allwinner/multimedia/libtmedia/trecorder/trecorder.mk
include ${PLATFORM_PATH}/allwinner/multimedia/tina_multimedia_demo/tina_multimedia_demo.mk

include ${PLATFORM_PATH}/lvgl-8/lvgl-8.mk
include ${PLATFORM_PATH}/libuapi/libuapi.mk
include ${PLATFORM_PATH}/gpu_um_pub/gpu_um_pub.mk
include ${PLATFORM_PATH}/wifi-firmware/wifi-firmware.mk
include ${PLATFORM_PATH}/amp_shell/amp_shell.mk
include ${PLATFORM_PATH}/rpmsg/rpmsg.mk
include ${PLATFORM_PATH}/rpbuf/rpbuf.mk
include ${PLATFORM_PATH}/allwinner/wireless/wireless_common/wireless_common.mk
include ${PLATFORM_PATH}/allwinner/wireless/btmanager/btmanager.mk
include ${PLATFORM_PATH}/ai-sdk/ai-sdk.mk
