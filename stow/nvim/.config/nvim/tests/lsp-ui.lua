dofile(vim.fn.stdpath("config") .. "/tests/lsp-attach.lua")
local commands = require("lspsaga.command").command_list()
for _, name in ipairs({ "finder", "rename", "code_action" }) do
    assert(vim.tbl_contains(commands, name), "Lspsaga command unavailable: " .. name)
end
assert(vim.fn.maparg("gy", "n"):find("Lspsaga finder", 1, true), "finder shortcut missing")
assert(vim.fn.maparg(" ca", "n"):find("Lspsaga code_action", 1, true), "code-action shortcut missing")
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
local source = vim.api.nvim_get_current_win()
vim.cmd("Lspsaga finder")
assert(vim.wait(5000, function() return #vim.api.nvim_list_wins() > before end, 50), "LSP finder did not open")
for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win ~= source then vim.api.nvim_win_close(win, true) end
end
vim.api.nvim_set_current_win(source)
before = #vim.api.nvim_list_wins()
vim.cmd("Lspsaga code_action")
assert(vim.wait(5000, function() return #vim.api.nvim_list_wins() > before end, 50), "LSP code-action interface did not open")
for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win ~= source then vim.api.nvim_win_close(win, true) end
end
vim.api.nvim_set_current_win(source)
local rename = vim.fn.maparg(" rn", "n", false, true)
assert(type(rename.callback) == "function", "native LSP rename mapping missing")
local input = vim.ui.input
vim.ui.input = function(_, callback) callback("renamed") end
rename.callback()
vim.ui.input = input
assert(vim.wait(5000, function()
    return vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == "package renamed"
end, 50), "LSP rename edit was not applied")
