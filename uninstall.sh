
#!/opt/bin/sh
set -eu

PLUGIN_DIR="${OC_PLUGIN_DIR:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}"
PLUGIN_PARENT="$(dirname "$PLUGIN_DIR")"
OPENCREATOR_ROOT="$(dirname "$PLUGIN_PARENT")"

PYTHON="/usr/data/python-hf/bin/python3"
SOURCE="$PLUGIN_DIR/scripts/c5-patches.py"
MANAGER="$OPENCREATOR_ROOT/scripts/c5-patches.py"

echo "[C5 Patches] Removing plugin integrations..."

if [ ! -f "$SOURCE" ]; then
    echo "[C5 Patches] ERROR: Uninstall manager not found."
    exit 1
fi

if [ ! -x "$PYTHON" ]; then
    PYTHON="$(command -v python3 || true)"
fi

if [ -z "$PYTHON" ]; then
    echo "[C5 Patches] ERROR: Python interpreter not found."
    exit 1
fi

# Remove integrations managed by the original patch manager.
"$PYTHON" "$SOURCE" --uninstall

# Remove the legacy shared manager link, if it belongs to this plugin.
if [ -L "$MANAGER" ] &&
   [ "$(readlink -f "$MANAGER" 2>/dev/null || true)" = "$(readlink -f "$SOURCE")" ]; then
    rm -f "$MANAGER"
    echo "[C5 Patches] Removed legacy manager link."
fi

echo "[C5 Patches] Uninstallation completed."
