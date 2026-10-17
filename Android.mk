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
# Prebuilt kernel modules for the recovery ramdisk.
#
# Why not PRODUCT_COPY_FILES?
#   build/make/core/definitions.mk:2658 defines copy-non-elf-file-checked, which
#   runs `llvm-readobj -h` on every PRODUCT_COPY_FILES source and hard-fails:
#       error: found ELF prebuilt in PRODUCT_COPY_FILES,
#              use cc_prebuilt_binary / cc_prebuilt_library_shared instead.
#       error: found ELF file: .../apsys-dvfs.ko
#   A .ko is an ELF object, so every module trips that check.
#
# Instead each module is declared as a BUILD_PREBUILT module here and pulled in
# through PRODUCT_PACKAGES, which installs it via the prebuilt path (no ELF
# check) into recovery/root/lib/modules.
#

LOCAL_PATH := $(call my-dir)

# ---------------------------------------------------------------------------
# Helper: define one prebuilt module per .ko
# ---------------------------------------------------------------------------
define add-recovery-ko
include $(CLEAR_VARS)
LOCAL_MODULE        := $(subst -,_,$(basename $(1)))_recovery
LOCAL_MODULE_STEM   := $(1)
LOCAL_MODULE_CLASS  := ETC
LOCAL_MODULE_PATH   := recovery/root/lib/modules
LOCAL_SRC_FILES     := modules_recovery/$(1)
LOCAL_MODULE_TAGS   := optional
include $(BUILD_PREBUILT)
endef

RECOVERY_KO_MODULES := \
    trusty.ko \
    trusty-pm.ko \
    trusty-log.ko \
    trusty-irq.ko \
    trusty-ipc.ko \
    trusty-virtio.ko \
    sprd_shm.ko \
    sprd_soc_id.ko \
    unisoc-iommu.ko \
    pwm-sprd.ko \
    apsys-dvfs.ko \
    sprd-drm.ko \
    sprd-gsp.ko \
    ptn38003a-i2c.ko \
    chipone-tddi-icnl9916.ko

$(foreach ko,$(RECOVERY_KO_MODULES),$(eval $(call add-recovery-ko,$(ko))))

# Module dependency tables. These are plain text, so PRODUCT_COPY_FILES is fine.
include $(CLEAR_VARS)
LOCAL_MODULE        := modules_load_recovery
LOCAL_MODULE_STEM   := modules.load.recovery
LOCAL_MODULE_CLASS  := ETC
LOCAL_MODULE_PATH   := recovery/root/lib/modules
LOCAL_SRC_FILES     := modules_recovery/modules.load.recovery
LOCAL_MODULE_TAGS   := optional
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := modules_dep_recovery
LOCAL_MODULE_STEM   := modules.dep.recovery
LOCAL_MODULE_CLASS  := ETC
LOCAL_MODULE_PATH   := recovery/root/lib/modules
LOCAL_SRC_FILES     := modules_recovery/modules.dep.recovery
LOCAL_MODULE_TAGS   := optional
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := modules_softdep
LOCAL_MODULE_STEM   := modules.softdep
LOCAL_MODULE_CLASS  := ETC
LOCAL_MODULE_PATH   := recovery/root/lib/modules
LOCAL_SRC_FILES     := modules_recovery/modules.softdep
LOCAL_MODULE_TAGS   := optional
include $(BUILD_PREBUILT)

# ---------------------------------------------------------------------------
# No sub-makefiles are included here: all-makefiles-under would scan this
# directory's children only, and there are none. Keeping the file flat also
# avoids any chance of re-including Android.mk itself.
# ---------------------------------------------------------------------------
