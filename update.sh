#!/bin/sh
PLUGIN="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
exec "$PLUGIN/install.sh"
