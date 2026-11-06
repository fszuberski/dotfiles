#!/bin/sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$script_dir/smoke.sh" "$script_dir/.." '+lua for _, name in ipairs({"cssls", "dockerls", "gopls", "html", "jsonls", "lua_ls", "marksman", "rust_analyzer", "solidity", "taplo", "terraformls", "ts_ls", "vimls", "yamlls", "sqls"}) do assert(vim.lsp.is_enabled(name), "LSP not enabled: " .. name); assert(vim.lsp.config[name] and vim.lsp.config[name].cmd, "LSP command not configured: " .. name) end; assert(vim.lsp.config.gopls.settings.gopls.staticcheck, "Go staticcheck missing"); vim.cmd("setfiletype lua"); assert(require("lazy.core.config").plugins["lazydev.nvim"]._.loaded, "lazydev did not load for Lua")'
