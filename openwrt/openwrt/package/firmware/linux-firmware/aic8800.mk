Package/aic8800-firmware = $(call Package/firmware-default,AIC aic8800 firmware)

SRC_CODE_DIR:=$(AIC8800_FW)

define Package/aic8800-firmware/install
	$(INSTALL_DIR) $(1)/$(FIRMWARE_PATH)
	$(INSTALL_DIR) $(1)/$(FIRMWARE_PATH)aic8800d80/

	$(INSTALL_DATA) $(SRC_CODE_DIR)/*.* $(1)/$(FIRMWARE_PATH)
	$(INSTALL_DATA) $(SRC_CODE_DIR)/aic8800d80/*.* $(1)/$(FIRMWARE_PATH)aic8800d80
endef
$(eval $(call BuildPackage,aic8800-firmware))


