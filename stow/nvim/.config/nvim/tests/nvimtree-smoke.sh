#!/bin/sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$script_dir/smoke.sh" "$script_dir/.." '+lua vim.cmd.NvimTreeToggle(); assert(require("nvim-tree.view").is_visible(), "file tree did not open")'
