local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local installed
package.preload["nvim-treesitter"] = function()
    return { install = function(parsers) installed = parsers end }
end
vim.fn.executable = function(name) return name == "tree-sitter" and 1 or 0 end
require("plugins.configs.treesitter-modern")
assert(installed and vim.tbl_contains(installed, "go"), "Go parser not requested")
assert(vim.tbl_contains(installed, "vimdoc") and not vim.tbl_contains(installed, "help"))
assert(not vim.tbl_contains(installed, "jsonc"), "jsonc is no longer a separate parser")
local autocmds = vim.api.nvim_get_autocmds({ group = "ConfigTreesitter", event = "FileType" })
assert(#autocmds == 1 and type(autocmds[1].callback) == "function", "highlighting autocmd missing")
print("modern Tree-sitter configuration test passed")
