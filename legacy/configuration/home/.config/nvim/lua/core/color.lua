require("tokyonight").setup({
    style = "night",
    lualine_bold = true,
    transparent = false,
    terminal_colors = true,
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats = "dark",
    },
    on_highlights = function(hl, colors)
        hl.GitSignsAdd = { fg = colors.green }
        hl.GitSignsChange = { fg = colors.blue }
        hl.GitSignsDelete = { fg = colors.red1 }
        hl.DiffviewConflictOurs = { bg = colors.teal }
        hl.DiffviewConflictTheirs = { bg = colors.blue0 }
        hl.DiffviewConflictAncestor = { bg = colors.purple }
        hl.CmpBorder = { fg = colors.blue0 }
        hl.CmpDocBorder = { fg = colors.blue0 }
    end,
})
local Colors = require("tokyonight.colors").setup({})
local util = require("tokyonight.util")

vim.cmd [[colorscheme tokyonight]]

vim.api.nvim_set_hl(0, 'GitSignsAddNr', { fg = Colors.green })
vim.api.nvim_set_hl(0, 'GitSignsAddLn', { fg = Colors.green })
vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { fg = Colors.blue })
vim.api.nvim_set_hl(0, 'GitSignsChangeLn', { fg = Colors.blue })
vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { fg = Colors.red1 })
vim.api.nvim_set_hl(0, 'GitSignsDeleteLn', { fg = Colors.red1 })

vim.api.nvim_set_hl(0, 'ConflictMarkerCommonAncestorsHunk', { bg = util.darken(Colors.purple, 0.2) })
vim.api.nvim_set_hl(0, 'ConflictMarkerCommonAncestors', { bg = util.darken(Colors.purple, 0.4) })
vim.api.nvim_set_hl(0, 'ConflictMarkerSeparator', { bg = util.darken(Colors.purple, 0.4) })
vim.api.nvim_set_hl(0, 'ConflictMarkerOurs', { bg = util.darken(Colors.teal, 0.2) })
vim.api.nvim_set_hl(0, 'ConflictMarkerBegin', { bg = util.darken(Colors.teal, 0.4) })
vim.api.nvim_set_hl(0, 'ConflictMarkerTheirs', { bg = util.darken(Colors.blue0, 0.2) })
vim.api.nvim_set_hl(0, 'ConflictMarkerEnd', { bg = util.darken(Colors.blue0, 0.4) })

return Colors
