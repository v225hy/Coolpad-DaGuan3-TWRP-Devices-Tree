#!/system/bin/sh
# Persist recovery diagnostics onto the cache partition so they survive a
# reboot and can be read later from a rooted Android system:
#     su -c 'mount /dev/block/by-name/cache /mnt/c && ls /mnt/c/dg3'
#
# Everything here runs as root from init. Keep it free of anything that can
# block: a hung recovery has no other way to report what it was doing.

D=""
# TWRP may already have mounted cache at /cache.
if [ -d /cache ] && [ -w /cache ]; then
    D=/cache
else
    for cand in /mnt/dg3cache /mnt/dg3meta; do
        mkdir -p "$cand" 2>/dev/null || continue
        case "$cand" in
            *cache) part=/dev/block/by-name/cache ;;
            *meta)  part=/dev/block/by-name/metadata ;;
        esac
        mount -t ext4 -o rw "$part" "$cand" 2>/dev/null
        if [ -w "$cand" ]; then D=$cand; break; fi
    done
fi

[ -n "$D" ] || exit 1

OUT=$D/dg3
mkdir -p "$OUT" 2>/dev/null || exit 1

dmesg                > "$OUT/dmesg.txt"      2>&1
cat /proc/mounts     > "$OUT/mounts.txt"     2>&1
cat /proc/cmdline    > "$OUT/cmdline.txt"    2>&1
cat /proc/partitions > "$OUT/partitions.txt" 2>&1
ls -la /dev/block/by-name > "$OUT/by-name.txt" 2>&1
ls -la /dev/dri            > "$OUT/dri.txt"     2>&1
ls -la /sys/class/drm      > "$OUT/sys-drm.txt" 2>&1
ls -la /sys/class/graphics > "$OUT/graphics.txt" 2>&1
ls -la /sys/class/leds     > "$OUT/leds.txt"    2>&1
[ -f /tmp/recovery.log ] && cp /tmp/recovery.log "$OUT/recovery.log" 2>/dev/null

echo "stage=$1 at $(date)" > "$OUT/stamp.txt"
sync
