#
# TWRP common device config for Coolpad CP3NV1 (酷派大观3)
# Unisoc UMS9620 (qogirn6pro) / board: agn2262SG
#
# Product identity lives in twrp_agn2262SG.mk (registered via AndroidProducts.mk).
#
# IMPORTANT — do NOT use $(LOCAL_PATH) or $(DEVICE_PATH) in this file.
#
#   * $(DEVICE_PATH) is only defined while BoardConfig.mk is being evaluated.
#   * $(LOCAL_PATH) is *reset by the build system* around the product-makefile
#     eval (build/make/core/product.mk clears it), and because this file is
#     pulled in through inherit-product it is empty here too.
#
# Either one silently turns "device/Coolpad/agn2262SG/recovery.fstab" into
# "/recovery.fstab", and ninja dies with:
#   FAILED: ninja: '/recovery.fstab', needed by
#     'out/target/product/agn2262SG/obj/PACKAGING/recovery_intermediates/ramdisk_files-timestamp',
#     missing and no known rule to make it
#
# So every source path below is spelled out literally.
#

# Inherit from vendor
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, vendor/twrp/config/common.mk)

# This is a recovery-only build: never try to assemble a replacement super image.
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

# Recovery fstab & init
PRODUCT_COPY_FILES += \
    device/Coolpad/agn2262SG/recovery.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/etc/recovery.fstab \
    device/Coolpad/agn2262SG/init.recovery.agn2262SG.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.agn2262SG.rc \
    device/Coolpad/agn2262SG/twrp.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/etc/twrp.fstab

# ---------------------------------------------------------------------------
# Recovery 显示栈模块（展讯 DRM 修复 L1）
# 来源：vendor_boot vendor_ramdisk /lib/modules/（与内核 5.4.210 完全同源）
# 顺序依据：原厂 modules.load.recovery
# 必须整套打入 ramdisk，缺 trusty.ko 会导致 sprd-drm/gsp insmod 失败 -> 黑屏
# ---------------------------------------------------------------------------
PRODUCT_COPY_FILES += \
    device/Coolpad/agn2262SG/modules_recovery/trusty.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty.ko \
    device/Coolpad/agn2262SG/modules_recovery/trusty-pm.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-pm.ko \
    device/Coolpad/agn2262SG/modules_recovery/trusty-log.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-log.ko \
    device/Coolpad/agn2262SG/modules_recovery/trusty-irq.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-irq.ko \
    device/Coolpad/agn2262SG/modules_recovery/trusty-ipc.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-ipc.ko \
    device/Coolpad/agn2262SG/modules_recovery/trusty-virtio.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/trusty-virtio.ko \
    device/Coolpad/agn2262SG/modules_recovery/sprd_shm.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sprd_shm.ko \
    device/Coolpad/agn2262SG/modules_recovery/sprd_soc_id.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sprd_soc_id.ko \
    device/Coolpad/agn2262SG/modules_recovery/unisoc-iommu.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/unisoc-iommu.ko \
    device/Coolpad/agn2262SG/modules_recovery/pwm-sprd.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/pwm-sprd.ko \
    device/Coolpad/agn2262SG/modules_recovery/apsys-dvfs.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/apsys-dvfs.ko \
    device/Coolpad/agn2262SG/modules_recovery/sprd-drm.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sprd-drm.ko \
    device/Coolpad/agn2262SG/modules_recovery/sprd-gsp.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sprd-gsp.ko \
    device/Coolpad/agn2262SG/modules_recovery/ptn38003a-i2c.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/ptn38003a-i2c.ko \
    device/Coolpad/agn2262SG/modules_recovery/chipone-tddi-icnl9916.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/chipone-tddi-icnl9916.ko
