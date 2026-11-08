local servers = {
    "cssls", "dockerls", "gopls", "html", "jsonls", "lua_ls", "marksman",
    "rust_analyzer", "solidity", "taplo", "terraformls", "ts_ls", "vimls", "yamlls",
}

vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    flags = { debounce_text_changes = 150 },
})

vim.lsp.config("gopls", {
    cmd = { "gopls", "serve" },
    settings = {
        gopls = {
            analyses = { unreachable = true, unusedparams = true },
            staticcheck = true,
        },
    },
})

vim.lsp.config("yamlls", {
    settings = {
        yaml = {
            validate = true,
            hover = true,
            completion = true,
            format = { enable = true },
            schemas = {
                ["https://raw.githubusercontent.com/docker/cli/master/cli/compose/schema/data/config_schema_v3.9.json"] = "**/docker-compose.yml",
            },
        },
    },
})

vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 4, prefix = "●" },
    severity_sort = true,
    signs = { text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
    } },
})

require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_enable = false,
})

vim.lsp.enable(servers)
vim.lsp.enable("sqls")
