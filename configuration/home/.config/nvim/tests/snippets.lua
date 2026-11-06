local keys = vim.api.nvim_replace_termcodes("i(<Esc>", true, false, true)
vim.api.nvim_feedkeys(keys, "xt", false)
assert(vim.api.nvim_get_current_line() == "()", "autopairs did not insert the closing parenthesis")

vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
vim.api.nvim_win_set_cursor(0, { 1, 0 })
require("luasnip").lsp_expand("hello ${1:world}")
assert(vim.api.nvim_get_current_line() == "hello world", "LuaSnip did not expand the snippet")
