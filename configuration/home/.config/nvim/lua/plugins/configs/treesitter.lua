local present, treesitter = pcall(require, "nvim-treesitter.configs")

if not present then
    return
end

local options = {
    ensure_installed = {
        "bash",
        "cmake",
        "css",
        "go",
        "gomod",
        "gowork",
        "graphql",
        "help",
        "html",
        "javascript",
        "json",
        "json5",
        "jsonc",
        "lua",
        "make",
        "nix",
        "python",
        "solidity",
        "tsx",
        "typescript",
        "vim",
        "yaml",
    },
    ignore_install = { "php" },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<a-v>',
            node_incremental = '<a-v>',
            scope_incremental = '<a-c>',
            node_decremental = '<a-backspace>',
        },
    },
    indent = {
        enable = false, -- curretly experimental
        -- disable = { "go" }
    },
    highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = true
    },
    textobjects = {
        enable = true
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    }
}

treesitter.setup(options)
