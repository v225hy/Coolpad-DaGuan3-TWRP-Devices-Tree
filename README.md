# TWRP Device Tree for Coolpad agn2262SG

This tree was generated from a stock Android 13
Unisoc `vendor_boot` image. Build it with the `twrp-12.1`
source branch and lunch target `twrp_agn2262SG-eng`.

The stock DTB, first-stage fstab, kernel modules, recovery init/ueventd files,
SELinux context files, and vendor runtime are retained under `recovery/root`
and copied to `vendor_ramdisk`.
The generated image is `vendor_boot.img`; keep the stock `boot.img` in place.

`prebuilt/sourcecode` contains the source overlay required for decryption.
Run `./patch.sh` from that directory before building; it backs up each replaced
source file to `original`. Run `./recovery.sh` to restore those originals.

This image carries a stock vendor SELinux policy. The SPRD builder compiles
`tools/patch_stock_sepolicy.c` and runs `tools/patch_stock_sepolicy.sh`
automatically. For a local build, compile the C helper against static
`libsepol`, set `SEPOLICY_PATCHER` to it, then run the shell helper; it rebuilds
`recovery/root/sepolicy` from `prebuilt/sepolicy.stock` with `init` and
`recovery` permissive.
This device uses the SC27XX input vibrator overlay.
This platform also includes the UMS9620/UMS9230 legacy DRM modeset overlay.
