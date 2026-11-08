#!/bin/sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$script_dir/smoke.sh" "$script_dir/.." '+lua for _, name in ipairs({"fzf", "live_grep_args", "dap"}) do assert(package.loaded["telescope._extensions." .. name], "Telescope extension not loaded: " .. name) end; require("telescope.builtin").find_files(); assert(vim.bo.filetype == "TelescopePrompt", "file picker did not open")'
