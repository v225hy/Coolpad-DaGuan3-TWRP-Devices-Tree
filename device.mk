#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/Coolpad/agn2262SG

PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_VIRTUAL_AB_OTA := true
PRODUCT_SHIPPING_API_LEVEL := 33

# Retain the factory payload required before dynamic partitions are mounted.
SPRD_VENDOR_RAMDISK_FILES := \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/recovery/root,vendor_ramdisk)

PRODUCT_COPY_FILES += $(SPRD_VENDOR_RAMDISK_FILES)
SPRD_VENDOR_RAMDISK_FILES :=

PRODUCT_PACKAGES += \
    check_f2fs \
    dump.erofs \
    f2fs_io \
    fsck.erofs \
    sg_write_buffer \
    checkpoint_gc \
    snapuserd \
    android.hardware.fastboot@1.0-impl-mock \
    android.hardware.fastboot@1.0-impl-mock.recovery \
    fastbootd

PRODUCT_HOST_PACKAGES += \
    mkfs.erofs