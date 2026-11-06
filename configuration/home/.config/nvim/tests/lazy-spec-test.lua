local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path
local specs = require("plugins.lazy-spec")
local found = {}
for _, spec in ipairs(specs) do
    assert(type(spec[1]) == "string", "each plugin needs a repository")
    assert(not found[spec[1]], "duplicate plugin: " .. spec[1])
    found[spec[1]] = spec
end
for _, repo in ipairs({
    "folke/tokyonight.nvim", "nvim-tree/nvim-tree.lua", "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp", "ThePrimeagen/harpoon", "nvim-neotest/neotest",
    "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui", "catgoose/nvim-colorizer.lua",
    "folke/todo-comments.nvim", "folke/lazydev.nvim",
}) do
    assert(found[repo], "missing plugin: " .. repo)
end
assert(not found["wbthomason/packer.nvim"], "Packer should not be in the lazy.nvim specs")
assert(not found["nvim-treesitter/playground"], "the old playground is incompatible with current Tree-sitter")
assert(vim.fn.exists(":InspectTree") == 2, "Neovim's built-in Tree-sitter inspector is unavailable")
assert(found["nvim-treesitter/nvim-treesitter"].build == ":TSUpdate")
assert(found["glepnir/lspsaga.nvim"].commit == "b7b4777369b441341b2dcd45c738ea4167c11c9e")
local theme = found["folke/tokyonight.nvim"]
assert(theme.priority == 1000 and type(theme.config) == "function", "theme must load before dependent plugins")
local theme_loaded = false
package.preload["core.color"] = function() theme_loaded = true end
theme.config()
assert(theme_loaded, "theme configuration did not load")
local todo = found["folke/todo-comments.nvim"]
assert(vim.tbl_contains(todo.dependencies, "nvim-lua/plenary.nvim"), "todo-comments needs plenary")
local todo_setup = false
package.preload["todo-comments"] = function() return { setup = function() todo_setup = true end } end
todo.config()
assert(todo_setup, "todo-comments was not configured")
local lazydev = found["folke/lazydev.nvim"]
assert(lazydev.ft == "lua" and type(lazydev.opts) == "table", "lazydev must be configured for Lua files")
print("lazy.nvim plugin specification test passed")
