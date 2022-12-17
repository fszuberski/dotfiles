return require('packer').startup(function(use)
    use { 'wbthomason/packer.nvim' }

    use { 'folke/tokyonight.nvim' }

    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons',
        },
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        config = function()
            require "plugins.configs.nvimtree"
        end,
    }

    use {
        "williamboman/mason.nvim",
        config = function()
            require "plugins.configs.mason"
        end,
    }

    use {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require "plugins.configs.mason-lspconfig"
        end,
    }

    use {
        'neovim/nvim-lspconfig',
        config = function()
            require "plugins.configs.lspconfig"
        end,
    }

    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require "plugins.configs.treesitter"
        end,
    }

    use {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            require "plugins.configs.treesitter-context"
        end,
    }

    use { 'nvim-treesitter/playground' }


    -- telescope
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.x', -- https://github.com/nvim-telescope/telescope.nvim/pull/2150
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { "nvim-telescope/telescope-live-grep-args.nvim" },
        },
        -- cmd = "Telescope",
        -- module = "telescope",
        config = function()
            require "plugins.configs.telescope"
        end,
    }

    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
        cond = vim.fn.executable 'make' == 1,
    }

    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require "plugins.configs.blankline"
        end,
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require "plugins.configs.lualine"
        end,
    }

    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require "plugins.configs.gitsigns"
            require("scrollbar.handlers.gitsigns").setup()
        end,
    }


    use {
        'sindrets/diffview.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require "plugins.configs.diffview"
        end,
    }

    use {
        'TimUntersberger/neogit',
        requires = {
            'nvim-lua/plenary.nvim',
            'sindrets/diffview.nvim',
        },
        config = function()
            require "plugins.configs.neogit"
        end,
    }

    -- cmp
    use {
        "hrsh7th/nvim-cmp",
        after = "friendly-snippets",
        config = function()
            require "plugins.configs.cmp"
        end,
    }

    use {
        "rafamadriz/friendly-snippets",
        module = "cmp_nvim_lsp",
        event = "InsertEnter",
    }

    use {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        after = "nvim-cmp",
        config = function()
            require "plugins.configs.luasnip"
        end,
    }

    use {
        "saadparwaiz1/cmp_luasnip",
        after = "LuaSnip",
    }

    use {
        "hrsh7th/cmp-nvim-lua",
        after = "cmp_luasnip",
    }

    use {
        "hrsh7th/cmp-nvim-lsp",
        after = "cmp-nvim-lua",
    }

    use {
        "hrsh7th/cmp-buffer",
        after = "cmp-nvim-lsp",
    }

    use {
        "hrsh7th/cmp-path",
        after = "cmp-buffer",
    }

    use {
        "hrsh7th/cmp-cmdline",
        after = "cmp-buffer",
    }

    use {
        "onsails/lspkind.nvim"
    }

    use {
        "numToStr/Comment.nvim",
        config = function()
            require "plugins.configs.comment"
        end
    }

    use {
        "windwp/nvim-autopairs",
        after = "nvim-cmp",
        config = function()
            require "plugins.configs.autopairs"
        end,
    }
    use {
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            require "plugins.configs.lspsaga"
        end,
    }

    use {
        "j-hui/fidget.nvim",
        config = function()
            require "plugins.configs.fidget"
        end,
    }

    use {
        "petertriho/nvim-scrollbar",
        config = function()
            require "plugins.configs.scrollbar"
        end,
    }

    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require "plugins.configs.colorizer"
        end,
    }

    use {
        "ThePrimeagen/harpoon",
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require "plugins.configs.harpoon"
        end,
    }

    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            -- runners: https://github.com/nvim-neotest/neotest#supported-runners
            'nvim-neotest/neotest-go',
        },
        config = function()
            require "plugins.configs.neotest"
        end,
    }

    use {
        "andythigpen/nvim-coverage",
        requires = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require "plugins.configs.coverage"
        end,
    }

    -- dap
    use {
        'mfussenegger/nvim-dap'
    }

    use {
        "rcarriga/nvim-dap-ui",
        requires = {
            "mfussenegger/nvim-dap"
        },
        config = function()
            require "plugins.configs.dapui"
        end,
    }

    use {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
            require "plugins.configs.dapvt"
        end
    }

    use {
        "nvim-telescope/telescope-dap.nvim"
    }

    use {
        "leoluz/nvim-dap-go",
        config = function()
            require "plugins.configs.dapgo"
        end,
    }

end)
