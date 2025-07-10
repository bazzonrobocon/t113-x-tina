$(call inherit-product-if-exists, target/allwinner/t113s2-common/t113s2-common.mk)

PRODUCT_PACKAGES +=

PRODUCT_COPY_FILES +=

PRODUCT_AAPT_CONFIG := large xlarge hdpi xhdpi
PRODUCT_AAPT_PERF_CONFIG := xhdpi
PRODUCT_CHARACTERISTICS := musicbox

PRODUCT_BRAND := allwinner
PRODUCT_NAME := t113s2_aw
PRODUCT_DEVICE := t113s2-aw
PRODUCT_MODEL := Allwinner t113s2 aw board
