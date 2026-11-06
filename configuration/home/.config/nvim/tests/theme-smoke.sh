#!/bin/sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$script_dir/smoke.sh" "$script_dir/.." '+lua assert(_G.Colors == nil, "theme palette leaked into globals"); local colors = require("core.color"); assert(type(colors) == "table" and colors.green and colors.orange, "theme palette not exported"); assert(vim.api.nvim_get_hl(0, {name = "CmpBorder"}).fg, "completion border highlight missing")'
