#!/bin/sh
# Usage: sh tests/smoke.sh [configuration-directory]
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_dir=$(CDPATH= cd -- "${1:-$script_dir/..}" && pwd)
test_dir=$(mktemp -d "${TMPDIR:-/tmp}/nvim-smoke.XXXXXXXX")
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM
mkdir -p "$test_dir/config" "$test_dir/data" "$test_dir/state" "$test_dir/cache"
ln -s "$config_dir" "$test_dir/config/nvim"

export XDG_CONFIG_HOME="$test_dir/config"
export XDG_DATA_HOME="$test_dir/data"
export XDG_STATE_HOME="$test_dir/state"
export XDG_CACHE_HOME="$test_dir/cache"
unset NVIM_APPNAME NVIM_INIT

if nvim --headless -i NONE '+lua if vim.v.errmsg ~= "" then vim.cmd("cquit 1") end' '+qa!' >"$test_dir/output" 2>&1; then
    if [ ! -s "$test_dir/output" ]; then
        echo 'Neovim startup smoke test passed'
        exit 0
    fi
fi
cat "$test_dir/output" >&2
echo 'Neovim startup smoke test failed' >&2
exit 1
