#!/bin/sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$script_dir/smoke.sh" "$script_dir/.." '+lua dofile(vim.fn.stdpath("config") .. "/tests/go-coverage-mappings.lua"); local adapters = require("neotest.config").adapters; assert(#adapters > 0 and adapters[1].name == "neotest-golang", "Go test adapter not configured"); assert(require("dap").adapters.go, "Go DAP adapter not configured"); require("dapui").open(); assert(vim.fn.bufnr("DAP Scopes") ~= -1, "DAP UI did not open")'
