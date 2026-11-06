require("lspsaga").setup({
    ui = { border = "single" },
    symbol_in_winbar = { enable = false },
    lightbulb = { enable = true, enable_in_insert = true, sign = true, sign_priority = 20, virtual_text = true },
    code_action = { num_shortcut = true, keys = { quit = "<Esc>", exec = "<CR>" } },
    rename = { in_select = true, keys = { quit = "<C-c>", exec = "<CR>" } },
    finder = { keys = { toggle_or_open = "o", vsplit = "s", split = "i", tabe = "t", quit = "q" } },
})
