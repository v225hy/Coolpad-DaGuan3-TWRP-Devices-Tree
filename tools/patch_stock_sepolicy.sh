#!/bin/sh
# Rebuild recovery SELinux policy from the stock vendor_boot copy.
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEVICE_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
POLICY_TOOL=${SEPOLICY_PATCHER:-${MAGISKPOLICY:-sprd-sepolicy-patcher}}
STOCK_POLICY="$DEVICE_DIR/prebuilt/sepolicy.stock"
OUTPUT_POLICY="$DEVICE_DIR/recovery/root/sepolicy"
TEMP_POLICY=$(mktemp "${OUTPUT_POLICY}.tmp.XXXXXX")

cleanup() {
    rm -f "$TEMP_POLICY"
}
trap cleanup EXIT HUP INT TERM

if ! command -v "$POLICY_TOOL" >/dev/null 2>&1; then
    echo "SELinux policy patcher was not found; set SEPOLICY_PATCHER=/path/to/patcher" >&2
    exit 127
fi
test -f "$STOCK_POLICY"

"$POLICY_TOOL" "$STOCK_POLICY" "$TEMP_POLICY" init recovery

# A no-op patch would leave recovery with the restrictive factory policy.
if cmp -s "$STOCK_POLICY" "$TEMP_POLICY"; then
    echo "SELinux policy patcher produced an unchanged policy" >&2
    exit 1
fi

mv -f "$TEMP_POLICY" "$OUTPUT_POLICY"
trap - EXIT
echo "Patched $OUTPUT_POLICY from stock policy"