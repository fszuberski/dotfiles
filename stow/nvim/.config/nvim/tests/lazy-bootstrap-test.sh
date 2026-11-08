#!/bin/sh
set -eu

test_dir=$(mktemp -d "${TMPDIR:-/tmp}/nvim-lazy-test.XXXXXXXX")
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$script_dir/.."
export XDG_DATA_HOME="$test_dir/data"
export XDG_CONFIG_HOME="$test_dir/config"
export XDG_STATE_HOME="$test_dir/state"
export XDG_CACHE_HOME="$test_dir/cache"
unset NVIM_APPNAME NVIM_INIT
nvim --headless -u NONE -i NONE -l tests/lazy-bootstrap-test.lua
