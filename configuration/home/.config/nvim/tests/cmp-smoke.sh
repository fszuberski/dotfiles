#!/bin/sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$script_dir/smoke.sh" "$script_dir/.." '+lua local cmp = require("cmp"); assert(rawget(require("cmp.utils.window"), "info_") == nil, "completion window internals were patched"); local config = cmp.get_config(); assert(config.mapping["<Tab>"] and config.mapping["<CR>"], "completion mappings missing"); assert(vim.tbl_contains(vim.tbl_map(function(source) return source.name end, config.sources), "nvim_lsp"), "LSP completion source missing")'
