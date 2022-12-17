local opt = vim.opt
local g = vim.g

-- disable netrw 
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

opt.showmode = true
opt.laststatus = 3 -- global statusline

opt.title = true
opt.clipboard = "unnamedplus"
opt.cul = true -- cursor line

opt.number = true
opt.relativenumber = true

opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4

opt.wrap = false

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- opt.signcolumn = "yes"
opt.signcolumn = "auto:8"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.hlsearch = false
opt.incsearch = true

opt.scrolloff = 16

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 50

-- completeopt for abetter completion experience
opt.completeopt = 'menuone,noselect'

g.mapleader = " "
