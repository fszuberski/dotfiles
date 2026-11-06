#!/bin/sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$script_dir/smoke.sh" "$script_dir/.." '+lua assert(require("tokyonight.config").options.style == "night", "Tokyo Night must use the night style"); assert(_G.Colors == nil, "theme palette leaked into globals"); local colors = require("core.color"); assert(type(colors) == "table" and colors.green and colors.orange, "theme palette not exported"); assert(vim.api.nvim_get_hl(0, {name = "Normal"}).bg == tonumber(colors.bg:sub(2), 16), "editor and exported palette differ"); assert(vim.api.nvim_get_hl(0, {name = "CmpBorder"}).fg, "completion border highlight missing")'
