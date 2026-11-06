local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local calls = {}
vim.lsp.buf.format = function(opts) table.insert(calls, opts) end
require("core.autocmds")
package.loaded["core.autocmds"] = nil
require("core.autocmds")

local go = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_name(go, "format-test.go")
vim.api.nvim_exec_autocmds("BufWritePre", { buffer = go })
assert(#calls == 1, "Go formatting should run once after reloading the module")
assert(calls[1].bufnr == go and calls[1].async == false, "formatting must target the saved buffer synchronously")

local text = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_name(text, "format-test.txt")
vim.api.nvim_exec_autocmds("BufWritePre", { buffer = text })
assert(#calls == 1, "non-Go files must not trigger Go formatting")
print("Go format-on-save test passed")
