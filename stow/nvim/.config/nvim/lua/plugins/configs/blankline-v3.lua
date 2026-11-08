require("ibl").setup({
    exclude = {
        filetypes = {
            "help",
            "terminal",
            "alpha",
            "packer",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "lsp-installer",
            "",
        },
        buftypes = { "terminal" },
    },
    scope = {
        enabled = true,
        show_start = false,
    },
})
