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
}) do
    assert(found[repo], "missing plugin: " .. repo)
end
assert(not found["wbthomason/packer.nvim"], "Packer should not be in the lazy.nvim specs")
assert(not found["nvim-treesitter/playground"], "the old playground is incompatible with current Tree-sitter")
assert(vim.fn.exists(":InspectTree") == 2, "Neovim's built-in Tree-sitter inspector is unavailable")
assert(found["nvim-treesitter/nvim-treesitter"].build == ":TSUpdate")
assert(found["glepnir/lspsaga.nvim"].commit == "b7b4777369b441341b2dcd45c738ea4167c11c9e")
print("lazy.nvim plugin specification test passed")
