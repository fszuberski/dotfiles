dofile(vim.fn.stdpath("config") .. "/tests/lsp-attach.lua")
local source = vim.api.nvim_get_current_buf()
vim.cmd("Lspsaga code_action")
assert(vim.wait(5000, function() return vim.api.nvim_get_current_buf() ~= source end, 50), "code-action picker did not open")
vim.api.nvim_feedkeys("1", "xt", false)
assert(vim.wait(5000, function()
    return vim.api.nvim_buf_get_lines(source, 0, 1, false)[1] == "package acted"
end, 50), "code action did not apply its edit")
