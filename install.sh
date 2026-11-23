#!/opt/bin/sh
set -eu

PLUGIN_DIR="${OC_PLUGIN_DIR:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}"

echo "[C5 Patches] Checking native plugin modules..."

for MODULE in \
    c5_pickup_patch.py \
    afc_restore_patch.py \
    kalico_runtime_patch.py
do
    if [ ! -f "$PLUGIN_DIR/scripts/$MODULE" ]; then
        echo "[C5 Patches] ERROR: Missing module: $MODULE"
        exit 1
    fi
done

echo "[C5 Patches] All modules verified."
echo "[C5 Patches] Native installation completed."