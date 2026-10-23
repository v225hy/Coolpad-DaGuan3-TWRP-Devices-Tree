#!/system/bin/sh
D=/cache
mkdir -p "$D" 2>/dev/null
[ -w "$D" ] || D=/data/local/tmp
mkdir -p "$D/dg3" 2>/dev/null || exit 0
O="$D/dg3"
dmesg > "$O/dmesg.txt" 2>&1
cat /proc/mounts > "$O/mounts.txt" 2>&1
cat /proc/cmdline > "$O/cmdline.txt" 2>&1
ls -l /dev/block/by-name > "$O/by-name.txt" 2>&1
ls -l /dev/dri /sys/class/drm /sys/class/graphics > "$O/drm.txt" 2>&1
[ -f /tmp/recovery.log ] && cp /tmp/recovery.log "$O/" 2>/dev/null
echo "stage=$1 $(date)" > "$O/stamp.txt"
sync
