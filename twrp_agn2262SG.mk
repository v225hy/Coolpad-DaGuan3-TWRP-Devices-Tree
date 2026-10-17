#
# Copyright (C) 2026 The TWRP Recovery Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Coolpad DaGuan3 (CP3NV1) - Unisoc UMS9620 / agn2262SG
#

# Inherit from the common device config
$(call inherit-product, device/Coolpad/agn2262SG/device.mk)

# Device identifier
PRODUCT_DEVICE := agn2262SG
PRODUCT_NAME := twrp_agn2262SG
PRODUCT_BRAND := Coolpad
PRODUCT_MODEL := CP3NV1
PRODUCT_MANUFACTURER := Coolpad

# Stock properties fingerprint (Android 13 / SDK 33)
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_DEVICE=CP3NV1 \
    PRODUCT_NAME=CP3NV1 \
    TARGET_DEVICE=CP3NV1

# A/B slot
PRODUCT_PROPERTY_OVERRIDES += \
    ro.boot.slot_suffix=_a \
    ro.build.product=CP3NV1 \
    ro.product.device=CP3NV1

# Unisoc specific
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware=agn2262SG \
    ro.board.platform=ums9620 \
    ro.boot.hardware=agn2262SG

# TWRP config
TW_DEVICE_VERSION := 1
TW_DEVICE_NAME := CP3NV1
