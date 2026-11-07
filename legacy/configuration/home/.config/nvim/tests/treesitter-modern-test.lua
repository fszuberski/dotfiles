local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local installed, complete, started
package.preload["nvim-treesitter"] = function()
    return { get_installed = function() return {} end, install = function(parsers)
        installed = parsers
        return { await = function(_, callback) complete = callback end }
    end }
end
vim.fn.executable = function(name) return name == "tree-sitter" and 1 or 0 end
vim.bo.filetype = "go"
local available = false
vim.api.nvim_get_runtime_file = function() return available and { "parser/go.so" } or {} end
vim.treesitter.start = function(buf, lang) started = { buf = buf, lang = lang } end
require("plugins.configs.treesitter-modern")
assert(vim.fn.maparg("<A-v>", "n") == "van", "normal-mode node selection mapping missing")
assert(vim.fn.maparg("<A-v>", "x") == "an", "visual-mode node expansion mapping missing")
assert(vim.fn.maparg("<A-BS>", "x") == "in", "visual-mode node shrink mapping missing")
assert(not installed, "empty startup must not install parsers")
local autocmds = vim.api.nvim_get_autocmds({ group = "ConfigTreesitter", event = "FileType" })
assert(#autocmds == 1 and type(autocmds[1].callback) == "function", "highlighting autocmd missing")
autocmds[1].callback({ buf = vim.api.nvim_get_current_buf() })
assert(installed and vim.tbl_contains(installed, "go"), "Go parser not requested")
available = true
complete()
assert(started and started.lang == "go", "highlighting did not start after installation")
installed = nil
autocmds[1].callback({ buf = vim.api.nvim_get_current_buf() })
assert(installed and vim.tbl_contains(installed, "go"), "bundled parser must not prevent curated queries from being installed")
print("modern Tree-sitter configuration test passed")
