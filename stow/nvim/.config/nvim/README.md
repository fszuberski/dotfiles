# Neovim configuration

Requires a recent Neovim (tested with 0.12), Git, and network access for the first startup. [lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself and installs plugins using `lazy-lock.json`. Native extensions and Tree-sitter parsers require a C compiler and `make`; on-demand parser installation also requires the `tree-sitter` CLI. Mason installs configured language servers; their installers may require additional runtimes. Go workflows require Go, and Go debugging requires `dlv` on `PATH`.

## Plugins

### Editor and appearance

- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) — color scheme.
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) — file icons.
- [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) — file explorer.
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) — indentation guides.
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) — status line.
- [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar) — scrollbar with Git and diagnostic markers (v2 branch).
- [nvim-colorizer.lua](https://github.com/catgoose/nvim-colorizer.lua) — color previews.
- [Comment.nvim](https://github.com/numToStr/Comment.nvim) — comment toggling.
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) — automatic paired delimiters.
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) — highlights and searches TODO comments.
- [vim-repeat](https://github.com/tpope/vim-repeat) — repeat support for plugin actions.
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) — shared Lua utilities.

### Languages and navigation

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) — language server configurations.
- [mason.nvim](https://github.com/mason-org/mason.nvim) — language tooling installer.
- [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) — Mason integration for language servers.
- [lazydev.nvim](https://github.com/folke/lazydev.nvim) — Neovim Lua development support.
- [lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim) — LSP finder and code-action UI.
- [fidget.nvim](https://github.com/j-hui/fidget.nvim) — LSP progress display.
- [hierarchy-tree-go.nvim](https://github.com/crusj/hierarchy-tree-go.nvim) — Go call hierarchy navigation.
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) — parsers, queries, and syntax highlighting.
- [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) — current syntax context.
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) — fuzzy search and pickers.
- [telescope-live-grep-args.nvim](https://github.com/nvim-telescope/telescope-live-grep-args.nvim) — live grep with arguments.
- [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) — native fuzzy sorter.
- [telescope-dap.nvim](https://github.com/nvim-telescope/telescope-dap.nvim) — debugger pickers.
- [harpoon](https://github.com/ThePrimeagen/harpoon) — quick access to marked files.

### Completion and snippets

- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) — completion engine.
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) — snippet engine.
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) — community snippets.
- [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) — snippet completion source.
- [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) — LSP completion source and capabilities.
- [cmp-nvim-lua](https://github.com/hrsh7th/cmp-nvim-lua) — Neovim Lua API completion.
- [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) — buffer completion source.
- [cmp-path](https://github.com/hrsh7th/cmp-path) — path completion source.
- [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) — command-line completion source.
- [lspkind.nvim](https://github.com/onsails/lspkind.nvim) — completion icons.

### Git, testing, and debugging

- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) — Git signs and hunk actions.
- [diffview.nvim](https://github.com/sindrets/diffview.nvim) — diff and history views.
- [vim-fugitive](https://github.com/tpope/vim-fugitive) — Git commands in Neovim.
- [neotest](https://github.com/nvim-neotest/neotest) — test discovery and execution.
- [neotest-golang](https://github.com/fredrikaverpil/neotest-golang) — Go test adapter.
- [FixCursorHold.nvim](https://github.com/antoinemadec/FixCursorHold.nvim) — CursorHold compatibility for test integrations.
- [nvim-nio](https://github.com/nvim-neotest/nvim-nio) — asynchronous utilities for testing and debugging.
- [nvim-coverage](https://github.com/andythigpen/nvim-coverage) — coverage display.
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) — debugger client.
- [nvim-dap-go](https://github.com/leoluz/nvim-dap-go) — Go debugger integration.
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) — debugger UI.
- [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text) — inline debugger values.

## Tests

Run from this directory:

```sh
sh tests/run.sh unit   # isolated unit and harness checks
sh tests/run.sh smoke  # isolated startup
sh tests/run.sh quick  # unit and startup (also the default)
sh tests/run.sh all    # all checks, including integration smoke tests
```

Smoke tests use temporary Neovim directories and download plugins. The full suite also needs Go, the Tree-sitter CLI, a C compiler, `make`, and network access; it can take considerably longer. Some language tooling and individual integrations have additional system dependencies.
