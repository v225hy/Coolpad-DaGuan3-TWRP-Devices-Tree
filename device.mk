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
#
# These are NOT copied with PRODUCT_COPY_FILES. A .ko is an ELF object, and
# build/make/core/definitions.mk:2658 (copy-non-elf-file-checked) rejects any
# ELF source with:
#     error: found ELF prebuilt in PRODUCT_COPY_FILES,
#            use cc_prebuilt_binary / cc_prebuilt_library_shared instead.
# Instead Android.mk declares one BUILD_PREBUILT module per file and this list
# pulls them in. Module names follow LOCAL_MODULE rules (no dots or dashes):
# the .ko basename has dashes folded to underscores and gets a _recovery
# suffix; LOCAL_MODULE_STEM restores the real on-disk filename.
# ---------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    trusty_recovery \
    trusty_pm_recovery \
    trusty_log_recovery \
    trusty_irq_recovery \
    trusty_ipc_recovery \
    trusty_virtio_recovery \
    sprd_shm_recovery \
    sprd_soc_id_recovery \
    unisoc_iommu_recovery \
    pwm_sprd_recovery \
    apsys_dvfs_recovery \
    sprd_drm_recovery \
    sprd_gsp_recovery \
    ptn38003a_i2c_recovery \
    chipone_tddi_icnl9916_recovery \
    modules_load_recovery \
    modules_dep_recovery \
    modules_softdep

