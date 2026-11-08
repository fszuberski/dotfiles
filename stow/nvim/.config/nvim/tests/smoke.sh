#!/bin/sh
# Usage: sh tests/smoke.sh [configuration-directory]
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_dir=$(CDPATH= cd -- "${1:-$script_dir/..}" && pwd)
test_dir=$(mktemp -d "${TMPDIR:-/tmp}/nvim-smoke.XXXXXXXX")
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM
mkdir -p "$test_dir/config/nvim" "$test_dir/data" "$test_dir/state" "$test_dir/cache"
cp -R "$config_dir/." "$test_dir/config/nvim/"

export XDG_CONFIG_HOME="$test_dir/config"
export XDG_DATA_HOME="$test_dir/data"
export XDG_STATE_HOME="$test_dir/state"
export XDG_CACHE_HOME="$test_dir/cache"
unset NVIM_APPNAME NVIM_INIT

if ! nvim --headless -i NONE "${3:-+lua do end}" '+lua if vim.v.errmsg ~= "" then vim.cmd("cquit 1") end' '+qa!' >"$test_dir/bootstrap-output" 2>&1; then
    cat "$test_dir/bootstrap-output" >&2
    echo 'Neovim bootstrap smoke test failed' >&2
    exit 1
fi
if grep -Eiq '(^|[[:space:]])(error in|failed to|fatal:|stack traceback:)' "$test_dir/bootstrap-output"; then
    cat "$test_dir/bootstrap-output" >&2
    echo 'Neovim bootstrap smoke test failed' >&2
    exit 1
fi

if nvim --headless -i NONE "${2:-+lua do end}" '+lua if vim.v.errmsg ~= "" then io.stderr:write(vim.v.errmsg .. "\n"); vim.cmd("cquit 1") end' '+qa!' >"$test_dir/output" 2>&1; then
    if [ ! -s "$test_dir/output" ]; then
        echo 'Neovim startup smoke test passed'
        exit 0
    fi
fi
cat "$test_dir/output" >&2
echo 'Neovim startup smoke test failed' >&2
exit 1
