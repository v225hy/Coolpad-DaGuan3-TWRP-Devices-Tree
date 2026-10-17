#
# TWRP common device config for Coolpad CP3NV1 (酷派大观3)
# Unisoc UMS9620 (qogirn6pro) / board: agn2262SG
#
# Product identity lives in twrp_agn2262SG.mk (registered via AndroidProducts.mk).
#

# Inherit from vendor
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, vendor/twrp/config/common.mk)

# Recovery fstab & init
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/etc/recovery.fstab \
    $(DEVICE_PATH)/init.recovery.agn2262SG.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.agn2262SG.rc \
    $(DEVICE_PATH)/twrp.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/etc/twrp.fstab

# ---------------------------------------------------------------------------
# Recovery 显示栈模块（展讯 DRM 修复 L1）
# 来源：vendor_boot vendor_ramdisk /lib/modules/（与内核 5.4.210 完全同源）
# 顺序依据：原厂 modules.load.recovery
# 必须整套打入 ramdisk，缺 trusty.ko 会导致 sprd-drm/gsp insmod 失败 -> 黑屏
# ---------------------------------------------------------------------------
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/modules_recovery/trusty.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty.ko \
    $(DEVICE_PATH)/modules_recovery/trusty-pm.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-pm.ko \
    $(DEVICE_PATH)/modules_recovery/trusty-log.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-log.ko \
    $(DEVICE_PATH)/modules_recovery/trusty-irq.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-irq.ko \
    $(DEVICE_PATH)/modules_recovery/trusty-ipc.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-ipc.ko \
    $(DEVICE_PATH)/modules_recovery/trusty-virtio.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-virtio.ko \
    $(DEVICE_PATH)/modules_recovery/sprd_shm.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sprd_shm.ko \
    $(DEVICE_PATH)/modules_recovery/sprd_soc_id.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sprd_soc_id.ko \
    $(DEVICE_PATH)/modules_recovery/unisoc-iommu.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/unisoc-iommu.ko \
    $(DEVICE_PATH)/modules_recovery/pwm-sprd.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/pwm-sprd.ko \
    $(DEVICE_PATH)/modules_recovery/apsys-dvfs.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/apsys-dvfs.ko \
    $(DEVICE_PATH)/modules_recovery/sprd-drm.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sprd-drm.ko \
    $(DEVICE_PATH)/modules_recovery/sprd-gsp.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sprd-gsp.ko \
    $(DEVICE_PATH)/modules_recovery/ptn38003a-i2c.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/ptn38003a-i2c.ko \
    $(DEVICE_PATH)/modules_recovery/chipone-tddi-icnl9916.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/chipone-tddi-icnl9916.ko
