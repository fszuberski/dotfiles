#!/bin/sh
set -eu

exec python3 "../..//deployment/render-ai-configs.py" "$@"
