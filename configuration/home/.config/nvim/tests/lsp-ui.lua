dofile(vim.fn.stdpath("config") .. "/tests/lsp-attach.lua")
local commands = require("lspsaga.command").command_list()
for _, name in ipairs({ "finder", "rename", "code_action" }) do
    assert(vim.tbl_contains(commands, name), "Lspsaga command unavailable: " .. name)
end
assert(vim.fn.maparg("gy", "n"):find("Lspsaga finder", 1, true), "finder shortcut missing")
assert(vim.fn.maparg(" ca", "n"):find("Lspsaga code_action", 1, true), "code-action shortcut missing")
assert(vim.fn.maparg(" rn", "n"):find("Lspsaga rename", 1, true), "rename shortcut missing")
local mapping = vim.fn.maparg(" sh", "n", false, true)
assert(type(mapping.callback) == "function", "signature help shortcut missing")
local before = #vim.api.nvim_list_wins()
mapping.callback()
assert(vim.wait(5000, function() return #vim.api.nvim_list_wins() > before end, 50), "signature help did not open")
local current = vim.api.nvim_get_current_win()
for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win ~= current then vim.api.nvim_win_close(win, true) end
end
before = #vim.api.nvim_list_wins()
vim.cmd("Lspsaga finder")
assert(vim.wait(5000, function() return #vim.api.nvim_list_wins() > before end, 50), "LSP finder did not open")
