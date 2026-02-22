#!/bin/bash
set -e

OPENCLAW_HOME="$HOME/.openclaw"

# Ensure the directory exists and has the correct permissions
mkdir -p "$OPENCLAW_HOME"
if [ "$(id -u)" -eq 0 ]; then
    chown -R node:node "$OPENCLAW_HOME"
fi

exec gosu node openclaw gateway run \
    --allow-unconfigured \
    --verbose