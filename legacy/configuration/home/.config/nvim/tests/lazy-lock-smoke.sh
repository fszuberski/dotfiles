#!/bin/sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$script_dir/smoke.sh" "$script_dir/.." '+lua local lock = vim.json.decode(table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/lazy-lock.json"), "\n")); local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"; local head = vim.fn.systemlist({"git", "-C", path, "rev-parse", "HEAD"})[1]; assert(head == lock["lazy.nvim"].commit, "lazy.nvim is not at its locked revision")'
