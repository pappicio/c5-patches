
#!/opt/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PYTHON="/usr/data/python-hf/bin/python3"

exec "$PYTHON" "$SCRIPT_DIR/c5-patches.py"
