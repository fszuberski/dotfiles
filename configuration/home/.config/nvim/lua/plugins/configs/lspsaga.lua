local present, saga = pcall(require, "lspsaga")

if not present then
    return
end

local options = {
    -- Options with default value
    -- "single" | "double" | "rounded" | "bold" | "plus"
    border_style = "single",
    --the range of 0 for fully opaque window (disabled) to 100 for fully
    --transparent background. Values between 0-30 are typically most useful.
    saga_winblend = 0,
    -- when cursor in saga window you config these to move
    move_in_saga = {
        prev = '<A-k>',
        next = '<A-j>'
    },
    -- Error, Warn, Info, Hint
    -- use emoji like
    -- { "🙀", "😿", "😾", "😺" }
    -- or
    -- { "😡", "😥", "😤", "😐" }
    -- and diagnostic_header can be a function type
    -- must return a string and when diagnostic_header
    -- is function type it will have a param `entry`
    -- entry is a table type has these filed
    -- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
    diagnostic_header = { " ", " ", " ", "ﴞ " },
    -- preview lines above of lsp_finder
    preview_lines_above = 0,
    -- preview lines of lsp_finder and definition preview
    max_preview_lines = 10,
    -- use emoji lightbulb in default
    code_action_icon = "💡",
    -- if true can press number to execute the codeaction in codeaction window
    code_action_num_shortcut = true,
    -- same as nvim-lightbulb but async
    code_action_lightbulb = {
        enable = true,
        enable_in_insert = true,
        -- turn on if code-action is slow
        cache_code_action = true,
        sign = true,
        sign_priority = 20,
        virtual_text = true,
    },
    -- finder icons
    finder_icons = {
        def = '  ',
        ref = '諭 ',
        link = '  ',
    },
    -- finder do lsp request timeout
    -- if your project is big enough or your server very slow
    -- you may need to increase this value
    finder_request_timeout = 1500,
    finder_action_keys = {
        open = { "o", "<CR>" },
        vsplit = "s",
        split = "i",
        tabe = "t",
        quit = { "q", "<ESC>" }, -- quit can be a table
        scroll_down = "<C-d>",
        scroll_up = "<C-u>",
    },
    code_action_keys = {
        quit = "<ESC>",
        exec = "<CR>",
    },
    definition_action_keys = {
        edit = '<C-c>o',
        vsplit = '<C-c>v',
        split = '<C-c>i',
        tabe = '<C-c>t',
        quit = 'q',
    },
    rename_action_quit = "<C-c>",
    rename_in_select = true,
    -- show symbols in winbar must nightly
    symbol_in_winbar = {
        in_custom = false,
        enable = false,
        separator = ' ',
        show_file = true,
        -- define how to customize filename, eg: %:., %
        -- if not set, use default value `%:t`
        -- more information see `vim.fn.expand` or `expand`
        -- ## only valid after set `show_file = true`
        file_formatter = "",
        click_support = false,
    },
    -- show outline
    show_outline = {
        win_position = 'right',
        --set special filetype win that outline window split.like NvimTree neotree
        -- defx, db_ui
        win_with = '',
        win_width = 30,
        auto_enter = true,
        auto_preview = true,
        virt_text = '┃',
        jump_key = 'o',
        -- auto refresh when change buffer
        auto_refresh = true,
    },
    -- custom lsp kind
    -- usage { Field = 'color code'} or {Field = {your icon, your color code}}
    custom_kind = {},
    -- if you don't use nvim-lspconfig you must pass your server name and
    -- the related filetypes into this table
    -- like server_filetype_map = { metals = { "sbt", "scala" } }
    server_filetype_map = {},
}

-- v2.3.0+
-- local options = {
--     preview = {
--         lines_above = 0,
--         lines_below = 10,
--     },
--     scroll_preview = {
--         scroll_down = '<C-f>',
--         scroll_up = '<C-b>',
--     },
--     request_timeout = 2000,
--     finder = {
--         edit = { 'o', '<CR>' },
--         vsplit = 's',
--         split = 'i',
--         tabe = 't',
--         quit = { 'q', '<ESC>' },
--     },
--     definition = {
--         edit = '<C-c>o',
--         vsplit = '<C-c>v',
--         split = '<C-c>i',
--         tabe = '<C-c>t',
--         quit = 'q',
--         close = '<Esc>',
--     },
--     code_action = {
--         num_shortcut = true,
--         keys = {
--             -- string |table type
--             quit = { 'q', '<ESC>', '<C-c>' },
--             exec = '<CR>',
--         },
--     },
--     lightbulb = {
--         enable = true,
--         enable_in_insert = true,
--         sign = true,
--         sign_priority = 40,
--         virtual_text = true,
--     },
--     diagnostic = {
--         show_code_action = true,
--         show_source = true,
--         jump_num_shortcut = true,
--         keys = {
--             exec_action = 'o',
--             quit = 'q',
--             go_action = 'g'
--         },
--     },
--     rename = {
--         quit = '<C-c>',
--         exec = '<CR>',
--         mark = 'x',
--         confirm = '<CR>',
--         in_select = true,
--     },
--     outline = {
--         win_position = 'right',
--         win_with = '',
--         win_width = 30,
--         show_detail = true,
--         auto_preview = true,
--         auto_refresh = true,
--         auto_close = true,
--         custom_sort = nil,
--         keys = {
--             jump = 'o',
--             expand_collapse = 'u',
--             quit = 'q',
--         },
--     },
--     callhierarchy = {
--         show_detail = true,
--         keys = {
--             edit = 'e',
--             vsplit = 'v',
--             split = 's',
--             tabe = 't',
--             jump = '<CR>',
--             quit = 'q',
--             expand_collapse = 'o',
--         },
--     },
--     symbol_in_winbar = {
--         enable = false,
--         separator = ' / ',
--         hide_keyword = true,
--         show_file = true,
--         folder_level = 10,
--         respect_root = true,
--         color_mode = false,
--     },
--     ui = {
--         -- currently only round theme
--         theme = 'round',
--         -- this option only work in neovim 0.9
--         title = true,
--         -- border type can be single,double,rounded,solid,shadow.
--         border = 'single',
--         winblend = 0,
--         expand = '',
--         collapse = '',
--         preview = ' ',
--         code_action = '💡',
--         diagnostic = '🐞',
--         incoming = ' ',
--         outgoing = ' ',
--         colors = {
--             --float window normal background color
--             normal_bg = '#1d1536',
--             --title background color
--             title_bg = '#afd700',
--             red = Colors.red,
--             magenta = Colors.magenta,
--             orange = Colors.orange,
--             yellow = Colors.yellow,
--             green = Colors.green,
--             cyan = Colors.cyan,
--             blue = Colors.blue,
--             purple = Colors.purple,
--             white = '#d1d4cf',
--             black = '#1c1c19',
--         },
--         kind = {},
--     },
-- }

-- use custom config
saga.init_lsp_saga(options)
-- v2.3.0+
-- saga.setup(options)
