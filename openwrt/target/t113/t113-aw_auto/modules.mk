#
# Copyright (C) 2015-2016 Allwinner
#
# This is free software, licensed under the GNU General Public License v2.
# See /build/LICENSE for more information.

define KernelPackage/sunxi-vin-n5_dvp
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=sunxi-vin-n5_dvp support
  FILES:=$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-memops.ko
  FILES+=$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-dma-contig.ko
  FILES+=$(LINUX_DIR)/drivers/media/platform/sunxi-vin/vin_io.ko
  FILES+=$(LINUX_DIR)/drivers/media/platform/sunxi-vin/modules/sensor/n5_dvp.ko
  FILES+=$(LINUX_DIR)/drivers/media/platform/sunxi-vin/vin_v4l2.ko
  KCONFIG:=\
	CONFIG_MEDIA_SUPPORT=y \
	CONFIG_MEDIA_CAMERA_SUPPORT=y \
    CONFIG_V4L_PLATFORM_DRIVERS=y \
    CONFIG_MEDIA_CONTROLLER=y \
    CONFIG_MEDIA_SUBDRV_AUTOSELECT=y \
	CONFIG_SUNXI_PLATFORM_DRIVERS=y \
    CONFIG_VIDEO_SUNXI_VIN \
    CONFIG_CSI_VIN \
	CONFIG_CSI_CCI=n \
	CONFIG_I2C_SUNXI=y
#  AUTOLOAD:=$(call AutoLoad,91,videobuf2-memops videobuf2-dma-contig vin_io n5_dvp vin_v4l2)
endef

define KernelPackage/sunxi-vin-n5_dvp/description
  Kernel modules for sunxi-vin-n5_dvp support
endef

$(eval $(call KernelPackage,sunxi-vin-n5_dvp))
