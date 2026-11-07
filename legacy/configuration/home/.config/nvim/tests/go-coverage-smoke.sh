#!/bin/sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$script_dir/smoke.sh" "$script_dir/.." "+luafile $script_dir/go-coverage.lua" '+lua require("nvim-treesitter").install({"go"}):wait(180000)'
