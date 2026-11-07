local Colors = require("core.color")

require("scrollbar").setup({
    set_highlights = true,
    exclude = {
        buftypes = { terminal = true },
        filetypes = { prompt = true, TelescopePrompt = true, noice = true, harpoon = true },
    },
    providers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        search = false,
        marks = false,
    },
    marks = {
        Search = { text = { "-", "=" }, priority = 0, highlight = { fg = Colors.orange } },
        Error = { text = { "-", "=" }, priority = 1, highlight = { fg = Colors.error } },
        Warn = { text = { "-", "=" }, priority = 2, highlight = { fg = Colors.warn } },
        Info = { text = { "-", "=" }, priority = 3, highlight = { fg = Colors.info } },
        Hint = { text = { "-", "=" }, priority = 4, highlight = { fg = Colors.hint } },
        Misc = { text = { "-", "=" }, priority = 5, highlight = { fg = Colors.purple } },
        GitAdd = { text = "▎", priority = 7, highlight = "GitSignsAdd" },
        GitChange = { text = "▎", priority = 7, highlight = "GitSignsChange" },
        GitDelete = { text = "▁", priority = 7, highlight = "GitSignsDelete" },
    },
    scrollbar = {
        show = true,
        visibility = "all",
        max_lines = false,
        unit = "screenline",
        hide_on_cursor = false,
        thumb = { text = " ", highlight = "CursorColumn", hide_if_all_visible = true },
    },
})
