#
# TWRP common device config for Coolpad CP3NV1 (酷派大观3)
# Unisoc UMS9620 (qogirn6pro) / board: agn2262SG
#
# Product identity lives in twrp_agn2262SG.mk (registered via AndroidProducts.mk).
#
# NOTE: use $(LOCAL_PATH), not $(DEVICE_PATH). DEVICE_PATH is only defined while
# BoardConfig.mk is evaluated; inside a product makefile it expands to nothing,
# which silently turns "$(DEVICE_PATH)/recovery.fstab" into "/recovery.fstab"
# and the build dies with:
#   ninja: '/recovery.fstab', needed by '.../recovery/root/etc/recovery.fstab',
#   missing and no known rule to make it
#

LOCAL_PATH := device/Coolpad/agn2262SG

# Inherit from vendor
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, vendor/twrp/config/common.mk)

# This is a recovery-only build: never try to assemble a replacement super image.
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

LOCAL_DEVICE_PATH := $(LOCAL_PATH)

# Recovery fstab & init
PRODUCT_COPY_FILES += \
    $(LOCAL_DEVICE_PATH)/recovery.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/etc/recovery.fstab \
    $(LOCAL_DEVICE_PATH)/init.recovery.agn2262SG.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.agn2262SG.rc \
    $(LOCAL_DEVICE_PATH)/twrp.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/etc/twrp.fstab

# ---------------------------------------------------------------------------
# Recovery 显示栈模块（展讯 DRM 修复 L1）
# 来源：vendor_boot vendor_ramdisk /lib/modules/（与内核 5.4.210 完全同源）
# 顺序依据：原厂 modules.load.recovery
# 必须整套打入 ramdisk，缺 trusty.ko 会导致 sprd-drm/gsp insmod 失败 -> 黑屏
# ---------------------------------------------------------------------------
PRODUCT_COPY_FILES += \
    $(LOCAL_DEVICE_PATH)/modules_recovery/trusty.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/trusty-pm.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-pm.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/trusty-log.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-log.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/trusty-irq.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-irq.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/trusty-ipc.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-ipc.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/trusty-virtio.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-virtio.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/sprd_shm.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sprd_shm.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/sprd_soc_id.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sprd_soc_id.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/unisoc-iommu.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/unisoc-iommu.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/pwm-sprd.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/pwm-sprd.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/apsys-dvfs.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/apsys-dvfs.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/sprd-drm.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sprd-drm.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/sprd-gsp.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sprd-gsp.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/ptn38003a-i2c.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/ptn38003a-i2c.ko \
    $(LOCAL_DEVICE_PATH)/modules_recovery/chipone-tddi-icnl9916.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/chipone-tddi-icnl9916.ko
