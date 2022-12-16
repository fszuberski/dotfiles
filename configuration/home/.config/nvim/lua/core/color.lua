vim.g.tokyonight_lualine_bold = true
Colors = require("tokyonight.colors").setup({}) -- pass in any of the config options as explained above
local util = require("tokyonight.util")

vim.cmd [[colorscheme tokyonight]]

vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = Colors.green })
vim.api.nvim_set_hl(0, 'GitSignsAddNr', { fg = Colors.green })
vim.api.nvim_set_hl(0, 'GitSignsAddLn', { fg = Colors.green })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = Colors.blue })
vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { fg = Colors.blue })
vim.api.nvim_set_hl(0, 'GitSignsChangeLn', { fg = Colors.blue })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = Colors.red1 })
vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { fg = Colors.red1 })
vim.api.nvim_set_hl(0, 'GitSignsDeleteLn', { fg = Colors.red1 })

vim.api.nvim_set_hl(0, 'ConflictMarkerCommonAncestorsHunk', { bg = util.darken(Colors.purple, 0.2) })
vim.api.nvim_set_hl(0, 'ConflictMarkerCommonAncestors', { bg = util.darken(Colors.purple, 0.4) })
vim.api.nvim_set_hl(0, 'ConflictMarkerSeparator', { bg = util.darken(Colors.purple, 0.4) })
vim.api.nvim_set_hl(0, 'ConflictMarkerOurs', { bg = util.darken(Colors.teal, 0.2) })
vim.api.nvim_set_hl(0, 'ConflictMarkerBegin', { bg = util.darken(Colors.teal, 0.4) })
vim.api.nvim_set_hl(0, 'ConflictMarkerTheirs', { bg = util.darken(Colors.blue0, 0.2) })
vim.api.nvim_set_hl(0, 'ConflictMarkerEnd', { bg = util.darken(Colors.blue0, 0.4) })

vim.api.nvim_set_hl(0, 'CmpBorder', { fg = util.darken(Colors.fg_gutter, 0.4) })
vim.api.nvim_set_hl(0, 'CmpDocBorder', { fg = util.darken(Colors.fg_gutter, 0.4) })

