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
    "folke/todo-comments.nvim", "folke/lazydev.nvim", "nvimdev/lspsaga.nvim",
}) do
    assert(found[repo], "missing plugin: " .. repo)
end
assert(not found["wbthomason/packer.nvim"], "Packer should not be in the lazy.nvim specs")
assert(vim.fn.filereadable(root .. "/lua/plugins/init.lua") == 0, "obsolete Packer entry point still exists")
for _, name in ipairs({ "lspconfig", "mason-lspconfig", "treesitter", "blankline" }) do
    assert(vim.fn.filereadable(root .. "/lua/plugins/configs/" .. name .. ".lua") == 0, "obsolete configuration remains: " .. name)
end
assert(not found["nvim-treesitter/playground"], "the old playground is incompatible with current Tree-sitter")
assert(vim.fn.exists(":InspectTree") == 2, "Neovim's built-in Tree-sitter inspector is unavailable")
assert(found["nvim-treesitter/nvim-treesitter"].build == ":TSUpdate")
assert(vim.tbl_contains(found["nvimdev/lspsaga.nvim"].dependencies, "nvim-treesitter/nvim-treesitter"), "Lspsaga Tree-sitter dependency missing")
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
for _, command in ipairs({ "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeRefresh" }) do
    assert(vim.tbl_contains(found["nvim-tree/nvim-tree.lua"].cmd, command), "missing lazy-load trigger: " .. command)
end
for _, dependency in ipairs({ "nvim-telescope/telescope-fzf-native.nvim", "nvim-telescope/telescope-live-grep-args.nvim", "nvim-telescope/telescope-dap.nvim" }) do
    assert(vim.tbl_contains(found["nvim-telescope/telescope.nvim"].dependencies, dependency), "missing Telescope dependency: " .. dependency)
end
assert(vim.tbl_contains(found["nvim-neotest/neotest"].dependencies, "nvim-neotest/nvim-nio"), "neotest requires nvim-nio")
for _, dependency in ipairs({ "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" }) do
    assert(vim.tbl_contains(found["theHamsta/nvim-dap-virtual-text"].dependencies or {}, dependency), "missing DAP virtual-text dependency: " .. dependency)
end
for _, dependency in ipairs({ "L3MON4D3/LuaSnip", "onsails/lspkind.nvim", "saadparwaiz1/cmp_luasnip", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lua", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline" }) do
    assert(vim.tbl_contains(found["hrsh7th/nvim-cmp"].dependencies or {}, dependency), "missing completion dependency: " .. dependency)
end
assert(vim.tbl_contains(found["L3MON4D3/LuaSnip"].dependencies or {}, "rafamadriz/friendly-snippets"), "LuaSnip snippets dependency missing")
assert(vim.tbl_contains(found["windwp/nvim-autopairs"].dependencies or {}, "hrsh7th/nvim-cmp"), "autopairs completion dependency missing")
local scrollbar = found["petertriho/nvim-scrollbar"]
assert(scrollbar.branch == "refactor/v2", "scrollbar must use the v2 branch")
assert(vim.tbl_contains(scrollbar.dependencies or {}, "lewis6991/gitsigns.nvim"), "scrollbar must load gitsigns first")
print("lazy.nvim plugin specification test passed")
