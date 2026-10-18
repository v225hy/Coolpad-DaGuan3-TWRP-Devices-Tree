#
# TWRP device config for Coolpad CP3NV1 (酷派大观3)
# SoC: Unisoc UMS9620 (qogirn6pro) / board: agn2262SG
# Extracted from: vendor_boot_a (dtb) + dtbo_a (overlay idx 0) + runtime /proc/device-tree
#

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RECOVERY := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RECOVERY := cortex-a53

TARGET_USES_64_BIT_BINDER := true
TARGET_SUPPORTS_32_BIT_APPS := true
TARGET_SUPPORTS_64_BIT_APPS := true

# Platform
TARGET_BOARD_PLATFORM := ums9620
TARGET_BOOTLOADER_BOARD_NAME := agn2262SG
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# Kernel
# The kernel lives in boot_a (Android v4, 36.60 MB kernel, 1.40 MB ramdisk),
# NOT in vendor_boot. Stock vendor_boot_a is VNDRBOOT v4 with a single
# PLATFORM ramdisk fragment and carries no kernel of its own. So we do not
# ship a kernel inside vendor_boot: TARGET_NO_KERNEL keeps it out and
# TARGET_PREBUILT_KERNEL stays unset.
TARGET_NO_KERNEL := true
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64

# Values below are measured from stock vendor_boot_a (unpack_bootimg output):
#   page_size=4096  kernel_addr=0x00008000  ramdisk_addr=0x05400000
#   tags_addr=0x00000100  dtb_addr=0x01f00000  header_size=2128
#   cmdline="console=ttyS1,115200n8 buildvariant=user"
BOARD_BOOT_HEADER_VERSION := 4
BOARD_PAGE_SIZE := 4096
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x05400000
BOARD_TAGS_OFFSET := 0x00000100
BOARD_DTB_OFFSET := 0x01f00000
BOARD_HEADER_SIZE := 2128
BOARD_VENDOR_CMDLINE := console=ttyS1,115200n8 buildvariant=user

# ---------------------------------------------------------------------------
# DTB
#
# build/make/core/Makefile:776-783
#   ifdef BOARD_INCLUDE_DTB_IN_BOOTIMG
#   INSTALLED_DTBIMAGE_TARGET := $(PRODUCT_OUT)/dtb.img
#   ifdef BOARD_PREBUILT_DTBIMAGE_DIR
#   $(INSTALLED_DTBIMAGE_TARGET) : $(sort $(wildcard $(BOARD_PREBUILT_DTBIMAGE_DIR)/*.dtb))
#           cat $^ > $@
#   endif
#   endif
#
# Note `ifdef` tests whether the variable is DEFINED, not whether it is true.
# Setting BOARD_INCLUDE_DTB_IN_BOOTIMG := false still defines it, so
# INSTALLED_DTBIMAGE_TARGET becomes $(PRODUCT_OUT)/dtb.img and
# vendor_boot.img depends on it unconditionally (Makefile:1174) -- but with no
# BOARD_PREBUILT_DTBIMAGE_DIR the recipe above is never emitted, so ninja dies:
#   FAILED: ninja: 'out/target/product/agn2262SG/dtb.img', needed by
#   'out/target/product/agn2262SG/vendor_boot.img', missing and no known rule
#
# Fix: point BOARD_PREBUILT_DTBIMAGE_DIR at a directory of *.dtb files. The rule
# then simply `cat`s them into out/target/product/agn2262SG/dtb.img, which is
# exactly the single concatenated DTB blob our stock vendor_boot contains
# (dtb_size=159531, matching prebuilt/dtb byte for byte).
#
# TARGET_PREBUILT_DTB is intentionally NOT set: the AOSP makefile logic above
# never consults it. Letting INTERNAL_VENDOR_BOOTIMAGE_ARGS emit --dtb
# (Makefile:1112) is the only path that reaches mkbootimg, and doing it twice
# via BOARD_MKBOOTIMG_ARGS would duplicate the argument.
#
# Side effects are contained: Makefile:887 guards the boot.img include with
# `ifndef BUILDING_VENDOR_BOOT_IMAGE`, and Makefile:2193 guards recovery the
# same way, so setting this true only affects the vendor_boot image we build.
BOARD_PREBUILT_DTBIMAGE_DIR := device/Coolpad/agn2262SG/prebuilt/dtb_files
TARGET_PREBUILT_DTBO := device/Coolpad/agn2262SG/prebuilt/dtbo.img
BOARD_PREBUILT_DTBOIMAGE := device/Coolpad/agn2262SG/prebuilt/dtbo.img
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_KERNEL_IMAGE_NAME := Image

BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_PAGE_SIZE)
BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --vendor_cmdline "$(BOARD_VENDOR_CMDLINE)"

# Stock vendor ramdisk uses legacy LZ4
BOARD_RAMDISK_USE_LZ4 := true

# A/B + dynamic partitions + vendor_boot
AB_OTA_UPDATER := true
# Required whenever AB_OTA_UPDATER is true (build/make/core/Makefile:4792).
# Boot-critical A/B partitions, plus every logical partition living in `super`.
# Matches partition_list.xml: boot_a/b, vendor_boot_a/b, dtbo_a/b, vbmeta_*,
# and the super group members.
AB_OTA_PARTITIONS += \
    boot \
    vendor_boot \
    dtbo \
    vbmeta \
    vbmeta_system \
    vbmeta_system_ext \
    vbmeta_vendor \
    vbmeta_product \
    vbmeta_odm \
    odm \
    product \
    system \
    system_ext \
    vendor \
    vendor_dlkm
TARGET_USES_DYNAMIC_PARTITIONS := true
TARGET_USES_VENDOR_BOOT := true
BOARD_USES_VENDOR_BOOTIMAGE := true
# Recovery lives in vendor_boot on this device: there is no standalone
# recovery partition. Without this, `make vendorbootimage` produces a
# vendor_boot without TWRP inside.
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true
# Does NOT set BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT: that would add a
# separate VENDOR_RAMDISK_TYPE_RECOVERY fragment, but the stock vendor_boot has
# exactly one PLATFORM (0x1) fragment and no RECOVERY entry.
# Also does NOT set TARGET_NO_RECOVERY - TWRP still needs the recovery ramdisk
# built; BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT relocates it afterwards.
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_ODM := odm
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_PRODUCT := product
# NOTE: no TARGET_COPY_OUT_ODM_DLKM on this device - it has no odm_dlkm
# partition (see partition_list.xml; all logical partitions live in `super`).
# Declaring it forces board_config.mk to require BOARD_ODM_DLKMIMAGE_*. 
BOARD_SUPER_PARTITION_SIZE := 8589934592
BOARD_SUPER_PARTITION_GROUPS := group_a
BOARD_GROUP_A_PARTITION_LIST := system system_ext vendor product odm vendor_dlkm
# group must be strictly smaller than super: LP metadata lives inside super.
BOARD_GROUP_A_SIZE := 8588886016
BOARD_USES_METADATA_PARTITION := true

# Filesystem
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
TARGET_USES_MKE2FS := true

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := "ABGR_8888"
TARGET_RECOVERY_FSTAB := device/Coolpad/agn2262SG/recovery.fstab
# NOTE: deliberately NOT setting TARGET_RECOVERY_DEVICE_DIRS to device/Coolpad/agn2262SG:
# that copies the whole device tree (38 MB kernel + 42 MB modules) into the
# recovery ramdisk, which cannot fit the 100 MB vendor_boot. Anything that must
# land in the ramdisk goes under recovery/root/ instead.
TARGET_RECOVERY_INITRC := device/Coolpad/agn2262SG/init.recovery.agn2262SG.rc
TARGET_USES_LOGD := true
TARGET_RECOVERY_WIPE := device/Coolpad/agn2262SG/recovery/root/system/etc/recovery.wipe
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_SUPPRESS_EMMC_WIPE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_USE_TOOLBOX := true
TW_INCLUDE_NTFS_3G := true
TW_INCLUDE_FUSE_EXFAT := true
TW_INCLUDE_FUSE_NTFS := true
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE := true
TW_USE_FSCRYPT_POLICY := 2
TW_EXCLUDE_APEX := true

# TWRP
TW_THEME := portrait_hdpi
DEVICE_RESOLUTION := 1080x2408
# Backlight — measured on the live device:
#   /sys/class/backlight/sprd_backlight/{brightness,max_brightness}
#   max_brightness = 255
# The node is NOT called sprd-qogirn6pro-backlight; 880 is the pwm period scale
# inside the dts, not the sysfs ceiling, so it must not be used here.
TW_BRIGHTNESS_PATH := "/sys/class/backlight/sprd_backlight/brightness"
TW_MAX_BRIGHTNESS_PATH := "/sys/class/backlight/sprd_backlight/max_brightness"
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 255
TW_NO_SCREEN_BLANK := false
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_EXCLUDE_TWRPAPP := true
TW_EXTRA_LANGUAGES := true
TW_NO_LEGACY_PROPS := true
TW_HAS_EDL_MODE := false

# Display rotate / panel is portrait native
TW_ROTATION := 0

# Partitions layout (UFS /dev/block/sda, GPT)
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 104857600
BOARD_DTBOIMAGE_PARTITION_SIZE := 8388608
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_METADATAIMAGE_PARTITION_SIZE := 16777216
BOARD_CACHEIMAGE_PARTITION_SIZE := 104857600

# TWRP storage
TW_HAS_MTP := true
TW_MTP_DEVICE := /dev/mtp_usb
TW_EXTERNAL_STORAGE_PATH := "/external_sd"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"
TW_INTERNAL_STORAGE_PATH := "/data/media/0"
TW_INTERNAL_STORAGE_MOUNT_POINT := "data"
TW_FLASH_FROM_STORAGE := true

# SELinux
# SELinux
# No device-specific policy for now: rely on the stock recovery policy and run
# permissive during bring-up (same approach as the working P720S20 tree).
# Note: git does not track empty directories, so BOARD_SEPOLICY_DIRS pointing
# at an empty sepolicy/ would resolve to a non-existent path after clone.
TARGET_RECOVERY_SELINUX := permissive
TW_HAS_SELINUX := true
