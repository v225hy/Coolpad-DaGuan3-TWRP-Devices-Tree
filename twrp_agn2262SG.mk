#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product-if-exists, vendor/twrp/config/common.mk)

$(call inherit-product, device/Coolpad/agn2262SG/device.mk)

PRODUCT_DEVICE := agn2262SG
PRODUCT_NAME := twrp_agn2262SG
PRODUCT_BRAND := Coolpad
PRODUCT_MODEL := CP3NV1
PRODUCT_MANUFACTURER := Coolpad
PRODUCT_RELEASE_NAME := agn2262SG

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="agn2262SG_CP25P_G1_UX12848_T_V07-user 13 CP25P.250922.0S.DGY 1758541269 release-keys"
BUILD_FINGERPRINT := Coolpad/CP3NV1/CP3NV1:13/CP25P.250922.0S.DGY/1758541269:user/release-keys
