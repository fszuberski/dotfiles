local function config(name)
    return function()
        require("plugins.configs." .. name)
    end
end

-- This is the existing plugin set expressed as lazy.nvim specs. Configuration
-- and load ordering will be migrated before these specs are activated.
return {
    { "folke/tokyonight.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, cmd = { "NvimTreeToggle", "NvimTreeFocus" }, config = config("nvimtree") },
    { "williamboman/mason.nvim", config = config("mason") },
    { "williamboman/mason-lspconfig.nvim", config = config("mason-lspconfig") },
    { "neovim/nvim-lspconfig", config = config("lspconfig") },
    { "crusj/hierarchy-tree-go.nvim", config = config("hierarchy-tree-go") },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = config("treesitter") },
    { "nvim-treesitter/nvim-treesitter-context", config = config("treesitter-context") },
    { "nvim-treesitter/playground" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
    { "nvim-telescope/telescope.nvim", tag = "0.1.x", dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-live-grep-args.nvim" }, config = config("telescope") },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "lukas-reineke/indent-blankline.nvim", config = config("blankline") },
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = config("lualine") },
    { "lewis6991/gitsigns.nvim", config = function()
        require("plugins.configs.gitsigns")
        require("scrollbar.handlers.gitsigns").setup()
    end },
    { "sindrets/diffview.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = config("diffview") },
    { "tpope/vim-fugitive" },
    { "rafamadriz/friendly-snippets", event = "InsertEnter" },
    { "L3MON4D3/LuaSnip", config = config("luasnip") },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "onsails/lspkind.nvim" },
    { "hrsh7th/nvim-cmp", config = config("cmp") },
    { "numToStr/Comment.nvim", config = config("comment") },
    { "windwp/nvim-autopairs", config = config("autopairs") },
    { "glepnir/lspsaga.nvim", commit = "b7b4777369b441341b2dcd45c738ea4167c11c9e", config = config("lspsaga") },
    { "j-hui/fidget.nvim", config = config("fidget") },
    { "petertriho/nvim-scrollbar", config = config("scrollbar") },
    { "catgoose/nvim-colorizer.lua", config = config("colorizer") },
    { "ThePrimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" }, config = config("harpoon") },
    { "antoinemadec/FixCursorHold.nvim" },
    { "nvim-neotest/neotest-go" },
    { "nvim-neotest/neotest", dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "antoinemadec/FixCursorHold.nvim", "nvim-neotest/neotest-go" }, config = config("neotest") },
    { "andythigpen/nvim-coverage", dependencies = { "nvim-lua/plenary.nvim" }, config = config("coverage") },
    { "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }, config = config("dapui") },
    { "theHamsta/nvim-dap-virtual-text", config = config("dapvt") },
    { "nvim-telescope/telescope-dap.nvim" },
    { "leoluz/nvim-dap-go", config = config("dapgo") },
}
